//
//  ImageViewAppDelegate.h
//  ImageView
//
//  Created by Nicolas Goy on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SplashViewController.h"

@class ImageViewViewController;
@class testPickerViewController;
@class loadViewController;
@class SplashViewController;

@interface ImageViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SplashViewController *viewSController;
    ImageViewViewController *viewController;
	testPickerViewController *viewPickerController;
	testPickerViewController *viewLibPickerController;
	
	loadViewController *viewLoadController;
	
	///////////////////////
	int m_id;
	int p_id;
	int f_id;
	int team1_points;
	int team2_points;
	int team3_points;
	int team4_points;
	int player_points;
	
	NSString *img_URL;
	NSString *m_name;
	NSString *p_name;
	NSString *p_pswd;
	int queue_count;
	int queue_total;
	int is_login;
	int perf_ind;
	int instruction_ind;
	int updateLoc_ind;
	double lastLocationX;
	double lastLocationY;
	CGPoint lastLocation;
	
	float prog;
	float oldProg;
	NSTimer *pTimer;
	
	//JSON
	NSMutableArray *jArray;
	NSMutableArray *jFArray;
	NSMutableArray *jUArray;
	NSDictionary *jUFArray;
	NSMutableArray *jTFArray;
	
	

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SplashViewController *viewSController;
@property (nonatomic, retain) IBOutlet ImageViewViewController *viewController;
@property (nonatomic, retain) IBOutlet testPickerViewController *viewPickerController;
@property (nonatomic, retain) IBOutlet testPickerViewController *viewLibPickerController;
@property (nonatomic, retain) IBOutlet loadViewController *viewLoadController;

@property (readwrite) int m_id;
@property (readwrite) int p_id;
@property (readwrite) int f_id;
@property (readwrite) int perf_ind;
@property (readwrite) int team1_points;
@property (readwrite) int team2_points;
@property (readwrite) int team3_points;
@property (readwrite) int team4_points;
@property (readwrite) int player_points;
@property (readwrite) double lastLocationX;
@property (readwrite) double lastLocationY;

@property (readwrite) int is_login;
@property (readwrite) int queue_count;
@property (readwrite) int queue_total;
@property (readwrite) int instruction_ind;
@property (readwrite) int updateLoc_ind;
@property (readwrite) CGPoint lastLocation;
@property (nonatomic, retain) NSString *img_URL;
@property (nonatomic, retain) NSString *m_name;
@property (nonatomic, retain) NSString *p_name;
@property (nonatomic, retain) NSString *p_pswd;

//JSON
@property (nonatomic, retain) NSMutableArray *jArray;
@property (nonatomic, retain) NSMutableArray *jFArray;
@property (nonatomic, retain) NSMutableArray *jUArray;
@property (nonatomic, retain) NSDictionary *jUFArray;
@property (nonatomic, retain) NSMutableArray *jTFArray;

- (void)updateQueue;
- (void)flipView:(int) onFront;
- (void)restoreState;
- (void)saveState;


@end

