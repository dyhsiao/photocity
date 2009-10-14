
#import <UIKit/UIKit.h>
//#import <AudioToolbox/AudioServices.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "CSMapRouteLayerView.h"



@class HoverView;
@class ConfView;
@class GYImageView;
@class ImageViewAppDelegate;
//@class URLCacheAppDelegate;

extern NSString *Show_HoverView;
extern NSString *Show_LoginView;
extern NSString *Show_ConfView;
extern NSString *Find_Flag;
extern NSString *Change_Center;

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

@interface GYImageView : UIView <UIWebViewDelegate> {
  CGImageRef rawImage;
  UIView *contentView;
  UIImageView *imageView;
  UIImageView *detailedImageView;
  CGFloat scale;
  id<GYImageViewDelegate> imageViewDelegate;
	ImageViewAppDelegate *theDelegate;
	//URLCacheAppDelegate *urlDelegate;
	CLLocationManager *locationMgr;
	NSUInteger noUpdates;
	
	//views
	IBOutlet HoverView *hoverView;
	IBOutlet HoverView *loginView;
	IBOutlet HoverView *webViewFrame;
	IBOutlet UIWebView *webView;
	IBOutlet ConfView *confView;
	
	//hoverView
	UIButton *focusFlag;
	IBOutlet UIButton *close_btn;
	IBOutlet UILabel *t1PointsLabel;
	IBOutlet UILabel *t2PointsLabel;
	IBOutlet UILabel *t3PointsLabel;
	IBOutlet UILabel *t4PointsLabel;
	IBOutlet UILabel *playerPointsLabel;
	IBOutlet UILabel *playerLabel;
	IBOutlet UIButton *playerPoints;
	IBOutlet UIWebView *infoView;
	IBOutlet UILabel *modelName;
	IBOutlet UILabel *flagNumber;
	IBOutlet UIButton *t1Points;
	IBOutlet UIButton *t2Points;
	IBOutlet UIButton *t3Points;
	IBOutlet UIButton *t4Points;
	IBOutlet UIButton *h_take_btn;
	IBOutlet UIButton *h_upload_btn;
	
	//webView
	IBOutlet UIButton *closeW_btn;
	IBOutlet UILabel *webViewTitle;
	IBOutlet UIActivityIndicatorView *wActInd;

	//loginView
	IBOutlet UIButton *closeL_btn;
	IBOutlet UITextField *userID;
	IBOutlet UITextField *userPSWD;
	IBOutlet UIButton *login_btn;
	IBOutlet UIButton *signUp_btn;
	
	//confView
	IBOutlet UISwitch *instructionSwitch;
	
	NSTimer* myTimer;
	IBOutlet UIButton *more_btn;
	
	//JSON
	NSMutableArray *jsonArray;
	NSMutableArray *jsonFArray;
	NSMutableArray *jsonUArray;
	NSDictionary *jsonUFArray;
	NSMutableArray *jsonTFArray;
	
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
	IBOutlet UIToolbar *upperBar;
	IBOutlet UIBarButtonItem *reloadButton;
	IBOutlet UIBarButtonItem *tfButton;
	IBOutlet UIBarButtonItem *loginButton;
	IBOutlet UIButton *photoStatusButton;
	IBOutlet UIButton *scoreBoardButton;
	IBOutlet UIButton *curlUpButton;
	IBOutlet UIButton *t1Flags;
	IBOutlet UIButton *t2Flags;
	IBOutlet UIButton *t3Flags;
	IBOutlet UIButton *t4Flags;
	IBOutlet UIButton *t0Flags;
	IBOutlet UIButton *serverIndicator;
	IBOutlet UIBarButtonItem *whereButton;
	IBOutlet UIBarButtonItem *serverIButton;
	
	//indicators
    int disp_ind;
	int check_focusFlag;
	int dispStatus_ind;
	int server_ind;
	int notCurled;
	int showTeamFlags_ind;
	int updateLoc_ind;
	int init_ind;
	int ins_ind;
	int t1FlagCount;
	int t2FlagCount;
	int t3FlagCount;
	int t4FlagCount;
	int t0FlagCount;
	int noTouch;
	
	UIButton *meBtn;
	
	
	NSMutableString *t_name;
	NSMutableString *t_pswd; 
	
	//mapView
	CALayer *transformed;
	CGPoint previousLocation;
	CGFloat startingTouchDistance, previousScale;	
	MKMapView* _mapView;
	CSMapRouteLayerView* _routeView;


	

}

//mapView
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) CSMapRouteLayerView* routeView;


@property (assign, nonatomic) CGImageRef CGImage;
@property (assign, nonatomic, readonly) CGFloat scale;
@property (assign, nonatomic) id<GYImageViewDelegate> imageViewDelegate;
@property (assign, nonatomic) ImageViewAppDelegate *theDelegate;
//@property (assign, nonatomic) URLCacheAppDelegate *urlDelegate;
@property (assign, nonatomic,readonly) UIView *contentView;
@property (assign, nonatomic,readonly) CGSize imageSize;
@property (nonatomic, retain) ConfView *confView;
@property (nonatomic, retain) UIButton *meBtn;
@property (nonatomic, retain) NSMutableString *t_name;
@property (nonatomic, retain) NSMutableString *t_pswd;

//Tabbar
@property (nonatomic, retain) UITabBarItem *uploadButton;
@property (nonatomic, retain) UITabBarItem *captureButton;
@property (nonatomic, retain) UITabBarItem *playerStatus;
@property (nonatomic, retain) UITabBarItem *serverButton;

//confView
@property (nonatomic, retain) UISwitch *instructionSwitch;

//Toolbar
@property (nonatomic, retain) UIToolbar *upperBar;
@property (nonatomic, retain) UIBarButtonItem *reloadButton;
@property (nonatomic, retain) UIBarButtonItem *tfButton;
@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) UIButton *photoStatusButton;
@property (nonatomic, retain) UIButton *scoreBoardButton;
@property (nonatomic, retain) UIButton *curlUpButton;
@property (nonatomic, retain) UIButton *t1Flags;
@property (nonatomic, retain) UIButton *t2Flags;
@property (nonatomic, retain) UIButton *t3Flags;
@property (nonatomic, retain) UIButton *t4Flags;
@property (nonatomic, retain) UIButton *t0Flags;
@property (nonatomic, retain) NSMutableArray *overlay_images;
@property (nonatomic, retain) UIButton *serverIndicator;
@property (nonatomic, retain) UIBarButtonItem *whereButton;
@property (nonatomic, retain) UIBarButtonItem *serverIButton;

//views
@property (nonatomic, retain) HoverView *hoverView;
@property (nonatomic, retain) HoverView *loginView;
@property (nonatomic, retain) HoverView *webViewFrame;
@property (nonatomic, retain) UIWebView *webView;

//webView
@property (nonatomic, retain) UIButton *closeW_btn;
@property (nonatomic, retain) UILabel *webViewTitle;
@property (nonatomic, retain) UIActivityIndicatorView *wActInd;

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
@property (nonatomic, retain) UILabel *t3PointsLabel;
@property (nonatomic, retain) UILabel *t4PointsLabel;
@property (nonatomic, retain) UIButton *playerPoints;
@property (nonatomic, retain) UILabel *playerLabel;
@property (nonatomic, retain) UILabel *playerPointsLabel;
@property (nonatomic, retain) UILabel *modelName;
@property (nonatomic, retain) UILabel *flagNumber;
@property (nonatomic, retain) UIButton *t1Points;
@property (nonatomic, retain) UIButton *t2Points;
@property (nonatomic, retain) UIButton *t3Points;
@property (nonatomic, retain) UIButton *t4Points;
@property (nonatomic, retain) UIButton *h_upload_btn;
@property (nonatomic, retain) UIButton *h_take_btn;
@property (nonatomic, retain) UIWebView *infoView;

//JSON
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) NSMutableArray *jsonFArray;
@property (nonatomic, retain) NSMutableArray *jsonUArray;
@property (nonatomic, retain) NSDictionary *jsonUFArray;
@property (nonatomic, retain) NSMutableArray *jsonTFArray;

- (void) performCurl ;
- (IBAction)signUp;
- (IBAction)refresh;
- (IBAction)changeDisp;
- (IBAction)login;
- (IBAction)uploadPic;
- (IBAction)takePic;
- (IBAction)gotoStatusPage;
- (IBAction)switchStatus;
- (void)closeHoverView;
- (void)closeLoginView;
- (void)closeWebView;
- (IBAction)loginStart;
- (IBAction)loginCommit;
- (IBAction) showTeamFlags;
- (void)buttonPressed: (id)sender;
//- (void)flagTouched: (id)sender;
- (void)dispModel;
- (IBAction) whereAmI;
- (void)selectPhotoStatus;
- (void)selectScoreBoard;
- (void)updateDetailedImageView;
- (void)updateImageView;
- (void)buildLoginView;
- (void)buildConfView;
- (void)buildWebView;
- (void)buildHoverView;
- (void)showHoverView:(BOOL)show;
- (void)loadJSONServerData:(NSURL *)jsonURL;
- (void)loadJSONData:(NSURL *)jsonURL;
- (void)loadJSONFData:(NSURL *)jsonURL;
- (void)loadJSONTFData:(NSURL *)jsonURL;
- (void)loadJSONUFData:(NSURL *)jsonURL;
- (void)putMe;
- (void)putFlags:(CGPoint)p;
- (void)putModelBtns:(CGPoint)p;
- (void)putModels:(CGPoint)p;//:(NSDictionary *)dict;
- (void)getDetailedModelData:(NSDictionary *)dict;
- (IBAction)serverButtonPressed;
- (IBAction)switchInstruction;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;


@end
