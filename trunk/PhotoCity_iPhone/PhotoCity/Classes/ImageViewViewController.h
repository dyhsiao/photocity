#import <UIKit/UIKit.h>
#import "GYImageView.h"



@interface ImageViewViewController : UIViewController {
	IBOutlet GYImageView *imageView;
	UIActivityIndicatorView *myActivityIndicator;
	
	
	
}

@property (nonatomic, retain) UIActivityIndicatorView *myActivityIndicator;



- (void)loadActivityInd;


@end

