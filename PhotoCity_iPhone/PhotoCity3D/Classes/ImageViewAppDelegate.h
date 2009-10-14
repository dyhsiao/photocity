//
//  ImageViewAppDelegate.h
//  ImageView
//
//  Created by Nicolas Goy on 1/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SplashViewController.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <MapKit/MapKit.h>





@class ImageViewViewController;
@class testPickerViewController;
@class PersonalViewController;
@class loadViewController;
@class SplashViewController;

@interface ImageViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SplashViewController *viewSController;
    ImageViewViewController *viewController;
	testPickerViewController *viewPickerController;
	testPickerViewController *viewLibPickerController;
	PersonalViewController *viewPController;
	
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
	
	//Touch
	int touchStatus;
	CGPoint touchStartPoint;
	CGPoint touchMovingPoint;
	CGPoint touchEndPoint;
	
	float prog;
	float oldProg;
	NSTimer *pTimer;
	
	//JSON
	NSMutableArray *jArray;
	NSMutableArray *jFArray;
	NSMutableArray *jUArray;
	NSDictionary *jUFArray;
	NSMutableArray *jTFArray;
	
	//map
	CGPoint minLatLon;
	CGPoint maxLatLon;
	CGPoint s_btnLoc;
	CLLocationCoordinate2D movingCenter;
	
	 GLfloat*		vertexBuffer_1 ;
	 GLfloat*		vertexBuffer_2;
	 GLfloat*		vertexBuffer_3;
	 GLfloat*		vertexBuffer_4;
	 NSUInteger	vertexMax_1;
	 NSUInteger	vertexMax_2;
	 NSUInteger	vertexMax_3;
	 NSUInteger	vertexMax_4;
	
	NSUInteger			vertexCount_1,count_1,i_1;
	NSUInteger			vertexCount_2,count_2,i_2;
	NSUInteger			vertexCount_3,count_3,i_3;
	NSUInteger			vertexCount_4,count_4,i_4;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SplashViewController *viewSController;
@property (nonatomic, retain) IBOutlet ImageViewViewController *viewController;
@property (nonatomic, retain) IBOutlet testPickerViewController *viewPickerController;
@property (nonatomic, retain) IBOutlet testPickerViewController *viewLibPickerController;
@property (nonatomic, retain) IBOutlet loadViewController *viewLoadController;
@property (nonatomic, retain) IBOutlet PersonalViewController *viewPController;

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

//Touch
@property (readwrite) CGPoint touchStartPoint;
@property (readwrite) CGPoint touchMovingPoint;
@property (readwrite) CGPoint touchEndPoint;
@property (readwrite) int touchStatus;
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
@property (readwrite) CGPoint minLatLon,maxLatLon,s_btnLoc;
@property (readwrite) CLLocationCoordinate2D movingCenter;

@property (readwrite)  GLfloat*		vertexBuffer_1;
@property (readwrite)  GLfloat*		vertexBuffer_2;
@property (readwrite)  GLfloat*		vertexBuffer_3;
@property (readwrite)  GLfloat*		vertexBuffer_4;
@property (readwrite) NSUInteger	vertexMax_1;
@property (readwrite) NSUInteger	vertexMax_2;
@property (readwrite) NSUInteger	vertexMax_3;
@property (readwrite) NSUInteger	vertexMax_4;
@property (readwrite) NSUInteger vertexCount_1,count_1,i_1;
@property (readwrite) NSUInteger vertexCount_2,count_2,i_2;
@property (readwrite) NSUInteger vertexCount_3,count_3,i_3;
@property (readwrite) NSUInteger vertexCount_4,count_4,i_4;

- (void)updateQueue;
- (void)flipView:(int) onFront;
- (void)restoreState;
- (void)saveState;


@end

