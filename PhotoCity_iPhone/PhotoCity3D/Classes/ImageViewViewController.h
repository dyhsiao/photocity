#import <UIKit/UIKit.h>
#import "GYImageView.h"

@class EAGLView;
@class UIViewTouch;

@interface ImageViewViewController : UIViewController {
	IBOutlet GYImageView *imageView;
	UIActivityIndicatorView *myActivityIndicator;
	IBOutlet UIProgressView *qProgressIndicator;

	EAGLView *glView;
	UIViewTouch *viewTouch;
}

@property (nonatomic, retain) UIActivityIndicatorView *myActivityIndicator;
@property (nonatomic, retain) UIProgressView *qProgressIndicator;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, retain) IBOutlet UIViewTouch *viewTouch;

- (void)loadActivityInd;

@end

