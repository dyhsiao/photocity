#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface testPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
	IBOutlet UITabBarItem *grabBtn;
	IBOutlet UITabBarItem *uploadBtn;
	IBOutlet UITabBarItem *mapBtn;
	//IBOutlet UIView *tabBar;
	
	int m_id;
	
    IBOutlet UIImageView *image;
	UIImagePickerController *imgPicker;
}
- (IBAction)grabImage;
- (IBAction)uploadImage;
- (IBAction)returnMap;

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) UITabBarItem *grabBtn;
@property (nonatomic, retain) UITabBarItem *uploadBtn;
@property (nonatomic, retain) UITabBarItem *mapBtn;
//@property (nonatomic, retain) UIView *tabBar;

@end
