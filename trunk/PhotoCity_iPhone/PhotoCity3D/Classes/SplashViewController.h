//
//  SplashViewController.h
//  iTennis
//
//  Created by Brandon Trebitowski on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewViewController.h"

@class ImageViewAppDelegate;

@interface SplashViewController : UIViewController {
	NSTimer *timer;
	UIImageView *splashImageView;
	ImageViewAppDelegate *theDelegate;
	UIActivityIndicatorView *splashActInd;
	
}

@property (nonatomic, retain) UIActivityIndicatorView *splashActInd;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) UIImageView *splashImageView;
@property (nonatomic, retain) ImageViewAppDelegate *theDelegate;

@end
