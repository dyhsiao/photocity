//
//  SplashViewController.m
//  iTennis
//
//  Created by Brandon Trebitowski on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"
#import "ImageViewAppDelegate.h"
#import "testPickerViewController.h"

@implementation SplashViewController

@synthesize timer,splashImageView,theDelegate,splashActInd;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
	theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	// Init the view
	
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:appFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];

	splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Splash.png"]];
	splashImageView.frame = CGRectMake(0, 20, 320, 460);
	[theDelegate.window addSubview:splashImageView];
	
	splashActInd = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(208, 215, 24, 24)];
	splashActInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[splashActInd startAnimating];
	splashActInd.hidden=NO;
	[theDelegate.window addSubview:splashActInd];
	[splashActInd release];
	
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

-(void) onTimer{
	NSLog(@"LOAD");
}

- (void)fadeScreen
{
	
	[theDelegate.window addSubview:theDelegate.viewLibPickerController.view];
	[theDelegate.window addSubview:theDelegate.viewPickerController.view];
	[theDelegate.window addSubview:theDelegate.viewController.view];
	[theDelegate.window bringSubviewToFront:splashImageView];
	
	[theDelegate restoreState];
	theDelegate.queue_count=0;
	theDelegate.queue_total=0;
	theDelegate.viewController.qProgressIndicator.hidden=YES;
	
	[splashActInd stopAnimating];
	splashActInd.hidden = YES;
	
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.9];        // sets animation duration
	[UIView setAnimationDelegate:self];        // sets delegate for this block

	splashImageView.alpha = 0.0;	

	[UIView commitAnimations];   // commits the animation block.  This Block is done.
}


- (void) finishedFading
{

	
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.9];        // sets animation duration
	theDelegate.viewController.view.alpha = 1.0;
	theDelegate.viewPickerController.view.alpha = 1.0;
	theDelegate.viewLibPickerController.view.alpha = 1.0;
	self.view.alpha = 1.0;   // fades the view to 1.0 alpha over 0.75 seconds
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
	[splashImageView removeFromSuperview];

}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
