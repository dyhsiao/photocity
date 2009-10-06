
#import <UIKit/UIKit.h>
//#import <AudioToolbox/AudioServices.h>

@class HoverView;
@class GYImageView;
@class ImageViewAppDelegate;
//@class URLCacheAppDelegate;

extern NSString *Show_HoverView;
extern NSString *Show_LoginView;

@protocol GYImageViewDelegate<NSObject>

@optional
- (void)imageViewWillUpdate:(GYImageView*)view;
- (void)imageViewDidUpdate:(GYImageView*)view;

- (void)imageViewWillUpdateDetailed:(GYImageView*)view;
- (void)imageViewDidUpdateDetailed:(GYImageView*)view;


- (void)imageViewWillZoom:(GYImageView*)view;
- (void)imageViewDidEndZooming:(GYImageView*)view atScale:(float)scale;

- (void)imageViewDidScroll:(GYImageView*)view;

@end

@interface GYImageView : UIScrollView <UIScrollViewDelegate> {
  CGImageRef rawImage;
  UIView *contentView;
  UIImageView *imageView;
  UIImageView *detailedImageView;
  CGFloat scale;
  id<GYImageViewDelegate> imageViewDelegate;
	ImageViewAppDelegate *theDelegate;
	//URLCacheAppDelegate *urlDelegate;
	
	//views
	IBOutlet HoverView *hoverView;
	IBOutlet HoverView *loginView;
	IBOutlet HoverView *webViewFrame;
	IBOutlet UIWebView *webView;
	
	//hoverView
	UIButton *focusFlag;
	IBOutlet UIButton *close_btn;
	IBOutlet UILabel *t1PointsLabel;
	IBOutlet UILabel *t2PointsLabel;
	IBOutlet UILabel *playerPointsLabel;
	IBOutlet UIButton *playerPoints;
	IBOutlet UIImageView *infoView;
	IBOutlet UILabel *modelName;
	IBOutlet UILabel *flagNumber;
	IBOutlet UIButton *t1Points;
	IBOutlet UIButton *t2Points;
	
	//webView
	IBOutlet UIButton *closeW_btn;

	//loginView
	IBOutlet UIButton *closeL_btn;
	IBOutlet UITextField *userID;
	IBOutlet UITextField *userPSWD;
	IBOutlet UIButton *login_btn;
	IBOutlet UIButton *signUp_btn;
	
	
	NSTimer* myTimer;
	IBOutlet UIButton *more_btn;
	
	//JSON
	NSMutableArray *jsonArray;
	NSMutableArray *jsonFArray;
	NSMutableArray *jsonUArray;
	
	NSString *site;
	NSInteger imgSize;
	CGPoint maxBound;
	CGPoint minBound;
	CGPoint positionvertex;
	NSMutableArray *overlay_images; 

	//Tabbar
	IBOutlet UITabBarItem *uploadButton;
	IBOutlet UITabBarItem *captureButton;
	IBOutlet UITabBarItem *playerStatus;
	IBOutlet UITabBarItem *serverButton;
	
	//Toolbar
	IBOutlet UIBarButtonItem *reloadButton;
	IBOutlet UIBarButtonItem *showModelsButton;
	IBOutlet UIBarButtonItem *loginButton;
	
	//indicators
    int disp_ind;
	int check_focusFlag;
	int dispStatus_ind;
	int server_ind;

}

@property (assign, nonatomic) CGImageRef CGImage;
@property (assign, nonatomic, readonly) CGFloat scale;
@property (assign, nonatomic) id<GYImageViewDelegate> imageViewDelegate;
@property (assign, nonatomic) ImageViewAppDelegate *theDelegate;
//@property (assign, nonatomic) URLCacheAppDelegate *urlDelegate;
@property (assign, nonatomic,readonly) UIView *contentView;
@property (assign, nonatomic,readonly) CGSize imageSize;


//Tabbar
@property (nonatomic, retain) UITabBarItem *uploadButton;
@property (nonatomic, retain) UITabBarItem *captureButton;
@property (nonatomic, retain) UITabBarItem *playerStatus;
@property (nonatomic, retain) UITabBarItem *serverButton;

//Toolbar
@property (nonatomic, retain) UIBarButtonItem *reloadButton;
@property (nonatomic, retain) UIBarButtonItem *showModelsButton;
@property (nonatomic, retain) UIBarButtonItem *loginButton;

@property (nonatomic, retain) NSMutableArray *overlay_images;

//views
@property (nonatomic, retain) HoverView *hoverView;
@property (nonatomic, retain) HoverView *loginView;
@property (nonatomic, retain) HoverView *webViewFrame;
@property (nonatomic, retain) UIWebView *webView;

//webView
@property (nonatomic, retain) UIButton *closeW_btn;

//loginView
@property (nonatomic, retain) UITextField *userID;
@property (nonatomic, retain) UITextField *userPSWD;
@property (nonatomic, retain) UIButton *login_btn;
@property (nonatomic, retain) UIButton *signUp_btn;
@property (nonatomic, retain) UIButton *closeL_btn;

//hoverView
@property (nonatomic, retain) UIButton *close_btn;
@property (nonatomic, retain) UIButton *more_btn;
@property (nonatomic, retain) UIButton *focusFlag;
@property (nonatomic, retain) UILabel *t1PointsLabel;
@property (nonatomic, retain) UILabel *t2PointsLabel;
@property (nonatomic, retain) UIButton *playerPoints;
@property (nonatomic, retain) UILabel *playerPointsLabel;
@property (nonatomic, retain) UILabel *modelName;
@property (nonatomic, retain) UILabel *flagNumber;
@property (nonatomic, retain) UIButton *t1Points;
@property (nonatomic, retain) UIButton *t2Points;
@property (nonatomic, retain) UIImageView *infoView;

//JSON
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) NSMutableArray *jsonFArray;
@property (nonatomic, retain) NSMutableArray *jsonUArray;

- (IBAction)signUp;
- (IBAction)refresh;
- (IBAction)changeDisp;
- (IBAction)login;
- (IBAction)uploadPic;
- (IBAction)takePic;
- (IBAction)switchStatus;
- (void)closeHoverView;
- (void)closeLoginView;
- (void)closeWebView;
- (IBAction)loginStart;
- (IBAction)loginCommit;
- (void)buttonPressed: (id)sender;
- (void)flagTouched: (id)sender;
- (void)dispModel;

- (void)updateDetailedImageView;
- (void)updateImageView;
- (void)buildLoginView;
- (void)buildWebView;
- (void)buildHoverView;
- (void)loadJSONServerData:(NSURL *)jsonURL;
- (void)loadJSONData:(NSURL *)jsonURL;
- (void)loadJSONFData:(NSURL *)jsonURL;
- (void)putFlags:(CGPoint)p;
- (void)putModelBtns:(CGPoint)p;
- (void)putModels:(CGPoint)p;//:(NSDictionary *)dict;
- (void)getDetailedModelData:(NSDictionary *)dict;


@end
