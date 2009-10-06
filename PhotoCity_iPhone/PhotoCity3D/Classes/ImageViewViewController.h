#import <UIKit/UIKit.h>
#import "GYImageView.h"

@class EAGLView;

@interface ImageViewViewController : UIViewController {
	IBOutlet GYImageView *imageView;
	UIActivityIndicatorView *myActivityIndicator;
	IBOutlet UIProgressView *qProgressIndicator;

	EAGLView *glView;
}

@property (nonatomic, retain) UIActivityIndicatorView *myActivityIndicator;
@property (nonatomic, retain) UIProgressView *qProgressIndicator;
@property (nonatomic, retain) IBOutlet EAGLView *glView;


- (void)loadActivityInd;

@end

