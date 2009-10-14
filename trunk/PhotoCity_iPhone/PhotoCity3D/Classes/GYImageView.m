
#import "GYImageView.h"
#import "ConfView.h"
#import "HoverView.h"
#import "ImageViewAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageViewViewController.h"
#import <JSON/JSON.h>




NSString *Show_HoverView = @"SHOW";
NSString *Show_LoginView = @"LSHOW";
NSString *Show_WebView = @"WSHOW";
NSString *Show_ConfView = @"CSHOW";
NSString *Find_Flag = @"FindF";
NSString *Change_Center = @"ChangeC";

const int kGYImageViewMaxImageWidth = 5000;
const int kGYImageViewMaxImageHeight = 5000;

const int kGYImageViewMaxLowResImageWidth = 512;
const int kGYImageViewMaxLowResImageHeight = 512;

@implementation GYImageView

@synthesize scale, imageViewDelegate, contentView;

@synthesize meBtn;
@synthesize t_name;
@synthesize t_pswd;

//views
@synthesize webViewFrame;
@synthesize webView;
@synthesize loginView;
@synthesize hoverView;
@synthesize confView;

//JSON
@synthesize jsonArray;
@synthesize jsonFArray;
@synthesize jsonUArray;
@synthesize jsonUFArray;
@synthesize jsonTFArray;

@synthesize theDelegate;
@synthesize overlay_images;

//webView
@synthesize webViewTitle;
@synthesize wActInd;

//confView
@synthesize instructionSwitch;

//hoverView
@synthesize closeW_btn;
@synthesize more_btn;
@synthesize focusFlag;
@synthesize playerLabel;
@synthesize playerPointsLabel;
@synthesize playerPoints;
@synthesize t1PointsLabel;
@synthesize t2PointsLabel;
@synthesize t3PointsLabel;
@synthesize t4PointsLabel;
@synthesize t1Points;
@synthesize t2Points;
@synthesize t3Points;
@synthesize t4Points;
@synthesize flagNumber;
@synthesize modelName;
@synthesize infoView;
@synthesize close_btn;
@synthesize h_take_btn;
@synthesize h_upload_btn;


//loginView
@synthesize userID;
@synthesize userPSWD;
@synthesize login_btn;
@synthesize signUp_btn;
@synthesize closeL_btn;

//Tabbar
@synthesize uploadButton;
@synthesize captureButton;
@synthesize playerStatus;
@synthesize serverButton;

//Toolbar
@synthesize upperBar;
@synthesize reloadButton;
@synthesize tfButton;
@synthesize loginButton;
@synthesize scoreBoardButton;
@synthesize curlUpButton;
@synthesize photoStatusButton;
@synthesize t1Flags;
@synthesize t2Flags;
@synthesize t3Flags;
@synthesize t4Flags;
@synthesize t0Flags;
@synthesize serverIndicator;
@synthesize whereButton;


@synthesize routeView = _routeView;
@synthesize mapView   = _mapView;



/*
static CGImageRef GYImageCreateScaledDown(CGImageRef source, size_t width, size_t height)
{
  CGSize imageSize = CGSizeMake(CGImageGetWidth(source), CGImageGetHeight(source));

  CGFloat xRatio = imageSize.width / width;
  CGFloat yRatio = imageSize.height / height;
  CGFloat ratio = MAX(1, MAX(xRatio, yRatio));

  CGSize thumbSize = CGSizeMake(imageSize.width / ratio, imageSize.height / ratio);


  CGContextRef context = CGBitmapContextCreate(NULL, thumbSize.width, thumbSize.height,
                                               CGImageGetBitsPerComponent(source),
                                               4 * thumbSize.width,
                                               CGImageGetColorSpace(source),
                                               kCGImageAlphaPremultipliedFirst);

  CGContextDrawImage(context, CGRectMake(0, 0, thumbSize.width, thumbSize.height), source);
  CGImageRef result = CGBitmapContextCreateImage(context);
  CGContextRelease(context);
  return result;
}
*/
 
- (GYImageView *)init
{
	//self.decelerationRate = 0;//UIScrollViewDecelerationRateFast/10;

	//self.bounces=NO;
	[self setMultipleTouchEnabled:YES];
	
	
	theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	//[theDelegate restoreState];

	locationMgr = [[CLLocationManager alloc] init];
	locationMgr.delegate=self;
	

	
//  contentView = [[UIView alloc] initWithFrame:self.frame];
 // [self addSubview:contentView];
  //super.delegate = self;
  
	
	
	
	//t_name = i_name;//[NSString stringWithFormat:@"%@",i_name];
	//t_pswd = [NSString stringWithFormat:@"%@",i_pswd];
	
	init_ind = 0;
	scale = 1;
	showTeamFlags_ind = 0;
	server_ind =0;
	disp_ind = 1;
	check_focusFlag = 0;
	dispStatus_ind = 0;
	notCurled = 1;
	noTouch = 0;
	updateLoc_ind=1;
	theDelegate.updateLoc_ind=1;
	theDelegate.vertexCount_1=0;
	theDelegate.vertexCount_2=0;
	theDelegate.vertexCount_3=0;
	theDelegate.vertexCount_4=0;
	theDelegate.vertexMax_1=64;
	theDelegate.vertexMax_2=64;
	theDelegate.vertexMax_3=64;
	theDelegate.vertexMax_4=64;
	theDelegate.vertexBuffer_1=NULL;
	theDelegate.vertexBuffer_2=NULL;
	theDelegate.vertexBuffer_3=NULL;
	theDelegate.vertexBuffer_4=NULL;
	//meBtn.hidden=YES;
	
	userID.text=[NSString stringWithFormat:@"%@", theDelegate.p_name];
	userPSWD.text=[NSString stringWithFormat:@"%@", theDelegate.p_pswd ];
	
		//[NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(login) userInfo:nil repeats:false];
	
	//theDelegate.is_login = 0;

	
	
	check_focusFlag = 0;

	
	/*
	if (theDelegate.is_login==1)
	{
		loginButton.title=theDelegate.p_name;
		//loginButton.title=@"test";
		
	}
	else
	{
		loginButton.title = @"Login / Sign up";
	}	
*/

	//load data
	[theDelegate startAnimation];
	[self loadJSONData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_models.php"] ];
	[self loadJSONFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_flags.php"] ];
	[self loadJSONTFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_team_flags.php"] ];
	[self loadJSONServerData:[NSURL URLWithString:@"http://fusion.cs.washington.edu:8000/heartbeat"] ];
	[theDelegate stopAnimation];

	maxBound.x=-122.298571;
	maxBound.y=47.652337;
	minBound.x=-122.311885;
	minBound.y=47.661233;
	
	

	
	
//	NSString *message = [NSString stringWithFormat:@"Error!"];
//	URLCacheAlertWithMessage (message);
	
	// called by MainView, when the user touches once on the background image

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showViewNotif:) name:Show_HoverView object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewNotif:) name:Show_LoginView object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebViewNotif:) name:Show_WebView object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConfViewNotif:) name:Show_ConfView object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagTouched:) name:Find_Flag object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCenter:) name:Change_Center object:nil];
	//[self login];	
	[instructionSwitch addTarget:self action:@selector(switchInstruction) forControlEvents:UIControlEventValueChanged];

	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// getting an NSString
	NSString *i_name = [prefs stringForKey:@"userID"];	
	
	theDelegate.instruction_ind = [prefs integerForKey:@"instruction"];
	//NSLog(@"%d",theDelegate.instruction_ind);
	
	
	
	
	
	
	/////
	// MapView
	/////
	
	//[self addSubview:mappView];
	
	
	//
	// load the points from our local resource
	//
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:filePath];
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];
	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
		CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
		
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
		[points addObject:currentLocation];
	}
	
	//
	// Create our map view and add it as as subview. 
	//
	
	

	float x_ext = 0.25;
	float y_ext = 0.15;
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(-x_ext*self.frame.size.width, -y_ext*self.frame.size.height, (1+x_ext*2)*self.frame.size.width, (1+y_ext*2)*self.frame.size.height)];
	//[self addSubview:_mapView];
	
	//make it changeable
	self.mapView.mapType=MKMapTypeHybrid;
	self.mapView.showsUserLocation = YES;

	// create our route layer view, and initialize it with the map on which it will be rendered. 
	_routeView = [[CSMapRouteLayerView alloc] initWithRoute:points mapView:_mapView];
	
	[points release];
	
	//UIView *myView = [[self subviews] objectAtIndex:2];
	
	
	
	transformed = [CALayer layer];
	transformed = self.layer;
	//[[self layer] addSublayer:transformed];
	transformed.frame = self.bounds;
	
	
	// BJL: Add a perspective effect
	CATransform3D initialTransform = transformed.sublayerTransform;
	initialTransform.m34 = 1.0 / -250;
	transformed.sublayerTransform = initialTransform;
	
	
	CALayer *imageLayer = [CALayer layer];
	imageLayer = _mapView.layer;
	imageLayer.transform =  CATransform3DMakeRotation(20.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);//CATransform3DConcat( CATransform3DMakeRotation(20.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f) , CATransform3DMakeScale(0.85f, 0.85f, 0.85f) );
	[transformed addSublayer:imageLayer];
	
	
	
	// BJL: Enable multitouch
	//	self.multipleTouchEnabled = YES;
	//	self.userInteractionEnabled = YES;
	
	/////
	// MapView
	/////
	
	
	
	
	
	
	if (i_name != nil && [i_name length] !=0)
	{
		[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(login) userInfo:nil repeats:false];
	}
	
	
	//[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setStartPoint) userInfo:nil repeats:false];
	
	
	return self;
}

- (GYImageView *)initWithFrame:(CGRect)frame
{

  if (![super initWithFrame:frame])
    return nil;

  [self init];
  return self;
}

- (GYImageView *)initWithCoder:(NSCoder *)coder
{
  if (![super initWithCoder:coder])
    return nil;

  [self init];
  return self;
}

- (void)updateImageView
{
	
	/////////
	serverIndicator.backgroundColor=[UIColor darkGrayColor];
	
	if (server_ind==1)
	{
		serverIndicator.backgroundColor=[UIColor greenColor];
		//	self.serverButton.enabled = YES;
		//	self.serverButton.badgeValue= @"Alive";
	}
	h_take_btn.hidden=YES;
	h_upload_btn.hidden=YES;
	[self putMe];
	////////


	
	[scoreBoardButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
	[scoreBoardButton setTitleColor:[UIColor colorWithRed:0.565f green:0.73f blue:0.918f alpha:1.0f] forState:UIControlStateNormal];
	[scoreBoardButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
	[scoreBoardButton addTarget:self action:@selector(selectScoreBoard) forControlEvents:UIControlEventTouchUpInside];
	[photoStatusButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
	[photoStatusButton setTitleColor:[UIColor colorWithRed:0.565f green:0.73f blue:0.918f alpha:1.0f] forState:UIControlStateNormal];
	[photoStatusButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
	[photoStatusButton addTarget:self action:@selector(selectPhotoStatus) forControlEvents:UIControlEventTouchUpInside];
	[curlUpButton setBackgroundImage:[UIImage imageNamed:@"curl.png"] forState:UIControlStateNormal];
	[curlUpButton addTarget:self action:@selector(performCurl) forControlEvents:UIControlEventTouchUpInside];
	
	
	//[t1Flags setFrame:CGRectMake(0 ,22, 130, 30)];
	[t1Flags setBackgroundColor:[UIColor redColor] ];
	[t1Flags setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[t2Flags setFrame:CGRectMake(130 ,22, 60, 30)];
	[t2Flags setBackgroundColor:[UIColor cyanColor] ];
	[t2Flags setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[t3Flags setFrame:CGRectMake(190 ,22, 90, 30)];
	[t3Flags setBackgroundColor:[UIColor yellowColor] ];
	[t3Flags setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[t4Flags setFrame:CGRectMake(280 ,22, 20, 30)];
	[t4Flags setBackgroundColor:[UIColor greenColor] ];
	[t4Flags setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[t0Flags setFrame:CGRectMake(300 ,22, 20, 30)];
	[t0Flags setBackgroundColor:[UIColor blackColor] ];
	[t0Flags setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[self showTeamFlags];
	
	

}



- (void)updateDetailedImageView
{

	
	
	
	serverIndicator.backgroundColor=[UIColor darkGrayColor];	
	if (server_ind==1)
	{
		serverIndicator.backgroundColor=[UIColor greenColor];
	}
  
	/*
	CGPoint p = self.contentOffset;
	p.x = MAX(0, p.x);
	p.y = MAX(0, p.y);
	p.x = MIN(p.x, self.contentSize.width - self.frame.size.width);
	p.y = MIN(p.y, self.contentSize.height - self.frame.size.height);

	positionvertex=p;
	theDelegate.lastLocationX=p.x;
	theDelegate.lastLocationY=p.y;
	 */
	
	[self putMe];
	//viewTouch = [[UIViewTouch alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	//[[theDelegate.viewController glView]  insertSubview:viewTouch atIndex:1];
	[[theDelegate.viewController glView] insertSubview:hoverView atIndex:2];
	[[theDelegate.viewController glView] insertSubview:loginView atIndex:3];
	[[theDelegate.viewController glView] insertSubview:webViewFrame atIndex:4];
	[[theDelegate.viewController glView] insertSubview:confView atIndex:5];
	[webViewFrame insertSubview: webView atIndex:1];
	[hoverView insertSubview: infoView atIndex:1];
	

}


- (IBAction) serverButtonPressed
{
	if (theDelegate.instruction_ind)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Status" message:@"If the server is alive, the indicator will be green, if not, it will be dark gray. Only when the server is alive you can upload images."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
}

- (void)setStartPoint
{
	if (!init_ind)
	{
		//self.contentOffset=CGPointMake(theDelegate.lastLocationX,theDelegate.lastLocationY);
		init_ind=1;
	}
}


- (IBAction)switchStatus
{
	dispStatus_ind++;
	if (dispStatus_ind==2)
		dispStatus_ind=0;
	[self buildWebView];
}

- (void)buildWebView
{
	CGRect frame = webViewFrame.frame;
	frame.size.width=0.97*self.window.bounds.size.width;
	frame.size.height=0.73*self.window.bounds.size.height;
	frame.origin.x = /*positionvertex.x*/ + 4;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = /*positionvertex.y*/ + 58;//detailedImageView.frame.size.height - 100;
	webViewFrame.frame = frame;
	webView.clearsContextBeforeDrawing = YES;
	frame.size.width=0.98*frame.size.width;
	frame.size.height=0.76*frame.size.height;
	frame.origin.x = 3;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = 45;//detailedImageView.frame.size.height - 100;
	webView.frame = frame;
	//webView.bounds = frame;
	
	 webView.scalesPageToFit = YES;
	webView.autoresizesSubviews = YES;
	webView.autoresizingMask = YES;
    webView.opaque = NO;
	
	
	[closeW_btn setFrame:CGRectMake(10 ,315, 30, 30)];
	[closeW_btn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[closeW_btn addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
	
	//webView.backgroundColor = [UIColor clearColor];
	[theDelegate startAnimation];
	if (dispStatus_ind==0)
	{
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://photocity.cs.washington.edu/iphone/scores.php"]]];
		webViewTitle.text = @"Score Board";
	}
	else if (dispStatus_ind==-1)
	{
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://photocity.cs.washington.edu/iphone/new_account.php"]]];
		webViewTitle.text = @"Sign Up";
	}
	
	
	else if (dispStatus_ind==1)
	{
		
		if ( theDelegate.is_login == 1 )
		{
			NSString *tempString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/iphone/photos.php?player_id=%@", [NSString stringWithFormat:@"%d",  theDelegate.p_id]];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempString]]];
			webViewTitle.text = @"My Photo Status";
		}
		
		
	}
	
	[theDelegate stopAnimation];
		
}


- (void)buildLoginView
{
	CGRect frame = loginView.frame;
	frame.size.width=0.95*self.window.bounds.size.width;
	frame.size.height=0.16*self.window.bounds.size.height;
	frame.origin.x = /*positionvertex.x*/ + 8;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = /*positionvertex.y*/ + 58;//detailedImageView.frame.size.height - 100;
	loginView.frame = frame;
	
	[closeL_btn setFrame:CGRectMake(10,40, 30, 30)];
	[closeL_btn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[closeL_btn addTarget:self action:@selector(closeLoginView) forControlEvents:UIControlEventTouchUpInside];
	
	userID.center=CGPointMake(120,20);
	userPSWD.center=CGPointMake(120,55);
	login_btn.center= CGPointMake(240,20);
	signUp_btn.center= CGPointMake(240,55);
	userID.text=[NSString stringWithFormat:@"%@", theDelegate.p_name];
	userPSWD.text=[NSString stringWithFormat:@"%@", theDelegate.p_pswd ];
	
	/*
	 if (![theDelegate.p_name isEqualToString:@""])
	 {
	 [login_btn setTitle: @"Logout" forState:UIControlStateNormal] ;
	 }
	 */
}



- (void)buildConfView
{
	CGRect frame = confView.frame;
	frame.size.width=self.window.bounds.size.width+10;
	frame.size.height=self.window.bounds.size.height+10;
	frame.origin.x = /*positionvertex.x*/-5;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = /*positionvertex.y*/-5;//detailedImageView.frame.size.height - 100;
	confView.frame = frame;
	
	if (theDelegate.instruction_ind==1)
	{[instructionSwitch setOn:YES animated:YES];}
	else
	{[instructionSwitch setOn:NO animated:YES];}
	
}

- (IBAction)login {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// getting an NSString
	NSString *i_name = [prefs stringForKey:@"userID"];
	//NSLog(@"userID start, %s", [p_name cString]);
	NSString *i_pswd = [prefs stringForKey:@"userPSWD"];
	//NSLog(@"userPSWD start, %s", [p_pswd cString]);
	
	
	if ( theDelegate.is_login == 0 )
	{
		/*
		 turning the image into a NSData object
		 getting the image back out of the UIImageView
		 setting the quality to 90
		 */
		[userID resignFirstResponder];
		[userPSWD resignFirstResponder];
	
		[theDelegate startAnimation];

		
		
		NSString *jsonString;
		int is_saved = 0;
		if (i_name != nil && [i_name length] !=0)
		{
			is_saved = 1;
			jsonString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/check_password.php?username=%@&pass=%@", i_name, i_pswd];
			userID.text=[NSString stringWithFormat:@"%@", i_name];
			userPSWD.text=[NSString stringWithFormat:@"%@", i_pswd ];
			//photoStatusButton.hidden=NO;
			theDelegate.is_login=1;
		}
		else
		{
			jsonString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/check_password.php?username=%@&pass=%@", userID.text, userPSWD.text];
		}


		
		
		
	NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonString];
	while([ms replaceOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [ms length])] > 0);
	jsonString = ms;
	

	//NSURL *jsonURL = [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_models.php"];
	NSURL *jsonURL = [NSURL URLWithString:jsonString];	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	


	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"Cannot fetch player data. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {

		ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonData = ms;
		//self.jsonUArray = [jsonData JSONValue];
		NSDictionary *dictionary = [jsonData JSONValue];
		NSLog(@"Dictionary value for \"success\" is \"%@\"", [dictionary objectForKey:@"success"]);
		NSString *result =  [dictionary objectForKey:@"success"] ;
		NSDictionary *playerData =  [dictionary objectForKey:@"player"] ;
		int t_id = [[playerData objectForKey:@"team_id"] intValue];
		
		if ( [result isEqualToString:@"true"] )
		{
	
			theDelegate.is_login = 1;
			loginButton.title=userID.text;
			//[loginButton setBackgroundColor:[UIColor blueColor] ];
			upperBar.barStyle = UIBarStyleBlackTranslucent;
			upperBar.alpha = 1;
			//upperBar.backgroundColor = [UIColor blackColor];
			upperBar.tintColor = [UIColor redColor];
			if (t_id==1)
				upperBar.tintColor = [UIColor redColor];
			else if (t_id==2)
				upperBar.tintColor = [UIColor cyanColor];
			else if (t_id==3)
				upperBar.tintColor = [UIColor yellowColor];
			else if (t_id==4) 
				upperBar.tintColor = [UIColor greenColor];

			theDelegate.p_name = userID.text;
			theDelegate.p_pswd = userPSWD.text;
			if (!is_saved)
			{
				[theDelegate saveState];
			}
			NSLog(@"uID %s", theDelegate.p_name);
			theDelegate.p_id=[ [dictionary objectForKey:@"player_id"] intValue ];
			[login_btn setTitle: @"Logout" forState:UIControlStateNormal] ;
			//[signUp_btn setTitle: @"My Stash" forState:UIControlStateNormal] ;
			signUp_btn.hidden=YES;
			//photoStatusButton.hidden=NO;
			
			//get player data
			[self loadJSONUFData:[NSURL URLWithString:[NSString stringWithFormat:@"http://photocity.cs.washington.edu/get_points_per_flag.php?player_id=%d", theDelegate.p_id]] ];

		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong ID/Password" message:@"The ID/Password combination was wrong, please try again or sign up for a new one."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
		}
		
	}
	[theDelegate stopAnimation];
	}
	else //log out
	{
		signUp_btn.hidden=NO;
		userID.text=@"";
		userPSWD.text=@"";
		theDelegate.is_login = 0;
		loginButton.title=@"Login / Sign up";
		theDelegate.p_id=-1;
		theDelegate.p_name=@"";
		theDelegate.p_pswd=@"";
		i_name = @"";
		i_pswd = @"";
		[theDelegate saveState];
		[signUp_btn setTitle:@"Sign Up" forState:UIControlStateNormal];
		[login_btn setTitle: @"Login" forState:UIControlStateNormal] ;
		upperBar.tintColor = [UIColor blackColor];
		h_take_btn.hidden=YES;
		h_upload_btn.hidden=YES;
		//photoStatusButton.hidden=YES;
	}
	
}

-(void)buildHoverView
{
	
	// determine the size of HoverView
	//Build Flag Hoverview
	CGRect frame = hoverView.frame;
	frame.size.width=0.95*self.window.bounds.size.width;
	frame.size.height=0.39*self.window.bounds.size.height;
	frame.origin.x = /*positionvertex.x*/ + 8;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = /*positionvertex.y*/ + 72;//detailedImageView.frame.size.height - 100;
	hoverView.frame = frame;
	//close_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//[upload_btn setFrame:CGRectMake(100/scale,100/scale, 80/scale, 40/scale)];
	//[capture_btn setFrame:CGRectMake(160,100, 80, 40)];
	[close_btn setFrame:CGRectMake(10,150, 30, 30)];
	[close_btn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[close_btn addTarget:self action:@selector(closeHoverView) forControlEvents:UIControlEventTouchUpInside];

	[more_btn setFrame:CGRectMake(263, 150, 30, 30)];
	[more_btn addTarget:self action:@selector(dispModel) forControlEvents:UIControlEventTouchUpInside];
	//more_btn.hidden=YES;

	[h_take_btn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
	[h_take_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[h_take_btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[h_upload_btn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
	[h_upload_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[h_upload_btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	
	modelName.text = theDelegate.m_name;
	flagNumber.text = [NSString stringWithFormat:@"%d",  theDelegate.f_id];
	
	
	
	// show team/player points
	
	int max;
	NSMutableArray *anArray = [[NSMutableArray alloc] init];
	[anArray addObject:[NSNumber numberWithInt: theDelegate.team1_points]];
	[anArray addObject:[NSNumber numberWithInt: theDelegate.team2_points]];
	[anArray addObject:[NSNumber numberWithInt: theDelegate.team3_points]];
	[anArray addObject:[NSNumber numberWithInt: theDelegate.team4_points]];
	
	
	NSNumber *maxValue = [[anArray sortedArrayUsingSelector:@selector(compare:)] lastObject];
	max = [maxValue intValue];
	[anArray release];
	
	if (max == 0)
	{
		theDelegate.team1_points = 0;
		theDelegate.team2_points = 0;
		theDelegate.team3_points = 0;
		theDelegate.team4_points = 0;

	}
	
	

	if (theDelegate.is_login)
	{
		playerPoints.hidden = NO;
		playerPointsLabel.hidden = NO;
		playerLabel.hidden = NO;
		playerPointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.player_points];
		playerPointsLabel.textAlignment = UITextAlignmentRight;
		playerPointsLabel.textColor = [UIColor orangeColor];
		[playerPoints setFrame:CGRectMake(81,55, theDelegate.player_points*80/max, 8) ];
		[playerPoints setBackgroundColor:[UIColor orangeColor]];
	}
	else
	{
		playerPoints.hidden = YES;
		playerPointsLabel.hidden = YES;
		playerLabel.hidden = YES;
	}
	
	t1PointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.team1_points];
	t1PointsLabel.textAlignment = UITextAlignmentRight;
	t1PointsLabel.textColor = [UIColor redColor];
	
	t2PointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.team2_points];
	t2PointsLabel.textAlignment = UITextAlignmentRight;
	t2PointsLabel.textColor = [UIColor cyanColor];
	
	t3PointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.team3_points];
	t3PointsLabel.textAlignment = UITextAlignmentRight;
	t3PointsLabel.textColor = [UIColor yellowColor];
	
	t4PointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.team4_points];
	t4PointsLabel.textAlignment = UITextAlignmentRight;
	t4PointsLabel.textColor = [UIColor greenColor];
	
	[t1Points setFrame:CGRectMake(81,75, theDelegate.team1_points*80/max, 8) ];
	[t1Points setBackgroundColor:[UIColor redColor]];
	[t2Points setFrame:CGRectMake(81,95, theDelegate.team2_points*80/max, 8)];
	[t2Points setBackgroundColor:[UIColor cyanColor]];
	[t3Points setFrame:CGRectMake(81,115, theDelegate.team3_points*80/max, 8) ];
	[t3Points setBackgroundColor:[UIColor yellowColor]];
	[t4Points setFrame:CGRectMake(81,135, theDelegate.team4_points*80/max, 8)];
	[t4Points setBackgroundColor:[UIColor greenColor]];
}

- (IBAction)switchInstruction
{
	if ([instructionSwitch isOn])
	{
		theDelegate.instruction_ind=1;
	}
	else
	{
		theDelegate.instruction_ind=0;
	}
	//theDelegate.instruction_ind=ins_ind;
}


- (IBAction) refresh
{

	if (theDelegate.instruction_ind)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reload Data" message:@"Reload game data from server, and check if server is alive. Also displays current team flag number."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	
	[theDelegate startAnimation];
	reloadButton.style=UIBarButtonItemStyleDone;
	[self loadJSONData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_models.php"] ];
	[self loadJSONFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_flags.php"] ];	
	[self loadJSONServerData:[NSURL URLWithString:@"http://fusion.cs.washington.edu:8000/heartbeat"] ];
	[self loadJSONTFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_team_flags.php"] ];
	if (theDelegate.is_login)
		[self loadJSONUFData:[NSURL URLWithString:[NSString stringWithFormat:@"http://photocity.cs.washington.edu/get_points_per_flag.php?player_id=%d", theDelegate.p_id]] ];


	[theDelegate stopAnimation];
	reloadButton.style=UIBarButtonItemStyleBordered;
	//[self showTeamFlags];
	//[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(showTeamFlags) userInfo:nil repeats:false];
	
}

- (IBAction) showTeamFlags
{
	int total_flag = 0;
	int cursor=0;
//	int t1Length,t2Length,t3Length,t4Length,t0Length;
		
	
	if (showTeamFlags_ind)
	{
		tfButton.style=UIBarButtonItemStyleDone;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.20];
		for (int ndx = 0; ndx < self.jsonTFArray.count; ndx++) {
			NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonTFArray objectAtIndex:ndx];
			total_flag += [[itemAtIndex objectForKey:@"num_flags"] intValue];
		}	
		for ( int ndx = 0; ndx < self.jsonTFArray.count; ndx++) {
			NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonTFArray objectAtIndex:ndx];
			int team_id = [[itemAtIndex objectForKey:@"team_id"] intValue];
			int num_flags = [[itemAtIndex objectForKey:@"num_flags"] intValue];
			
			if (team_id == 1){			
				[t1Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t1Flags setFrame:CGRectMake(cursor ,42, 25+195*num_flags/total_flag, 25)];
			}
			else if (team_id == 2){
				[t2Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t2Flags setFrame:CGRectMake(cursor ,42, 25+195*num_flags/total_flag, 25)];
			}
			else if (team_id == 3){
				[t3Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t3Flags setFrame:CGRectMake(cursor ,42, 25+195*num_flags/total_flag, 25)];
			}
			else if (team_id == 4){
				[t4Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t4Flags setFrame:CGRectMake(cursor ,42, 320-cursor, 25)];
			}
			else {
				[t0Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t0Flags setFrame:CGRectMake(cursor ,42, 25+195*num_flags/total_flag, 25)];
				[[UIApplication sharedApplication] setApplicationIconBadgeNumber:num_flags];
			}
			
			cursor+=25+195*num_flags/total_flag;
			
		}			

		showTeamFlags_ind = 0;
		[UIView commitAnimations];
	}
	else {
		tfButton.style=UIBarButtonItemStyleBordered;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.20];
		for (int ndx = 0; ndx < self.jsonTFArray.count; ndx++) {
			NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonTFArray objectAtIndex:ndx];
			total_flag += [[itemAtIndex objectForKey:@"num_flags"] intValue];
		}	
		for ( int ndx = 0; ndx < self.jsonTFArray.count; ndx++) {
			NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonTFArray objectAtIndex:ndx];
			int team_id = [[itemAtIndex objectForKey:@"team_id"] intValue];
			int num_flags = [[itemAtIndex objectForKey:@"num_flags"] intValue];
			
			if (team_id == 1){			
				[t1Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t1Flags setFrame:CGRectMake(cursor ,22, 25+195*num_flags/total_flag, 30)];
			}
			else if (team_id == 2){
				[t2Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t2Flags setFrame:CGRectMake(cursor ,22, 25+195*num_flags/total_flag, 30)];
			}
			else if (team_id == 3){
				[t3Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t3Flags setFrame:CGRectMake(cursor ,22, 25+195*num_flags/total_flag, 30)];
			}
			else if (team_id == 4){
				[t4Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t4Flags setFrame:CGRectMake(cursor ,22, 320-cursor, 30)];
			}
			else {
				[t0Flags setTitle:[NSString stringWithFormat:@"%d",num_flags] forState:UIControlStateNormal];
				[t0Flags setFrame:CGRectMake(cursor ,22, 25+195*num_flags/total_flag, 30)];
				[[UIApplication sharedApplication] setApplicationIconBadgeNumber:num_flags];
			}
			
			cursor+=25+195*num_flags/total_flag;
		}	
		
		showTeamFlags_ind = 1;
		[UIView commitAnimations];
	}
	
	
	
}

- (IBAction) whereAmI
{

	noUpdates=0;
	if (updateLoc_ind)
	{
		if (theDelegate.instruction_ind)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Show Current Position" message:@"Your current position will be displayed in the target circle."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
		}
		[locationMgr startUpdatingLocation];
		updateLoc_ind = 0;
		whereButton.style=UIBarButtonItemStyleDone;
		//meBtn.hidden=NO;
	}
	else
	{
		//[locationMgr stopUpdatingLocation];
		updateLoc_ind = 1;
		whereButton.style=UIBarButtonItemStyleBordered;
		//self.mapView.showsUserLocation = NO;
		//meBtn.hidden=YES;
	}
	theDelegate.updateLoc_ind=updateLoc_ind;
	
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	
	noUpdates++;
	/*
	if (noUpdates >= 10 )
	{
		[locationMgr stopUpdatingLocation];
	}
	 */
	CGPoint currentLoc;
	imgSize=64;
	currentLoc.x=newLocation.coordinate.latitude;
	currentLoc.y=newLocation.coordinate.longitude;
	
	NSLog(@"lng/lat:%g, %g\n", fabs(newLocation.coordinate.longitude), fabs(newLocation.coordinate.latitude));
	
	/*
	currentLoc.x = MAX(0, currentLoc.x);
	currentLoc.y = MAX(0, currentLoc.y);
	currentLoc.x = MIN(imgSize, currentLoc.x);
	currentLoc.y = MIN(imgSize, currentLoc.y);
	*/
	
	NSLog(@"coord:%g, %g\n", currentLoc.x-(positionvertex.x+11)/scale, currentLoc.y-(positionvertex.y+11)/scale);
	
	theDelegate.lastLocationX=currentLoc.x;
	theDelegate.lastLocationY=currentLoc.y;
	theDelegate.lastLocation=currentLoc;
	
	
	 [self updateLocation:[newLocation description]];
	
	

	//[self updateDetailedImageView];

}

- (void) updateLocation:(NSString *) update{
	NSMutableString *newMessage = [[NSMutableString alloc] initWithCapacity:100];
	[newMessage appendString:[NSString stringWithFormat:@"Update #:%i\n", noUpdates]];
	[newMessage appendString:update];
	[newMessage appendString:@"\n"];
	NSLog(newMessage);
	[newMessage release];
	
	
	
	
	CLLocationCoordinate2D tmp_center;
	tmp_center.latitude = (CLLocationDegrees)theDelegate.lastLocation.x;
	tmp_center.longitude = (CLLocationDegrees)theDelegate.lastLocation.y;
	theDelegate.movingCenter=tmp_center;
	[[NSNotificationCenter defaultCenter] postNotificationName:Change_Center object:nil];

}

- (IBAction) changeDisp
{
	disp_ind++;
	if (disp_ind==2)
		disp_ind=0;
	 [self updateDetailedImageView];
}
- (void) dispModel
{
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	detailedImageView.userInteractionEnabled = NO;
	CGRect frame = hoverView.frame;
	frame.size.height=0.73*self.window.bounds.size.height;
	hoverView.frame = frame;
	
	[close_btn setFrame:CGRectMake(10 ,315, 30, 30)];
	
	
	
	more_btn.hidden = YES;
	
	[UIView commitAnimations];
	
	[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(showModelImage) userInfo:nil repeats:NO];
	
	
	
}

-(void) showModelImage{
	[theDelegate startAnimation];
	
	
	//infoView = [[UIWebView alloc] initWithFrame:CGRectMake(45, 185, 245, 155)];
	infoView.hidden=NO;
	infoView.clearsContextBeforeDrawing = YES;
	infoView.userInteractionEnabled = YES;
	infoView.multipleTouchEnabled = YES;
	[infoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: theDelegate.img_URL]]];
	/*
	[infoView setCanCancelContentTouches:NO];
	infoView.clipsToBounds = YES;    // default is NO, we want to restrict drawing within our scrollview
	infoView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	UIImageView *scrollImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:]]];
	[infoView addSubview:scrollImageView];
	[infoView setContentSize:CGSizeMake(scrollImageView.frame.size.width, scrollImageView.frame.size.height)];
	infoView.minimumZoomScale = 1;
	infoView.maximumZoomScale = 3;
	infoView.delegate = self;
	[infoView setScrollEnabled:YES];
	*/
	[theDelegate stopAnimation];
}
-(IBAction)loginStart {
	NSLog(@"Login Button Pressed!");
	
	if (theDelegate.instruction_ind)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Sign up and login to upload images to capture a flag!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	
 	
	[[NSNotificationCenter defaultCenter] postNotificationName:Show_LoginView object:nil];
	//connect to server to check
}

-(void)buttonPressed: (id)sender {
	NSLog(@"Button Pressed!");
 	theDelegate.m_id=[sender tag];
	
	//NSLog(@"Selected cell is %d", [sender tag]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:Show_HoverView object:nil];
	
	//[rightButton setFrame:CGRectMake(10/scale,10/scale, 30, 30)]; 
	//[rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
	//[rightButton setBackgroundColor:[UIColor blueColor]];
	//[hoverView addSubview:rightButton];

}
	
-(void)flagTouched: (NSNotification *)aNotification {
	NSLog(@"Flag Touched!");
    //NSLog(@"Selected cell is %d", [sender tag]);
	//[theDelegate startAnimation];
	//[self loadJSONFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_flags.php"] ];
	//[theDelegate stopAnimation];

	/* old
	 
	int flag_id, ndx;
	float  lat, lng;
		
	
	CGPoint btn;
	imgSize = 1024;
	

	 */

	NSDictionary *itemAtIndex;
	
	
	int ndx, s_ndx;
	NSInteger model_id, flag_id, owner, s_mid, s_fid, s_owner;
	float  lat, lng;
	int touch_Ind = 0;
	
	CGPoint btn, s_btn;
	float dist = 10000;
	float tmp_dist = 10000;
	CGPoint maxBound;
	CGPoint minBound;
	
	maxBound.x=theDelegate.maxLatLon.y;
	maxBound.y=theDelegate.maxLatLon.x;
	minBound.x=theDelegate.minLatLon.y;
	minBound.y=theDelegate.minLatLon.x;
	CLLocationCoordinate2D flagCoord;
 	CLLocationCoordinate2D touchCoord = [_mapView convertPoint:theDelegate.touchEndPoint toCoordinateFromView:self ];
	CGPoint touchPointCoord, flagPointCoord;

	touchPointCoord.x= (float)touchCoord.longitude;
	touchPointCoord.y=(float)touchCoord.latitude;
	
	for (ndx = 0; ndx < theDelegate.jFArray.count; ndx++) {
		NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonFArray objectAtIndex:ndx];
		model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
		flag_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];
		owner = [[itemAtIndex objectForKey:@"winner"] intValue];
		
		lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
		lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
		flagCoord.latitude = (CLLocationDegrees)lat;
		flagCoord.longitude = (CLLocationDegrees)lng;
		flagPointCoord = [_mapView convertCoordinate:flagCoord toPointToView:self];
		
		
		

		tmp_dist = powf(theDelegate.touchEndPoint.x-flagPointCoord.x+2, 2) + powf(theDelegate.touchEndPoint.y-flagPointCoord.y-16, 2);
		if (dist > tmp_dist && tmp_dist < 400) // find the flag
		{
		
			dist = tmp_dist;
			s_btn = btn;
			s_fid = flag_id;
			s_mid = model_id;
			s_owner = owner;
			s_ndx = ndx;
			
			theDelegate.f_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];
			theDelegate.s_btnLoc= CGPointMake( lat, lng);
			
			touch_Ind = 1;
		}
		
	}
	
	if (touch_Ind)
	{
	//Get the values of the touched flag
	itemAtIndex = (NSDictionary *)[self.jsonFArray objectAtIndex:s_ndx];
	theDelegate.m_id = s_mid;
	theDelegate.f_id = s_fid;
	
//	lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
//	lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
	
	if( [[itemAtIndex objectForKey:@"team1"] intValue] != nil )
		theDelegate.team1_points = [[itemAtIndex objectForKey:@"team1"] intValue];
	else
		theDelegate.team1_points = 0;
	if( [[itemAtIndex objectForKey:@"team2"] intValue] != nil )
		theDelegate.team2_points = [[itemAtIndex objectForKey:@"team2"] intValue];
	else
		theDelegate.team2_points = 0;
	if( [[itemAtIndex objectForKey:@"team3"] intValue] != nil )
		theDelegate.team3_points = [[itemAtIndex objectForKey:@"team3"] intValue];
	else
		theDelegate.team3_points = 0;
	if( [[itemAtIndex objectForKey:@"team4"] intValue] != nil )
		theDelegate.team4_points = [[itemAtIndex objectForKey:@"team4"] intValue];
	else
		theDelegate.team4_points = 0;
	/*
	if (  [[itemAtIndex objectForKey:@"winner"] intValue] != 0 )
	{
		NSDictionary *pointsArray =  [itemAtIndex objectForKey:@"points"] ;
	}
	 
	else
	{
		theDelegate.team1_points = 0;
		theDelegate.team2_points = 0;
		theDelegate.team3_points = 0;
		theDelegate.team4_points = 0;
	}
	*/

	if (theDelegate.is_login)
	{
		
		theDelegate.player_points = 0;
		if ([[jsonUFArray objectForKey:[NSString stringWithFormat:@"%d", theDelegate.f_id]] intValue]!=nil)
		{
			theDelegate.player_points = [[jsonUFArray objectForKey:[NSString stringWithFormat:@"%d", theDelegate.f_id]] intValue];
		}
		 
	}
	else //not logged in
	{
		theDelegate.player_points = 0;
	}
	
	
		
	site = @"http://photocity.cs.washington.edu/";
	itemAtIndex = (NSDictionary *)[self.jsonArray objectAtIndex:theDelegate.m_id-1];
	theDelegate.img_URL = [site stringByAppendingString:[itemAtIndex objectForKey:@"rep_image"]];
	theDelegate.m_name = [itemAtIndex objectForKey:@"name"];	
		
/*		
	btn.x=(lng-minBound.x)*imgSize/(maxBound.x-minBound.x);
	btn.y=(lat-minBound.y)*imgSize/(maxBound.y-minBound.y);
		

	if ( check_focusFlag == 1 ) 
	[focusFlag removeFromSuperview];
	focusFlag = [UIButton buttonWithType:UIButtonTypeCustom]; 
	[focusFlag removeFromSuperview];
	[focusFlag setBackgroundImage:[UIImage imageNamed:@"focus_flag.png"] forState:UIControlStateNormal];
	[focusFlag setFrame:CGRectMake(btn.x-(positionvertex.x+16)/scale, btn.y-(positionvertex.y+32)/scale, 32/scale, 32/scale)]; 
	
	focusFlag.opaque=YES;
	
	//add
	[detailedImageView addSubview:focusFlag];
	check_focusFlag = 1;
*/
	
	//[focusFlag release];
	
	//[itemAtIndex release];

	[[NSNotificationCenter defaultCenter] postNotificationName:Show_HoverView object:nil];
	}
}

/*
- (void)setCGImage:(CGImageRef)img
{
  CGImageRelease(rawImage);
  rawImage = GYImageCreateScaledDown(img, kGYImageViewMaxImageWidth, kGYImageViewMaxImageHeight);
  [self updateImageView];
}

- (CGImageRef)CGImage
{
  return rawImage;
}

 */

- (void)dealloc
{
  CGImageRelease(rawImage);
  [imageView release];
	[locationMgr release];
	[upperBar release];
  [detailedImageView release];
	[confView release];
	[instructionSwitch release];
	[t_name release];
	[t_pswd release];
	[meBtn release];
	//loginView
	[ userID release];
	[ userPSWD release];
	[ login_btn release];
	[ signUp_btn release];
	[closeL_btn release];
	[loginView release];
	
	//hoverView
	[playerPoints release];
	[playerLabel release];
	[playerPointsLabel release];
	[t1PointsLabel release];
	[t2PointsLabel release];
	[t3PointsLabel release];
	[t4PointsLabel release];
	[infoView release];
	[t1Points release];
	[t2Points release];
	[t3Points release];
	[t4Points release];
	[modelName release];
	[flagNumber release];
	[more_btn release];
	[close_btn release];
	[focusFlag release];
	[h_take_btn release];
	[h_upload_btn release];
	[hoverView release];
	
	
	//webView
	[wActInd release];
	[closeW_btn release];
	[webView release];
	[webViewFrame release];
	[webViewTitle release];
	
	//Timer
	[myTimer release];
	
	//JSON
	[theDelegate release];
	[jsonArray release];
	[jsonTFArray release];
	[jsonUFArray release];
	[jsonUArray release];
	[jsonFArray release];
	
	//Notification
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Find_Flag object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_HoverView object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_LoginView object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_ConfView object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_WebView object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Change_Center object:nil];
	
	//Tabbar
	[ uploadButton release]; 
	[ captureButton release];
	[ playerStatus release];
	[ serverButton release];
	
	//Toolbar
	[ reloadButton release];
	[ tfButton release];
	[ loginButton release];
	[photoStatusButton release];
	[scoreBoardButton release];
	[curlUpButton release];
	[t1Flags release];
	[t2Flags release];
	[t3Flags release];
	[t4Flags release];
	[t0Flags release];
	[serverIndicator release];
	[whereButton release];
	
  [super dealloc];
}

- (CGSize)imageSize
{
  return CGSizeMake(CGImageGetWidth(rawImage), CGImageGetHeight(rawImage));
}

- (void) loadJSONServerData:(NSURL *) jsonURL
{
	
	
	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	
	
	
	
	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PhotoCity Server Down" message:@"PhotoCity server is down by now."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		
		jsonData = ms;
		
		server_ind=1;
		
	}
	
}	

- (void) loadJSONData:(NSURL *) jsonURL
{
	
	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	
	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"Cannot fetch model data. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		
		
		
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonData = ms;
	
		
		// converting the json data into an array
		self.jsonArray = [jsonData JSONValue]; 
		theDelegate.jArray = [jsonData JSONValue]; 
		
		
		/*
		overlay_images = [[NSMutableArray alloc] initWithCapacity:self.jsonArray.count]; 
		
		int ndx;
		NSInteger model_id;
		NSString *overlay_image;
		site = @"http://photocity.cs.washington.edu/";
		theDelegate.urlArray = [[NSMutableArray alloc] init];
		for (ndx = 0; ndx < self.jsonArray.count; ndx++) {
			NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonArray objectAtIndex:ndx];
			model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
			overlay_image = [site stringByAppendingString:[itemAtIndex objectForKey:@"overlay_image"]];
			[overlay_images insertObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: overlay_image] ] ] atIndex:model_id-1];
		}
		*/
		

		 
		//[overlay_image release];
	}

}	

- (void) loadJSONUFData:(NSURL *)jsonURL
{	
	NSString *jsonUFData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	
	
	if (jsonUFData == nil ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"Cannot fetch player flag data. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonUFData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		while([ms replaceOccurrencesOfString:@"[]" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonUFData = ms;
		self.jsonUFArray = [jsonUFData JSONValue];
		theDelegate.jUFArray = [jsonUFData JSONValue];

	}
	
}

- (void) loadJSONTFData:(NSURL *) jsonURL
{
	
	
	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	
	
	
	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"Cannot fetch team flag data. Please try clicking on reload again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonData = ms;
		
		// converting the json data into an array
		self.jsonTFArray = [jsonData JSONValue]; 
		
		
	}
	
}	


- (void) loadJSONFData:(NSURL *) jsonURL
{
	
	
	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	
	
	
	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"Cannot fetch flag data. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonData = ms;
		
		// converting the json data into an array
		self.jsonFArray = [jsonData JSONValue]; 
		theDelegate.jFArray = [jsonData JSONValue]; 
		
		int ndx;
		NSInteger model_id, flag_id, owner;
		float  lat, lng;
		CGPoint btn;
		
		
		//Allocate vertex array buffer
		if(theDelegate.vertexBuffer_1 == NULL)
			theDelegate.vertexBuffer_1 = malloc(theDelegate.vertexMax_1 * 3 * sizeof(GLfloat));
		if(theDelegate.vertexBuffer_2 == NULL)
			theDelegate.vertexBuffer_2 = malloc(theDelegate.vertexMax_2 * 3 * sizeof(GLfloat));
		if(theDelegate.vertexBuffer_3 == NULL)
			theDelegate.vertexBuffer_3 = malloc(theDelegate.vertexMax_3 * 3 * sizeof(GLfloat));
		if(theDelegate.vertexBuffer_4 == NULL)
			theDelegate.vertexBuffer_4 = malloc(theDelegate.vertexMax_4 * 3 * sizeof(GLfloat));
		
		theDelegate.count_1=0;
		theDelegate.count_2=0;
		theDelegate.count_3=0;
		theDelegate.count_4=0;
		
		
		
		for (ndx = 0; ndx < theDelegate.jFArray.count; ndx++) {
			NSDictionary *itemAtIndex = (NSDictionary *)[theDelegate.jFArray objectAtIndex:ndx];
			model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
			flag_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];
			owner = [[itemAtIndex objectForKey:@"winner"] intValue];
			
			lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
			lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
			
		//	btn.x=-(lng);//-32;
			//btn.y=lat;//+34;
			
			btn.x=(lng);
			//negative direction opengl & iphone
			btn.y= -(lat);
			
		
		//	btn.x=(lng-theDelegate.minLatLon.y)*(1154.7)/(theDelegate.maxLatLon.y-theDelegate.minLatLon.y);
		//	btn.y= (lat-theDelegate.minLatLon.x)*(1154.7)/(theDelegate.maxLatLon.x-theDelegate.minLatLon.x);
			
			
			if (owner==1)
			{
				if(theDelegate.vertexCount_1 == theDelegate.vertexMax_1) {
					theDelegate.vertexMax_1 = 2 * theDelegate.vertexMax_1;
					theDelegate.vertexBuffer_1 = realloc(theDelegate.vertexBuffer_1, theDelegate.vertexMax_1 * 3 * sizeof(GLfloat));
				}
				theDelegate.vertexBuffer_1[3 * theDelegate.vertexCount_1 + 0] = btn.x;
				theDelegate.vertexBuffer_1[3 * theDelegate.vertexCount_1 + 1] = btn.y;
				theDelegate.vertexBuffer_1[3 * theDelegate.vertexCount_1 + 2] = 0.0f;
			 	theDelegate.vertexCount_1 += 1;
			}
			if (owner==2)
			{
				if(theDelegate.vertexCount_2 == theDelegate.vertexMax_2) {
					theDelegate.vertexMax_2 = 2 * theDelegate.vertexMax_2;
					theDelegate.vertexBuffer_2 = realloc(theDelegate.vertexBuffer_2, theDelegate.vertexMax_2 * 3 * sizeof(GLfloat));
				}
				theDelegate.vertexBuffer_2[3 * theDelegate.vertexCount_2 + 0] = btn.x;
				theDelegate.vertexBuffer_2[3 * theDelegate.vertexCount_2 + 1] = btn.y;
				theDelegate.vertexBuffer_2[3 * theDelegate.vertexCount_2 + 2] = 0.0f;
			 	theDelegate.vertexCount_2 += 1;
			}
			if (owner==3)
			{
				if(theDelegate.vertexCount_3 == theDelegate.vertexMax_3) {
					theDelegate.vertexMax_3 = 2 * theDelegate.vertexMax_3;
					theDelegate.vertexBuffer_3 = realloc(theDelegate.vertexBuffer_3, theDelegate.vertexMax_3 * 3 * sizeof(GLfloat));
				}
				theDelegate.vertexBuffer_3[3 * theDelegate.vertexCount_3 + 0] = btn.x;
				theDelegate.vertexBuffer_3[3 * theDelegate.vertexCount_3 + 1] = btn.y;
				theDelegate.vertexBuffer_3[3 * theDelegate.vertexCount_3 + 2] = 0.0f;
			 	theDelegate.vertexCount_3 += 1;
			}
			if (owner==4)
			{
				if(theDelegate.vertexCount_4 == theDelegate.vertexMax_4) {
					theDelegate.vertexMax_4 = 2 * theDelegate.vertexMax_4;
					theDelegate.vertexBuffer_4 = realloc(theDelegate.vertexBuffer_4, theDelegate.vertexMax_4 * 3 * sizeof(GLfloat));
				}
				theDelegate.vertexBuffer_4[3 * theDelegate.vertexCount_4 + 0] = btn.x;
				theDelegate.vertexBuffer_4[3 * theDelegate.vertexCount_4 + 1] = btn.y;
				theDelegate.vertexBuffer_4[3 * theDelegate.vertexCount_4 + 2] = 0.0f;
			 	theDelegate.vertexCount_4 += 1;
			}
			
		}
			
	
	}
	
}	

-(void)putModels:(CGPoint) p/*:(NSDictionary *)dict*/ {
	
	
	int ndx;
	NSInteger model_id, num_cameras, num_points, last_image_id, last_player_id, last_points_added, max_percent;
	NSString *rep_image, *overlay_image, *name, *time_ago;
	float north, east, west, south, lat, lng;
	CGPoint v_a, v_b, btn;
	site = @"http://photocity.cs.washington.edu/";
	imgSize = 1024;
	UIImageView *tempImageView;
	//tempImageView.opaque=YES;
	for (ndx = 0; ndx < self.jsonArray.count; ndx++) {
		NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonArray objectAtIndex:ndx];
		model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
		num_cameras = [[itemAtIndex objectForKey:@"num_cameras"] intValue];
		num_points = [[itemAtIndex objectForKey:@"num_points"] intValue];
		rep_image = [site stringByAppendingString:[itemAtIndex objectForKey:@"rep_image"]];
		overlay_image = [site stringByAppendingString:[itemAtIndex objectForKey:@"overlay_image"]];
		name = [itemAtIndex objectForKey:@"name"];
		north = [[itemAtIndex objectForKey:@"north"] floatValue];
		south = [[itemAtIndex objectForKey:@"south"] floatValue];
		east = [[itemAtIndex objectForKey:@"east"] floatValue];
		west = [[itemAtIndex objectForKey:@"west"] floatValue];
		lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
		lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
		last_image_id = [[itemAtIndex objectForKey:@"last_image_id"] intValue];
		last_player_id = [[itemAtIndex objectForKey:@"last_player_id"] intValue];
		last_points_added = [[itemAtIndex objectForKey:@"last_points_added"] intValue];
		max_percent = [[itemAtIndex objectForKey:@"max_percent"] intValue];
		time_ago = [itemAtIndex objectForKey:@"time_ago"];
		
		v_a.x=(west-minBound.x)*imgSize/(maxBound.x-minBound.x);
		v_a.y=(north-minBound.y)*imgSize/(maxBound.y-minBound.y);
		v_b.x=(east-west)*imgSize/(maxBound.x-minBound.x);
		v_b.y=(south-north)*imgSize/(maxBound.y-minBound.y);
		btn.x=(lng-minBound.x)*imgSize/(maxBound.x-minBound.x);
		btn.y=(lat-minBound.y)*imgSize/(maxBound.y-minBound.y);
		
		CGPoint pos = CGPointMake(v_a.x*scale-p.x,v_a.y*scale-p.y);
		
		if ( pos.x + v_b.x*scale < 0 ||  pos.y + v_b.y*scale < 0 || pos.x > self.frame.size.width || pos.y > self.frame.size.height )
		{   
			//NSLog(@"no show %s , %f, %f", [name cString], pos.x, pos.y);
			continue;
		}
		
		//NSLog(@"show %s , %f, %f", [name cString], pos.x, pos.y);

		
		//NSURL *urlp=[NSURL URLWithString:overlay_image];
		//[theDelegate displayImageWithURL:urlp];
		tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: overlay_image]]]];
		//tempImageView = [[UIImageView alloc] initWithImage:[overlay_images objectAtIndex:model_id-1]];//[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: overlay_image]]]];
		//tempImageView = [[UIImageView alloc] initWithImage:theDelegate.cacheImg];
		
		tempImageView.frame = CGRectMake(v_a.x-p.x/scale, v_a.y-p.y/scale, v_b.x, v_b.y);
		
	//	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
	//	[button setFrame:CGRectMake(btn.x-(p.x+25)/scale, btn.y-(p.y+50)/scale, 50/scale, 50/scale)]; 
	//	[button setBackgroundImage:[UIImage imageNamed:@"model.png"] forState:UIControlStateNormal];
		
		//UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark ]; 
		//button.center=CGPointMake(btn.x-p.x/scale, btn.y-p.y/scale);
	//	button.opaque=YES;
	//	[button setTag:model_id];
	//	[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		//add
		[detailedImageView addSubview:tempImageView];
	//	[detailedImageView addSubview:button];
		[tempImageView release];
		//[itemAtIndex release];
		
		
	}
	
	// setting up the imageView now
	//self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [site stringByAppendingString:[dict objectForKey:@"rep_image"]]  ]]];
}


-(void)putModelBtns:(CGPoint) p/*:(NSDictionary *)dict*/ {
	
	
	int ndx;
	NSInteger model_id;
	float north, east, west, south, lat, lng;
	CGPoint v_a, v_b, btn;
	imgSize = 1024;
	for (ndx = 0; ndx < self.jsonArray.count; ndx++) {
		NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonArray objectAtIndex:ndx];
		model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
		north = [[itemAtIndex objectForKey:@"north"] floatValue];
		south = [[itemAtIndex objectForKey:@"south"] floatValue];
		east = [[itemAtIndex objectForKey:@"east"] floatValue];
		west = [[itemAtIndex objectForKey:@"west"] floatValue];
		lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
		lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
		
		v_a.x=(west-minBound.x)*imgSize/(maxBound.x-minBound.x);
		v_a.y=(north-minBound.y)*imgSize/(maxBound.y-minBound.y);
		v_b.x=(east-west)*imgSize/(maxBound.x-minBound.x);
		v_b.y=(south-north)*imgSize/(maxBound.y-minBound.y);
		btn.x=(lng-minBound.x)*imgSize/(maxBound.x-minBound.x);
		btn.y=(lat-minBound.y)*imgSize/(maxBound.y-minBound.y);
		
		CGPoint pos = CGPointMake(btn.x*scale-p.x,btn.y*scale-p.y);
		
		if ( pos.x < 0 ||  pos.y < 0 || pos.x > self.frame.size.width || pos.y > self.frame.size.height )
		{   
			//NSLog(@"no show %s , %f, %f", [name cString], pos.x, pos.y);
			continue;
		}
		
		//NSLog(@"show %s , %f, %f", [name cString], pos.x, pos.y);
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
		[button setFrame:CGRectMake(btn.x-(p.x+25)/scale, btn.y-(p.y+50)/scale, 50/scale, 50/scale)]; 
		[button setBackgroundImage:[UIImage imageNamed:@"model.png"] forState:UIControlStateNormal];
		
		//UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark ]; 
		//button.center=CGPointMake(btn.x-p.x/scale, btn.y-p.y/scale);
		button.opaque=NO;
		[button setTag:model_id];
		//[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		//add
		[detailedImageView addSubview:button];
		
		
	}
	
}

- (void) putMe
{
	meBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
	[meBtn setBackgroundImage:[UIImage imageNamed:@"me3.png"] forState:UIControlStateNormal];
	[meBtn setFrame:CGRectMake(theDelegate.lastLocation.x-(/*positionvertex.x*/+25)/scale, theDelegate.lastLocation.y-(/*positionvertex.y*/+25)/scale, 50/scale, 50/scale)];
	[[theDelegate.viewController glView] addSubview:meBtn];
	
	if (!updateLoc_ind)
	{
		meBtn.hidden=NO;
	}
	else
	{
		meBtn.hidden=YES;
	}
	
}
- (void) putFlags:(CGPoint)p
{
	
	
	int ndx;
	NSInteger model_id, flag_id, owner;
	float  lat, lng;
	
	CGPoint btn;
	imgSize = 1024;
	
	
	for (ndx = 0; ndx < self.jsonFArray.count; ndx++) {
		NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonFArray objectAtIndex:ndx];
		model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
		flag_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];
		owner = [[itemAtIndex objectForKey:@"winner"] intValue];
		
		lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
		lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
		
		btn.x=(lng-minBound.x)*imgSize/(maxBound.x-minBound.x)+30;
		btn.y=(lat-minBound.y)*imgSize/(maxBound.y-minBound.y)+55;
		
		CGPoint pos = CGPointMake(btn.x*scale-p.x,btn.y*scale-p.y);
		
		/*
		if ( pos.x < 0 ||  pos.y < 0 || pos.x > self.frame.size.width || pos.y > self.frame.size.height )
		{   
			//NSLog(@"no show %s , %f, %f", [name cString], pos.x, pos.y);
			continue;
		}
		*/
		
		//NSLog(@"show %s , %f, %f", [name cString], pos.x, pos.y);
		
		UIButton *flagBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
		[flagBtn setFrame:CGRectMake(btn.x, btn.y, 32/scale, 32/scale)]; 
		if (owner == 1)
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"red_flag.png"] forState:UIControlStateNormal];
		else if (owner == 2)
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"cyan_flag.png"] forState:UIControlStateNormal];
		else if (owner == 3)
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"yellow_flag.png"] forState:UIControlStateNormal];
		else if (owner == 4)
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"green_flag.png"] forState:UIControlStateNormal];
		else
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"white_flag.png"] forState:UIControlStateNormal];
		
		//UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark ]; 
		//button.center=CGPointMake(btn.x-p.x/scale, btn.y-p.y/scale);
		flagBtn.opaque=YES;
		[flagBtn setTag:flag_id];
		[flagBtn addTarget:self action:@selector(flagTouched:) forControlEvents:UIControlEventTouchUpInside];
		
		//add
	//	[[theDelegate.viewController glView] addSubview:flagBtn];
		
		
		
	}
	
	
}	


-(void)getDetailedModelData:(NSDictionary *)dict {
	//self.titleLabel.text = [dict objectForKey:@"name"];
	//self.urlLabel.text = [dict objectForKey:@"rep_image"];
	//self.itemID = (NSInteger)[dict objectForKey:@"model_id"];
	//	NSLog(@"%s", (NSInteger)[1 objectForKey:@"rep_image"]);
	//	cell.text = (NSString *)[self.jsonArray objectAtIndex:indexPath.row];
	
	//	NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonArray objectAtIndex:indexPath.row];
	//	cell.text = [itemAtIndex objectForKey:@"title"];
	
	// setting up the imageView now
	//self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [site stringByAppendingString:[dict objectForKey:@"rep_image"]]  ]]];
}



/////////////////////////////////////
- (void)showWebView:(BOOL)show
{
	// reset the timer

	
	
	// fade animate the view out of view by affecting its alpha
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	if (show)
	{
		[self showLoginView:0];
		[self showHoverView:0];
		
		// as we start the fade effect, start the timeout timer for automatically hiding HoverView
		[self buildWebView];
		webViewFrame.alpha = 1.0;
		//self.scrollEnabled = NO;
		noTouch = 1;
		detailedImageView.userInteractionEnabled = NO;
		[detailedImageView bringSubviewToFront:webViewFrame];
		if ( [self.serverButton isEnabled]==YES )
		{
			
		}
	}
	else
	{
		webViewFrame.alpha = 0.0;
		//self.scrollEnabled = YES;
		noTouch = 0;
		detailedImageView.userInteractionEnabled = YES;
		self.uploadButton.enabled  = NO;
		self.uploadButton.badgeValue=@"Off";
		self.captureButton.enabled = NO;
		self.captureButton.badgeValue=@"Off";
	}
	
	[UIView commitAnimations];
}

- (void)showConfView:(BOOL)show
{
	
	if (show)
	{
		// as we start the fade effect, start the timeout timer for automatically hiding HoverView
		[self buildConfView];
		confView.alpha = 1.0;
		//self.scrollEnabled = NO;
		detailedImageView.userInteractionEnabled = NO;
		[detailedImageView bringSubviewToFront:confView];
		
	}
	else
	{
		confView.alpha = 0.0;
		//self.scrollEnabled = YES;
		detailedImageView.userInteractionEnabled = YES;
		
	}
	
}


- (void)showLoginView:(BOOL)show
{
	
	
	// fade animate the view out of view by affecting its alpha
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	if (show)
	{
		[self showWebView:0];
		[self showHoverView:0];
		
		// as we start the fade effect, start the timeout timer for automatically hiding HoverView
		[self buildLoginView];
		loginView.alpha = 1.0;
		//self.scrollEnabled = NO;
		noTouch = 1;
		detailedImageView.userInteractionEnabled = NO;
		[detailedImageView bringSubviewToFront:loginView];
		if ( [self.serverButton isEnabled]==YES )
		{
		
		}
	}
	else
	{
		loginView.alpha = 0.0;
		//self.scrollEnabled = YES;
		detailedImageView.userInteractionEnabled = YES;
		noTouch = 0;
		self.uploadButton.enabled  = NO;
		self.captureButton.enabled = NO;
	}
	
	[UIView commitAnimations];
}


- (void)showHoverView:(BOOL)show
{
	// reset the timer
	[myTimer invalidate];
	[myTimer release];
	myTimer = nil;
	
	// fade animate the view out of view by affecting its alpha
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	if (show)
	{
		// as we start the fade effect, start the timeout timer for automatically hiding HoverView
		more_btn.hidden = NO;
		infoView.hidden=YES;
		[self buildHoverView];
		hoverView.alpha = 1.0;
		myTimer = [[NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
		//self.scrollEnabled = NO;
		noTouch = 1;
		[detailedImageView bringSubviewToFront:hoverView];
		if ( server_ind==1 && theDelegate.is_login==1 )
		{
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			{
				h_take_btn.hidden=NO;
			}
			h_upload_btn.hidden=NO;
			/*
			self.uploadButton.enabled  = YES;
			self.uploadButton.badgeValue=@"On";
			self.captureButton.enabled = YES;
			self.captureButton.badgeValue=@"On";
			 */
		}
	}
	else
	{
		hoverView.alpha = 0.0;
		//self.scrollEnabled = YES;
		if ( check_focusFlag == 1 ) 
		{
			[focusFlag removeFromSuperview];
			check_focusFlag = 0;
		}
		detailedImageView.userInteractionEnabled = YES;
		noTouch = 0;
		self.uploadButton.enabled  = NO;
		self.uploadButton.badgeValue=@"Off";
		self.captureButton.enabled = NO;
		self.captureButton.badgeValue=@"Off";
	}
	
	[UIView commitAnimations];
}

- (void)timerFired:(NSTimer *)timer
{
	// time has passed, hide the HoverView
	[self showHoverView: NO];
	[self showLoginView: NO];
	
}

- (void)closeHoverView
{
	[self showHoverView: NO];
	NSLog(@"close");
}

- (void)closeWebView
{
	[self showWebView: NO];
	//webView.
	NSLog(@"close web");
}

- (void)closeLoginView
{
	[userID resignFirstResponder];
	[userPSWD resignFirstResponder];
	[self showLoginView: NO];
	NSLog(@"close login");
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)showViewNotif:(NSNotification *)aNotification
{
	// start over - reset the timer
	[myTimer invalidate];
	[myTimer release];
	myTimer = nil;
	
	[self showHoverView:1];
}

- (void)showWebViewNotif:(NSNotification *)aNotification
{
	[self showWebView:1];
}

- (void)showConfViewNotif:(NSNotification *)aNotification
{
	[self showConfView:1];
}

- (void)showLoginViewNotif:(NSNotification *)aNotification
{

	
	[self showLoginView:1];
}

- (IBAction)loginCommit
{
	// user touched the left button in HoverView
	NSLog(@"Login btn");
	//add if login
	[self showLoginView:NO];
	

}

- (IBAction)signUp
{
	if (theDelegate.is_login == 0)
	{
		[userID resignFirstResponder];
		[userPSWD resignFirstResponder];
		dispStatus_ind=-1;
		signUp_btn.hidden=NO;
	}
	else
	{
		signUp_btn.hidden=YES;
	}
	[self showLoginView:0];
	[self showWebView:1];

}

- (IBAction)uploadPic
{
	// user touched the left button in HoverView
	NSLog(@"Left btn");
	[self showHoverView:NO];
	[theDelegate flipView:1];
}

- (IBAction)takePic
{
	// user touched the right button in HoverView
	NSLog(@"Right btn");
	[self showHoverView:NO];	
	[theDelegate flipView:2];
}

- (IBAction)gotoStatusPage
{
	// user touched the left button in HoverView
	NSLog(@"StatusPage");
	[theDelegate flipView:3];
}

- (void)selectPhotoStatus
{
	
	if (theDelegate.is_login)
	{
		dispStatus_ind = 1;
		NSString *tempString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/iphone/photos.php?player_id=%@", [NSString stringWithFormat:@"%d",  theDelegate.p_id]];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempString]]];
		webViewTitle.text = @"My Photo Status";
		[self showWebView:1];
	}
	else
	{	
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Required" message:@"Please login to see your own stash."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
}

- (void)selectScoreBoard
{
	[self showHoverView:0];
	[self showLoginView:0];
	dispStatus_ind = 0;
	[self showWebView:1];	
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	//NSLog(@"tabbar");
    NSString *title =  item.title;
	if ( [title isEqualToString:@"Photo Status"] )
	{
		dispStatus_ind = 1;
		NSString *tempString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/iphone/photos.php?player_id=%@", [NSString stringWithFormat:@"%d",  theDelegate.p_id]];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempString]]];
		webViewTitle.text = @"My Photo Status";
		[self showWebView:1];
	
	}
	else if ([title isEqualToString:@"Capture Image"] )
	{
		
		[self takePic];
	}
	else if ( [title isEqualToString:@"Score Board"] )
	{
		
		[self showHoverView:0];
		[self showLoginView:0];
		dispStatus_ind = 0;
		[self showWebView:1];
	}
	else if ( [title isEqualToString:@"Server Status"] )
	{
	}
	
	
	
}


- (void)changeCenter: (NSNotification *)aNotification{
	
	//MKCoordinateRegion region;
	//region.center.latitude     = 47.655;//(maxLat + minLat) / 2;
	//region.center.longitude    = -122.505;//(maxLon + minLon) / 2;
	[_mapView setCenterCoordinate:theDelegate.movingCenter animated:YES];	
	//[self.mapView setCenterCoordinate:region.center animated:YES];
	
}


- (void) performCurl 
{ 
	// Curl the image up or down 
	
	NSLog(@"Curl");
	[detailedImageView removeFromSuperview];
	[self showLoginView:0];
	[self showHoverView:0];
	[self showWebView:0];
	contentView.userInteractionEnabled=NO;
	detailedImageView.userInteractionEnabled=NO;
	
	//[self performSelectorInBackground:@selector(curlPage) withObject:nil];
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(curlPage) userInfo:nil repeats:NO];

} 



- (void) curlPage
{
	
	 // Curl the image up or down
	 CATransition *animation = [CATransition animation];
	 [animation setDelegate:self];
	 [animation setDuration:0.95f];
	 [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	 //animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.75 :0.25 :0.75 :0.66];
	 if (notCurled){
	 
	 animation.type = @"pageCurl";
	 animation.fillMode = kCAFillModeForwards;
	 //animation.endProgress = 0.65;
	 } else {
	 animation.type = @"pageUnCurl";
	 animation.fillMode = kCAFillModeBackwards;
	 //animation.startProgress = 0.35;
	 }
	// [animation setRemovedOnCompletion:NO];
	 //[contentView exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
	 //[contentView bringSubviewToFront:confView];
	 
	 
	 [[self layer] addAnimation:animation forKey:@"pageCurlAnimation"];
	 
	// Disable user interaction where necessary
	if (notCurled) {
		[[NSNotificationCenter defaultCenter] postNotificationName:Show_ConfView object:nil];
	} else {
		[self showConfView:0];
		[contentView insertSubview:detailedImageView atIndex:1];
		contentView.userInteractionEnabled=YES;
		detailedImageView.userInteractionEnabled=YES;
	}
	
	notCurled = !notCurled;
	
}
 

/*


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"GY Hit Test");
	
	NSLog([NSString stringWithFormat:@"%f, %f", point.x,point.y]);
	
    self = [super hitTest:point withEvent:event];
	[self hitTest:point withEvent:event];
    return self;
}


- (void) sendEvent:(UIEvent*)event {
	NSLog(@"GY Send Event");
	[super sendEvent:event];
} 

//Then, when an event is fired, we log this one and then send it back to the viewTouched we kept, and voilà!!! :)
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"GY Touch Began");
	//    [viewTouched touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"GY Touch Moved");
	[super touchesMoved:touches withEvent:event];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"GY Touch Ended");
    //[viewTouched touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"GY Touch Cancelled");
	
}

*/


@end
///////////////////////


@implementation GYImageView (UIWebViewDelegate)

- (void)webViewDidStartLoad:(UIWebView *)wView{
	webView.alpha=0;
	NSLog(@"loading started");
	[wActInd startAnimating];
	[theDelegate startAnimation];
}
- (void)webViewDidFinishLoad:(UIWebView *)wView{
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:1];        // sets animation duration
	webView.alpha=0.9;
	[UIView commitAnimations];
	NSLog(@"finished loading");
	[wActInd stopAnimating];
	[theDelegate stopAnimation];
}	



@end

