//
//  ImageViewAppDelegate.m
//  ImageView
//
//  Created by Nicolas Goy on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ImageViewAppDelegate.h"
#import "ImageViewViewController.h"
#import "testPickerViewController.h"
#import "loadViewController.h"
#import "SplashViewController.h"
#import "PersonalViewController.h"

/* cache update interval in seconds */
const double URLCacheInterval = 86400.0;
//extern NSString *NSWindowDidBecomeMainNotification;

@implementation ImageViewAppDelegate

@synthesize is_login;
@synthesize queue_count;
@synthesize queue_total;
@synthesize lastLocationX,lastLocationY,lastLocation,instruction_ind, updateLoc_ind;
@synthesize m_id,p_id,f_id,m_name,p_name, p_pswd,perf_ind,team1_points,team2_points, team3_points,team4_points, player_points;
@synthesize img_URL;
@synthesize window;
@synthesize viewController;
@synthesize viewPickerController;
@synthesize viewLibPickerController;
@synthesize viewLoadController;
@synthesize viewSController;
@synthesize viewPController;

//JSON
@synthesize jArray;
@synthesize jFArray;
@synthesize jUArray;
@synthesize jUFArray;
@synthesize jTFArray;

@synthesize minLatLon,maxLatLon,s_btnLoc,movingCenter;
@synthesize touchEndPoint, touchMovingPoint, touchStartPoint, touchStatus;
@synthesize vertexBuffer_1, vertexBuffer_2, vertexBuffer_3, vertexBuffer_4,vertexCount_1,count_1,i_1,vertexCount_2,count_2,i_2,vertexCount_3,count_3,i_3,vertexCount_4,count_4,i_4,vertexMax_1,vertexMax_2,vertexMax_3,vertexMax_4;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch  
//	[window addSubview:viewLibPickerController.view];
//	[window addSubview:viewPickerController.view];
//	[window addSubview:viewController.view];
	viewSController = [[SplashViewController alloc] init];
	[window addSubview:viewSController.view];
	
	
	
	/* set initial state of network activity indicators */
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[window setBackgroundColor:[UIColor blackColor]];
    [window makeKeyAndVisible];	

	
}

- (void)updateProg{

	if (oldProg < prog)
	{
	oldProg+=0.01;
	viewController.qProgressIndicator.progress = oldProg;
	}
	if (oldProg >= prog) {
//		[pTimer invalidate];
	}
	if (oldProg >= 1)
	{
		viewController.qProgressIndicator.hidden=YES;
	}
}

- (void)updateQueue{
	viewController.qProgressIndicator.hidden=NO;
	prog = 1-(float)queue_count/queue_total;
	oldProg = 1-(float)(queue_count+1)/queue_total;
	pTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProg) userInfo:nil repeats:YES];
	
}

- (void)flipView:(int) onFront
{
	
	if (onFront == 1) //uploadPic
	{
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.viewController.view cache:YES];
		//[viewPickerController.view removeFromSuperview];
		//[window addSubview:viewPickerController.view];
		[window bringSubviewToFront:viewPickerController.view];
		if ( [viewPickerController.imgPicker sourceType]!= UIImagePickerControllerSourceTypePhotoLibrary )
		{
			viewPickerController.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		[viewPickerController presentModalViewController:viewPickerController.imgPicker animated:YES];
		//onFront = 0;
	}
	else if (onFront == 2) //takePic
	{
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.viewController.view cache:YES];
//		[viewController.view removeFromSuperview];
//		[window addSubview:viewPickerController.view];
		[window bringSubviewToFront:viewPickerController.view];
		if ([viewPickerController.imgPicker sourceType] != UIImagePickerControllerSourceTypeCamera)
		{
			viewPickerController.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
		[viewPickerController presentModalViewController:viewPickerController.imgPicker animated:YES];
		//onFront = 0;
	}
	else if (onFront == 3) //status page
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.40];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES]; 
		[window bringSubviewToFront:viewPController.view];
		[UIView commitAnimations];
	}
	else if (onFront == 4) //go back to main page
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.40];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES]; 
		[window bringSubviewToFront:viewController.view];
		[UIView commitAnimations];
	}
	else
	{
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.viewController.view cache:YES];
//		[viewPickerController.view removeFromSuperview];
//		[window addSubview:viewController.view];
		[window bringSubviewToFront:viewController.view];
		
		//		[backView removeFromSuperview];
		//		[self addSubview:frontView];
		//onFront = 0;
	}
	
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self saveState];
}

- (void)saveState {

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// saving an NSString
	[prefs setObject:p_name forKey:@"userID"];
	//NSLog(@"userID, %s",[ p_name cString]);
	[prefs setObject:p_pswd forKey:@"userPSWD"];
	//NSLog(@"userPSWD, %s", [p_pswd cString]);
	// saving an NSInteger
	[prefs setInteger:instruction_ind forKey:@"instruction"];
	//[prefs setInteger:p_id forKey:@"player_id"];
	// saving a Double
	//[prefs setDouble:3.1415 forKey:@"doubleKey"];
	// saving a Float
	//[prefs setFloat:1.2345678 forKey:@"floatKey"];
	
	[prefs setDouble:lastLocationX forKey:@"lastLocationX"];
	[prefs setDouble:lastLocationY forKey:@"lastLocationY"];
	[prefs setFloat:maxLatLon.x forKey:@"maxLatLon_x"];
	[prefs setFloat:maxLatLon.y forKey:@"maxLatLon_y"];
	[prefs setFloat:minLatLon.x forKey:@"minLatLon_x"];
	[prefs setFloat:minLatLon.y forKey:@"minLatLon_y"];
	// This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
	[prefs synchronize];
}

- (void)restoreState {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// getting an NSString
	p_name = [prefs stringForKey:@"userID"];
	NSLog(@"userID start, %s", [p_name cString]);
	p_pswd = [prefs stringForKey:@"userPSWD"];
	NSLog(@"userPSWD start, %s", [p_pswd cString]);
	// getting an NSInteger
	//is_login = [prefs integerForKey:@"is_login"];
	//NSLog(@"is login %d", [prefs integerForKey:@"is_login"]);
	instruction_ind = [prefs integerForKey:@"instruction"];
	

	
	// getting an Float
	lastLocationX = [prefs doubleForKey:@"lastLocationX"];
	lastLocationY = [prefs doubleForKey:@"lastLocationY"];
	minLatLon.x = [prefs floatForKey:@"minLatLon_x"];
	minLatLon.y = [prefs floatForKey:@"minLatLon_y"];
	maxLatLon.x = [prefs floatForKey:@"maxLatLon_x"];
	maxLatLon.y = [prefs floatForKey:@"maxLatLon_y"];
}


- (void)dealloc {
    [viewController release];
	//[myViewController release];
	[viewLibPickerController release];
	[viewPickerController release];
	[viewLoadController release];
	[viewSController release];
	[viewPController release];
	
	//JSON
	
	[jArray release];
	[jTFArray release];
	[jUFArray release];
	[jUArray release];
	[jFArray release];
	
	
    [window release];
    [super dealloc];
}

/////////////////URLCACHE



/*
 ------------------------------------------------------------------------
 Private methods used only in this file
 ------------------------------------------------------------------------
 */

#pragma mark -
#pragma mark Private methods


/* show the user that loading activity has started */

- (void) startAnimation
{
	//[self.activityIndicator startAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}


/* show the user that loading activity has stopped */

- (void) stopAnimation
{
	//[self.activityIndicator stopAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}


/////////////////URLCACHE




@end
