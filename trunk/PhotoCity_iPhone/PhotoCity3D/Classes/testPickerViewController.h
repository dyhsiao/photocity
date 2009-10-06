#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class ImageViewAppDelegate;
//@class ASIHTTPRequest;
@class ASINetworkQueue;

@interface testPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
	IBOutlet UITabBarItem *grabBtn;
	IBOutlet UITabBarItem *uploadBtn;
	IBOutlet UITabBarItem *mapBtn;
	//IBOutlet UIView *tabBar;
	
	int m_id;
	int save_flag;
	UIAlertView *alert;
	NSMutableString *uniquePathOld;
	
    IBOutlet UIImageView *image;
	UIImagePickerController *imgPicker;
	ImageViewAppDelegate *theDelegate;
	ASINetworkQueue *networkQueue;
	NSAutoreleasePool *pool;
	IBOutlet UIProgressView *progressIndicator;
	UIProgressView *progbar;
}
- (IBAction)grabImage;
- (IBAction)uploadImage;
- (IBAction)returnMap;
- (void)imageSavedToPhotosAlbum:(UIImage *)img didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)imageUploadToServer;
//- (void)resetInit;
//- (void)requestDone:(ASIHTTPRequest *)request;
//- (void)requestWentWrong:(ASIHTTPRequest *)request;

@property (nonatomic, retain) NSAutoreleasePool *pool;
@property (nonatomic, retain) NSMutableString *uniquePathOld;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) UITabBarItem *grabBtn;
@property (nonatomic, retain) UITabBarItem *uploadBtn;
@property (nonatomic, retain) UITabBarItem *mapBtn;
@property (nonatomic, retain) ImageViewAppDelegate *theDelegate;
//@property (nonatomic, retain) UIImageView *image;
//@property (nonatomic, retain) UIView *tabBar;

@end
