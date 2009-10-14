#import "ImageViewViewController.h"
#import "EAGLView.h"


@implementation ImageViewViewController

@synthesize myActivityIndicator;
@synthesize qProgressIndicator;
@synthesize glView;
@synthesize viewTouch;


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
- (void)viewDidLoad
{
	
	//[self loadActivityInd];
	//[myActivityIndicator startAnimating];
	
  [super viewDidLoad];

//  NSString *path = [[NSBundle mainBundle] pathForResource:@"Brickn1" ofType:@"jpg"];
//  CGDataProviderRef provider = CGDataProviderCreateWithFilename([path UTF8String]);
 // CGImageRef img = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
	
  
//  imageView.CGImage = img;
//  CGImageRelease(img);
//  CGDataProviderRelease(provider);
  
//  imageView.maximumZoomScale = 6.0;
//  imageView.minimumZoomScale = 0.8;
	
	[imageView updateImageView];
	
	//glView.animationInterval = 5.0 / 1.0;
	//[glView startAnimation];

}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [imageView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];   // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

- (void)loadActivityInd
{
	//Initalizing
	myActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	//Center to view
	myActivityIndicator.center = self.view.center;
	myActivityIndicator. autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	//Add to view
	[self.view addSubview:myActivityIndicator];
}


- (void)dealloc
{


	[myActivityIndicator release];
	[viewTouch release];
	[glView release];
	[super dealloc];

}

@end
