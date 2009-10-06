#import "testPickerViewController.h"
#import "ImageViewAppDelegate.h"

@implementation testPickerViewController

@synthesize imgPicker, grabBtn, uploadBtn, mapBtn;//, tabBar;


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
 
 
 
- (void)viewDidLoad {
	self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsImageEditing = YES;
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
	//[tabBar release];
	[super dealloc];
	
}


- (IBAction)grabImage {
	[self presentModalViewController:self.imgPicker animated:YES];
}


- (IBAction)returnMap {
	ImageViewAppDelegate *theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	[theDelegate flipView:0];
	//[theDelegate release];
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



-(NSMutableData *)generateDataFromText:(NSString *)dataText fieldName:(NSString *)fieldName{
	NSString *post = [NSString stringWithFormat:@"--AaB03x\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", fieldName];
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    
	NSData *uploadData = [dataText dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
    // Add the text:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

- (NSData *)generatePostDataForData:(NSData *)uploadData fileName:(NSString *)fileName
{
    // Generate the post header:
	
    NSString *post = [NSString stringWithFormat:@"--AaB03x\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", fileName];
    
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    
    // Add the image:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

- (IBAction)uploadImage {
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
	*/
	
	NSData *imageData = UIImageJPEGRepresentation(image.image, 90);
	
	ImageViewAppDelegate *tDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[tDelegate startAnimation];

	
	//Fill some text fields
	
	//NSString *model_id = (NSString *)[tDelegate m_id];
	NSMutableData *postData = [self generateDataFromText:[NSString stringWithFormat:@"%d", tDelegate.p_id] fieldName:@"owner"];
	//[postData appendData:[self generateDataFromText:@"10000000" fieldName:@"MAX_FILE_SIZE"]];
	[postData appendData:[self generateDataFromText:[NSString stringWithFormat:@"%d", tDelegate.m_id]  fieldName:@"model_id"]];
	//[postData appendData:[self generateDataFromText:[[NSUserDefaults standardUserDefaults] stringForKey:@"name_preference"] fieldName:@"from_name"]];
	//[postData appendData:[self generateDataFromText:[[NSUserDefaults standardUserDefaults] stringForKey:@"email_preference"] fieldName:@"from_email"]];
	//[postData appendData:[self generateDataFromText:currentEmail.emailSubject fieldName:@"subject"]];
	//[postData appendData:[self generateDataFromText:emailBody fieldName:@"body"]];
	[postData appendData:[self generateDataFromText:@"ipod_dyh_test" fieldName:@"file_name"]];
	
	//Prepare data for file
	//NSData *dataObj = [NSData dataWithContentsOfFile:@"/link/to/file"];
	
	//[postData appendData:[self generateDataFromText:@"123" fieldName:@"file_data"]];
	[postData appendData:[self generatePostDataForData:imageData fileName:@"file_data"]];
	
	// Setup the request:
	NSString *urlString = @"http://fusion.cs.washington.edu:8000/images/add";
	//NSString *urlString = @"http://www.postbin.org/syzsnx";
	NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 30 ] autorelease];
	[uploadRequest setHTTPMethod:@"POST"];
	[uploadRequest setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
	[uploadRequest setHTTPBody: postData];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:nil error:nil];
	NSLog([[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
	
	[tDelegate stopAnimation];
	uploadBtn.enabled=NO; 
	uploadBtn.badgeValue=@"Done";
	grabBtn.enabled = YES;
	mapBtn.enabled = YES;

	
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	image.image = img;	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	
	// need to show the upload image button now
	if ( img.size.width != 0 )
	{
		uploadBtn.enabled = YES;
		uploadBtn.badgeValue = @"Ready";
	}
	
	grabBtn.enabled = YES;
	
	
}

@end
