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

/* cache update interval in seconds */
const double URLCacheInterval = 86400.0;
//extern NSString *NSWindowDidBecomeMainNotification;

@implementation ImageViewAppDelegate

@synthesize is_login;
@synthesize m_id,p_id,f_id,m_name,team1_points,team2_points, player_points;
@synthesize img_URL;
@synthesize window;
@synthesize viewController;
@synthesize viewPickerController;
@synthesize viewLoadController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch  

	[window addSubview:viewController.view];
	
	/* set initial state of network activity indicators */
	[self stopAnimation];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[window setBackgroundColor:[UIColor blackColor]];
    [window makeKeyAndVisible];	
	
}



- (void)flipView:(int) onFront
{
	
	if (onFront == 1) //uploadPic
	{
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.viewController.view cache:YES];
		[viewController.view removeFromSuperview];
		[window addSubview:viewPickerController.view];
		viewPickerController.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[viewPickerController presentModalViewController:viewPickerController.imgPicker animated:YES];
		onFront = 0;
	}
	else if (onFront == 2) //takePic
	{
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.viewController.view cache:YES];
		[viewController.view removeFromSuperview];
		[window addSubview:viewPickerController.view];
		viewPickerController.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[viewPickerController presentModalViewController:viewPickerController.imgPicker animated:YES];
		onFront = 0;
	}
	else if (onFront == 3) //after load
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:2.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.viewController.view cache:YES];
		[viewLoadController.view removeFromSuperview];
		[window addSubview:viewController.view];
		//		[backView removeFromSuperview];
		//		[self addSubview:frontView];
		onFront = 1;
		[UIView commitAnimations];
	}
	else
	{
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.viewController.view cache:YES];
		[viewPickerController.view removeFromSuperview];
		[window addSubview:viewController.view];
		//		[backView removeFromSuperview];
		//		[self addSubview:frontView];
		onFront = 1;
	}
	
	
}


- (void)dealloc {
    [viewController release];
	//[myViewController release];
	[viewPickerController release];
	[viewLoadController release];
	
	
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
