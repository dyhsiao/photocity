#import "testPickerViewController.h"
#import "ImageViewAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

@implementation testPickerViewController


#define SELECTEDIMGPATH NSHomeDirectory()  
#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] 

@synthesize imgPicker, grabBtn, uploadBtn, mapBtn, theDelegate, uniquePathOld, pool;//, tabBar;

NSString *Restart = @"RESTART";

/*
-(void)loadView
{
    [super loadView];
	self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsImageEditing = YES;
	self.imgPicker.delegate = self;	
	grabBtn.enabled = YES;
	uploadBtn.enabled = NO;
	}
*/
 
- (void)awakeFromNib
{
//	networkQueue = [[ASINetworkQueue alloc] init];
}
 
 
- (void)viewDidLoad {
	
	theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartNotif:) name:Restart object:nil];
	
	self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsImageEditing = NO;
	self.imgPicker.delegate = self;	
	grabBtn.enabled = YES;
	uploadBtn.enabled = NO;

	/*
	UIView *tabBar = [self rotatingFooterView];
    if ([tabBar isKindOfClass:[UITabBar class]]) {
        ((UITabBar *)tabBar).delegate = self;
    }
*/
	//[self presentModalViewController:self.imgPicker animated:YES];
	
	
}

- (void)dealloc
{
	
//	[networkQueue release];
	[imgPicker release];
	[uniquePathOld release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Restart object:nil];
	[theDelegate release];
	[super dealloc];
	
}


- (IBAction)grabImage {
	[self presentModalViewController:self.imgPicker animated:YES];

}


- (IBAction)returnMap {
	
	if (theDelegate.queue_count!=0)
	{
		alert = [[UIAlertView alloc] initWithTitle:@"Photo in Queue"  
									   message:@"\nThere is photo in uploading queue, please check queue indicator below to see if it is finished. Queued photo will be lost if exiting PhotoCity before transfer finishes."  
									  delegate:nil  
							 cancelButtonTitle:NSLocalizedString(@"OK", @"")  
							 otherButtonTitles:nil];  
		[alert show];  
		[alert release];
		[theDelegate updateQueue];
	}
	[pool release];
	[theDelegate flipView:0];
	
	//[theDelegate release];
}

- (void)restartNotif:(NSNotification *)aNotification
{
	[self grabImage];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	//NSLog(@"tabbar");
    NSString *title =  item.title;
	if ( [title isEqualToString:@"Grab Another Image"] )
	{
		//NSLog(@"%s", title);
		[self grabImage];
	}
	else if ([title isEqualToString:@"Upload Image"] )
	{
		
		uploadBtn.badgeValue = @"Uploading...";
		grabBtn.enabled = NO;
		mapBtn.enabled = NO;
		uploadBtn.enabled = NO;
	
		[self uploadImage];
	}
	else if ( [title isEqualToString:@"Back to Map"] )
	{
		[self returnMap];
	}
	
	
	
}


- (IBAction)uploadImage {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[theDelegate startAnimation];
	networkQueue = [[ASINetworkQueue alloc] init];
	//[networkQueue cancelAllOperations];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setUploadProgressDelegate:progressIndicator];
	[networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];	
	[networkQueue setDelegate:self];
	
	theDelegate.queue_count++;
	theDelegate.queue_total++;
	
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://fusion.cs.washington.edu:8000/images/add"]] autorelease];

	[request setShouldStreamPostDataFromDisk:YES];
	[request setPostValue:[NSString stringWithFormat:@"%d", theDelegate.p_id] forKey:@"owner"];
	[request setPostValue:[NSString stringWithFormat:@"%d", theDelegate.m_id] forKey:@"model_id"];
	[request setPostValue:@"iphone_app" forKey:@"file_name"];

	
	
	[request setTimeOutSeconds:20];
	
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.jpg"];
	[request setFile:uniquePath forKey:@"file_data"];
	
	[networkQueue addOperation:request];
	[networkQueue go];

	[pool release];
	[networkQueue autorelease];
	
	//postData = [[NSMutableData alloc] initWithLength:0];
	

}



-(void)popupActionSheet {
	
    UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Back to Map"
								 destructiveButtonTitle:@"Grab Another Image"
								 otherButtonTitles:nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
    [popupQuery release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	image.image=nil;
    if (buttonIndex == 1) {
		//[alert dismissWithClickedButtonIndex:0 animated:TRUE];
		[self returnMap];
    } else if (buttonIndex == 0) {
		//[alert dismissWithClickedButtonIndex:0 animated:TRUE];
		[self grabImage];
    }
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {

	progressIndicator.progress=0.0f;
	[picker dismissModalViewControllerAnimated:YES];
		UIImage *oimg = [editInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
	
    
	save_flag = 0;
	
	
	
	//Save image to iphone
	if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera )
	{
		UIImageWriteToSavedPhotosAlbum(oimg, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
	}
	else
	{
		
		[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(imageUploadToServer) userInfo:nil repeats:false];
	}
	
	image.image = oimg;	
	
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	
	progressIndicator.progress=0.0f;

	//Save image to iphone
	
//	if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera )
//	{
//		
//		alert = [[UIAlertView alloc] initWithTitle:@"Saving & Uploading Photo" 
//										   message:@"\n    Saving & Uploading...   \n\n Please wait for the program saving the photo to Camera Roll and uploading it to the PhotoCity server. \n\n The waiting time depends on the quality and speed of your connection."
//										  delegate:nil  
//								 cancelButtonTitle:nil//NSLocalizedString(@"OK", @"")  
//								 otherButtonTitles:nil];  
//		[alert show];  
//	}
//	else
//	{
//		alert = [[UIAlertView alloc] initWithTitle:@"Uploading Photo" 
//										   message:@"\n    Uploading...   \n\n Please wait for the program uploading the photo to the PhotoCity server. \n\n The waiting time depends on the quality and speed of your connection."
//										  delegate:nil  
//								 cancelButtonTitle:nil//NSLocalizedString(@"OK", @"")  
//								 otherButtonTitles:nil];  
//		[alert show];  
//		
//	}

	[picker dismissModalViewControllerAnimated:YES];
	
	UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	//UIImage *cimg = [info objectForKey:@"UIImagePickerControllerCropRect"];
	
    
	save_flag = 0;

	
	
	//Save image to iphone
	if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera )
	{
		//upload image/pop up action sheet in the call
		UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
		//UIImageWriteToSavedPhotosAlbum(orig, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
	}
	else
	{
		
		[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(imageUploadToServer) userInfo:nil repeats:false];
		//[self performSelectorInBackground:@selector(imageUploadToServer) withObject:nil];
		
	//	[self uploadImage];	
	//	[self popupActionSheet];
	}
	
	image.image = img;	
	
}

- (void)imageUploadToServer
{
	[theDelegate startAnimation];
	// save selected image (but no help in reducing upload size?)
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.jpg"];
	[UIImageJPEGRepresentation(image.image,70) writeToFile:uniquePath  atomically:YES]; 
	
	[self uploadImage];
	
    NSString *message;  
    NSString *title;  
	title = NSLocalizedString(@"Upload OK!", @"");  
    message = NSLocalizedString(@"\nCongratulations!\n\nSuccessfully tranferred the photo to PhotoCity server!", @"");  
    
	//[alert dismissWithClickedButtonIndex:0 animated:TRUE];
	/*
	alert = [[UIAlertView alloc] initWithTitle:title  
									   message:message  
									  delegate:nil  
							 cancelButtonTitle:nil//NSLocalizedString(@"OK", @"")  
							 otherButtonTitles:nil];  
	[alert show];  
    [alert release];
	 */
	save_flag=1;
	[self popupActionSheet];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)img didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
	[theDelegate startAnimation];
	// save selected image (but no help in reducing upload size?)
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.jpg"];
	[UIImageJPEGRepresentation(image.image,70) writeToFile:uniquePath  atomically:YES]; 
	[self uploadImage];
	
    NSString *message;  
    NSString *title;  
    if (!error) {  
        title = NSLocalizedString(@"Save & Upload OK!", @"");  
        message = NSLocalizedString(@"\nCongratulations!\n\nSuccessfully saved the photo to Camera Roll and tranferred it to PhotoCity server!", @"");  
    } else {  
        title = NSLocalizedString(@"Save Failed", @"");  
        message = [error description];  
    }  
    
	//[alert dismissWithClickedButtonIndex:0 animated:TRUE];
/*
	alert = [[UIAlertView alloc] initWithTitle:title  
                                                    message:message  
                                                   delegate:nil  
										  cancelButtonTitle:nil//NSLocalizedString(@"OK", @"")  
                                          otherButtonTitles:nil];  
	[alert show];  
    [alert release];
 */
	save_flag=1;
	[self popupActionSheet];
}  

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)CurrentPicker {
    //hide the picker if user cancels picking an image.
	[[CurrentPicker parentViewController] dismissModalViewControllerAnimated:YES];
	[self returnMap];
}

/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	UINavigationItem *ipcNavBarTopItem;
	
	// add done button to right side of nav bar
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																   style:UIBarButtonItemStylePlain 
																  target:self 
																  action:@selector(saveImages:)];
	
	UINavigationBar *bar = navigationController.navigationBar;
	[bar setHidden:NO];
	ipcNavBarTopItem = bar.topItem;
	ipcNavBarTopItem.title = @"Pick Images";
	ipcNavBarTopItem.rightBarButtonItem = doneButton;
}
*/

- (void)queueFinished:(ASINetworkQueue *)queue
{
	theDelegate.queue_count--;
	[theDelegate updateQueue];
	NSLog(@"queue #:%d\n",theDelegate.queue_count);
	if (theDelegate.queue_count==0)
	{
		NSLog(@"queue empty");
		theDelegate.queue_total = 0;
		[theDelegate stopAnimation];
	}

}

@end
