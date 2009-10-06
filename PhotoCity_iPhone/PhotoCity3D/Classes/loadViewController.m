//
//  loadViewController.m
//  ImageView
//
//  Created by Dun-Yu Hsiao on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "loadViewController.h"
#import "ImageViewAppDelegate.h"

@implementation loadViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	//Initalizing
	UIActivityIndicatorView *myActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	//Center to view
	myActivityIndicator.center = self.view.center;
	myActivityIndicator. autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	
	
	//Add to view
	[self.view addSubview:myActivityIndicator];

	[myActivityIndicator startAnimating];
	
	//ImageViewAppDelegate *theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//[theDelegate flipView:3];
}


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
