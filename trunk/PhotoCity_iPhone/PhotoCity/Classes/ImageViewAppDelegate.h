//
//  ImageViewAppDelegate.h
//  ImageView
//
//  Created by Nicolas Goy on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewViewController;
@class testPickerViewController;
@class loadViewController;

@interface ImageViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ImageViewViewController *viewController;
	testPickerViewController *viewPickerController;
	loadViewController *viewLoadController;
	
	///////////////////////
	int m_id;
	int p_id;
	int f_id;
	int team1_points;
	int team2_points;
	int player_points;
	
	NSString *img_URL;
	NSString *m_name;
	int is_login;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ImageViewViewController *viewController;
@property (nonatomic, retain) IBOutlet testPickerViewController *viewPickerController;
@property (nonatomic, retain) IBOutlet loadViewController *viewLoadController;

@property (readwrite) int m_id;
@property (readwrite) int p_id;
@property (readwrite) int f_id;
@property (readwrite) int team1_points;
@property (readwrite) int team2_points;
@property (readwrite) int player_points;

@property (readwrite) int is_login;
@property (nonatomic, retain) NSString *img_URL;
@property (nonatomic, retain) NSString *m_name;
- (void)flipView:(int) onFront;


@end

