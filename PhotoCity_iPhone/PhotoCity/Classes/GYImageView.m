
#import "GYImageView.h"
#import "HoverView.h"
#import "ImageViewAppDelegate.h"
#import "ImageViewViewController.h"
#import <JSON/JSON.h>


NSString *Show_HoverView = @"SHOW";
NSString *Show_LoginView = @"LSHOW";
NSString *Show_WebView = @"WSHOW";

const int kGYImageViewMaxImageWidth = 5000;
const int kGYImageViewMaxImageHeight = 5000;

const int kGYImageViewMaxLowResImageWidth = 512;
const int kGYImageViewMaxLowResImageHeight = 512;

@implementation GYImageView

@synthesize scale, imageViewDelegate, contentView;

//views
@synthesize webViewFrame;
@synthesize webView;
@synthesize loginView;
@synthesize hoverView;

//JSON
@synthesize jsonArray;
@synthesize jsonFArray;
@synthesize jsonUArray;

@synthesize theDelegate;
@synthesize overlay_images;


//webView
@synthesize closeW_btn;
@synthesize more_btn;
@synthesize focusFlag;
@synthesize playerPointsLabel;
@synthesize playerPoints;
@synthesize t1PointsLabel;
@synthesize t2PointsLabel;
@synthesize t1Points;
@synthesize t2Points;
@synthesize flagNumber;
@synthesize modelName;
@synthesize infoView;
@synthesize close_btn;

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
@synthesize reloadButton;
@synthesize showModelsButton;
@synthesize loginButton;

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

- (GYImageView *)init
{

	self.bounces=NO;
	[self setMultipleTouchEnabled:YES];
	
	
  contentView = [[UIView alloc] initWithFrame:self.frame];
  [self addSubview:contentView];
  super.delegate = self;
  scale = 1;
	server_ind =0;
	disp_ind = 1;
	check_focusFlag = 0;
	dispStatus_ind = 0;
	theDelegate.is_login = 0;

	
	
	check_focusFlag = 0;

	
	theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];

	[self refresh];
	//urlDelegate = (URLCacheAppDelegate*)[[UIApplication sharedApplication] delegate];
	
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
  if ([imageViewDelegate respondsToSelector:@selector(imageViewWillUpdate:)])
    [imageViewDelegate imageViewWillUpdate:self];

  CGImageRef destImage = GYImageCreateScaledDown(rawImage,
                                                 kGYImageViewMaxLowResImageWidth,
                                                 kGYImageViewMaxLowResImageHeight);

  UIImage *uiImage = [[UIImage alloc] initWithCGImage:destImage];

  CGImageRelease(destImage);

  [imageView removeFromSuperview];
  [imageView release];

  imageView = [[UIImageView alloc] initWithImage:uiImage];
  [uiImage release];

  imageView.frame = (CGRect) {
    imageView.frame.origin, {
      CGImageGetWidth(rawImage), CGImageGetHeight(rawImage)
    }
  };
  contentView.frame = imageView.frame;
  self.contentSize = imageView.frame.size;

	imageView.opaque = YES;
  [contentView insertSubview:imageView atIndex:0];
  [self updateDetailedImageView];

  if ([imageViewDelegate respondsToSelector:@selector(imageViewDidUpdate:)])
    [imageViewDelegate imageViewDidUpdate:self];
}

- (void)updateDetailedImageView
{
	
	
  if ([imageViewDelegate respondsToSelector:@selector(imageViewWillUpdateDetailed:)])
    [imageViewDelegate imageViewWillUpdateDetailed:self];

  [detailedImageView removeFromSuperview];
  [detailedImageView release];
	

	
	uploadButton.enabled=NO;
	uploadButton.badgeValue=@"Off";
	captureButton.enabled=NO;
	captureButton.badgeValue=@"Off";
	playerStatus.enabled=YES;
	playerStatus.badgeValue=@"Unknown";
	serverButton.enabled=NO;
	serverButton.badgeValue=@"Unknown";
	
	if (server_ind==1)
	{
		self.serverButton.enabled = YES;
		self.serverButton.badgeValue= @"Alive";
	}

	
	
  CGPoint p = self.contentOffset;
  p.x = MAX(0, p.x);
  p.y = MAX(0, p.y);
  p.x = MIN(p.x, self.contentSize.width - self.frame.size.width);
  p.y = MIN(p.y, self.contentSize.height - self.frame.size.height);

	positionvertex=p;

  CGRect rect = CGRectMake(p.x / scale, p.y / scale, self.frame.size.width / scale, self.frame.size.height / scale);

  CGImageRef subimage = CGImageCreateWithImageInRect(rawImage, rect);
  UIImage *uiImage = [UIImage imageWithCGImage:subimage];
  CGImageRelease(subimage);

  detailedImageView = [[UIImageView alloc] initWithImage:uiImage];
	detailedImageView.userInteractionEnabled = NO;
  detailedImageView.frame = rect;
	detailedImageView.opaque=YES;
  [contentView insertSubview:detailedImageView atIndex:1];

	//add buildings
	[theDelegate startAnimation];
	//[self loadJSONData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_models.php"] ];
	//[theDelegate clearCache];
	if (disp_ind == 2)
	{
		[self putModels:p];
	}
	if (disp_ind == 1)
	{
		[self putModelBtns:p];
		[self putFlags:p];
	}
	//[self loadJSONFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_flags.php"] ];
	if (disp_ind == 0)
	[self putModelBtns:p];
	
	[theDelegate stopAnimation];
	
	
	
	
	
	//[detailedImageView addSubview:loginView];

	//[detailedImageView addSubview:hoverView];
	
	[self insertSubview:hoverView atIndex:2];
	[self insertSubview:loginView atIndex:3];
	[self insertSubview:webViewFrame atIndex:4];
	[webViewFrame insertSubview: webView atIndex:1];
	
	//add buildings end
	
  if ([imageViewDelegate respondsToSelector:@selector(imageViewDidUpdateDetailed:)])
    [imageViewDelegate imageViewDidUpdateDetailed:self];

	detailedImageView.userInteractionEnabled = YES;
	
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
	frame.origin.x = positionvertex.x + 4;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = positionvertex.y + 53;//detailedImageView.frame.size.height - 100;
	webViewFrame.frame = frame;
	
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
	if (dispStatus_ind==1)
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://photocity.cs.washington.edu/iphone/scores.php"]]];
	else if (dispStatus_ind==-1)
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://photocity.cs.washington.edu/new_account.php"]]];
	else if (dispStatus_ind==0)
	{
		if ( theDelegate.is_login == 1 )
		{
			NSString *tempString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/iphone/photos.php?player_id=%@", [NSString stringWithFormat:@"%d",  theDelegate.p_id]];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempString]]];
		}
		else
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://photocity.cs.washington.edu/iphone/scores.php"]]];

		
	}
	[theDelegate stopAnimation];
		
}



- (void)buildLoginView
{
	CGRect frame = loginView.frame;
	frame.size.width=0.95*self.window.bounds.size.width;
	frame.size.height=0.16*self.window.bounds.size.height;
	frame.origin.x = positionvertex.x + 8;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = positionvertex.y + 53;//detailedImageView.frame.size.height - 100;
	loginView.frame = frame;
	
	[closeL_btn setFrame:CGRectMake(10,40, 30, 30)];
	[closeL_btn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[closeL_btn addTarget:self action:@selector(closeLoginView) forControlEvents:UIControlEventTouchUpInside];
	
	userID.center=CGPointMake(120,20);
	userPSWD.center=CGPointMake(120,55);
	login_btn.center= CGPointMake(240,20);
	signUp_btn.center= CGPointMake(240,55);
	
}

- (IBAction)login {
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
	 */
	[userID resignFirstResponder];
	[userPSWD resignFirstResponder];
	
	[theDelegate startAnimation];
	NSString *jsonString = [NSString stringWithFormat:@"http://photocity.cs.washington.edu/check_password.php?username=%@&pass=%@", userID.text, userPSWD.text];
	
	NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonString];
	while([ms replaceOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [ms length])] > 0);
	jsonString = ms;
	
	//NSURL *jsonURL = [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_models.php"];
	NSURL *jsonURL = [NSURL URLWithString:jsonString];	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	


	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"The webservice you are accessing is down. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
		
		if ( [result isEqualToString:@"true"] )
		{
			theDelegate.is_login = 1;
			loginButton.title=userID.text;
			theDelegate.p_id=[ [dictionary objectForKey:@"player_id"] intValue ];
			
			if ([dictionary objectForKey:@"contributions"] != nil )
			{
				self.jsonUArray =  [dictionary objectForKey:@"contributions"] ;
			}
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

-(void)buildHoverView
{
	
	// determine the size of HoverView
	//Build Flag Hoverview
	CGRect frame = hoverView.frame;
	frame.size.width=0.95*self.window.bounds.size.width;
	frame.size.height=0.39*self.window.bounds.size.height;
	frame.origin.x = positionvertex.x + 8;//round((detailedImageView.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = positionvertex.y + 53;//detailedImageView.frame.size.height - 100;
	hoverView.frame = frame;
	//close_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//[upload_btn setFrame:CGRectMake(100/scale,100/scale, 80/scale, 40/scale)];
	//[capture_btn setFrame:CGRectMake(160,100, 80, 40)];
	[close_btn setFrame:CGRectMake(10,145, 30, 30)];
	[close_btn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[close_btn addTarget:self action:@selector(closeHoverView) forControlEvents:UIControlEventTouchUpInside];

	[more_btn setFrame:CGRectMake(45,146, 30, 30)];
	[more_btn addTarget:self action:@selector(dispModel) forControlEvents:UIControlEventTouchUpInside];

	modelName.text = theDelegate.m_name;
	flagNumber.text = [NSString stringWithFormat:@"%d",  theDelegate.f_id];
	
	
	
	// show team/player points
	
	int max;
	if (theDelegate.team1_points >= theDelegate.team2_points)
		max = theDelegate.team1_points;
	else
		max = theDelegate.team2_points;

	if (max == 0)
	{
		theDelegate.team1_points = 0;
		theDelegate.team2_points = 0;

	}
	
	

	if (theDelegate.is_login)
	{
		playerPoints.hidden = NO;
		playerPointsLabel.hidden = NO;
		playerPointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.player_points];
		playerPointsLabel.textAlignment = UITextAlignmentRight;
		playerPointsLabel.textColor = [UIColor orangeColor];
		[playerPoints setFrame:CGRectMake(81,115, theDelegate.player_points*80/max, 8) ];
		[playerPoints setBackgroundColor:[UIColor orangeColor]];
	}
	else
	{
		playerPoints.hidden = YES;
		playerPointsLabel.hidden = YES;
	}
	
	t1PointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.team1_points];
	t1PointsLabel.textAlignment = UITextAlignmentRight;
	t1PointsLabel.textColor = [UIColor redColor];
	
	t2PointsLabel.text = [NSString stringWithFormat:@"%d",   theDelegate.team2_points];
	t2PointsLabel.textAlignment = UITextAlignmentRight;
	t2PointsLabel.textColor = [UIColor blueColor];
	
	[t1Points setFrame:CGRectMake(81,75, theDelegate.team1_points*80/max, 8) ];
	[t1Points setBackgroundColor:[UIColor redColor]];
	[t2Points setFrame:CGRectMake(81,95, theDelegate.team2_points*80/max, 8)];
	[t2Points setBackgroundColor:[UIColor blueColor]];
}

- (IBAction) refresh
{
	[theDelegate startAnimation];
	[self loadJSONData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_models.php"] ];
	[self loadJSONFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_flags.php"] ];	
	[self loadJSONServerData:[NSURL URLWithString:@"http://fusion.cs.washington.edu:8000/heartbeat"] ];

	[theDelegate stopAnimation];
}


- (IBAction) changeDisp
{
	disp_ind++;
	if (disp_ind==3)
		disp_ind=0;
	 [self updateDetailedImageView];
}
- (void) dispModel
{
	
	[theDelegate startAnimation];
	infoView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: theDelegate.img_URL]]];
	[infoView setFrame:CGRectMake(130, 38, 165, 142)];
	[theDelegate stopAnimation];
	more_btn.enabled = NO;
}

-(IBAction)loginStart {
	NSLog(@"Login Button Pressed!");
 	[self showWebView:0];
	[self showHoverView:0];
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
	
-(void)flagTouched: (id)sender {
	NSLog(@"Flag Touched!");
    //NSLog(@"Selected cell is %d", [sender tag]);
	//[theDelegate startAnimation];
	//[self loadJSONFData: [NSURL URLWithString:@"http://photocity.cs.washington.edu/get_flags.php"] ];
	//[theDelegate stopAnimation];
	int flag_id;
	float  lat, lng;
		
	
	CGPoint btn;
	imgSize = 1024;
	
	NSDictionary *itemAtIndex = (NSDictionary *)[self.jsonFArray objectAtIndex:[sender tag]-1];
	theDelegate.m_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
	theDelegate.f_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];


	lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
	lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
	
	if (  [[itemAtIndex objectForKey:@"owner"] intValue] != 0 )
	{
		NSDictionary *pointsArray =  [itemAtIndex objectForKey:@"points"] ;
		if( [[pointsArray objectForKey:@"1"] intValue] != nil )
			theDelegate.team1_points = [[pointsArray objectForKey:@"1"] intValue];
		else
			theDelegate.team1_points = 0;
		if( [[pointsArray objectForKey:@"2"] intValue] != nil )
			theDelegate.team2_points = [[pointsArray objectForKey:@"2"] intValue];
		else
			theDelegate.team2_points = 0;
	}
	else
	{
		theDelegate.team1_points = 0;
		theDelegate.team2_points = 0;
	}
	

	if (theDelegate.is_login)
	{
		theDelegate.player_points = 0;
		for (int ndx = 0; ndx < self.jsonUArray.count; ndx++) {		
			itemAtIndex = (NSDictionary *)[self.jsonUArray objectAtIndex:ndx];
			if( theDelegate.m_id == [[itemAtIndex objectForKey:@"model_id"] intValue]) //show user score
			{
				theDelegate.player_points = [[itemAtIndex objectForKey:@"points"] intValue];
			}
			
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
	
	//[focusFlag release];
	
	//[itemAtIndex release];

	[[NSNotificationCenter defaultCenter] postNotificationName:Show_HoverView object:nil];
	
}

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

- (void)dealloc
{
  CGImageRelease(rawImage);
  [imageView release];
  [detailedImageView release];
	
	//loginView
	[ userID release];
	[ userPSWD release];
	[ login_btn release];
	[ signUp_btn release];
	[closeL_btn release];
	[loginView release];
	
	//hoverView
	[playerPoints release];
	[playerPointsLabel release];
	[t1PointsLabel release];
	[t2PointsLabel release];
	[infoView release];
	[t1Points release];
	[t2Points release];
	[modelName release];
	[flagNumber release];
	[more_btn release];
	[close_btn release];
	[focusFlag release];
	[hoverView release];
	
	//webView
	[closeW_btn release];
	[webView release];
	[webViewFrame release];
	
	//Timer
	[myTimer release];
	
	//JSON
	[theDelegate release];
	[jsonArray release];
	[jsonUArray release];
	[jsonFArray release];
	
	//Notification
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_HoverView object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_LoginView object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:Show_WebView object:nil];
	
	//Tabbar
	[ uploadButton release]; 
	[ captureButton release];
	[ playerStatus release];
	[ serverButton release];
	
	//Toolbar
	[ reloadButton release];
	[ showModelsButton release];
	[ loginButton release];
	
	
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"The webservice you are accessing is down. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		
		
		
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonData = ms;
	
		
		// converting the json data into an array
		self.jsonArray = [jsonData JSONValue]; 
		
		
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

- (void) loadJSONFData:(NSURL *) jsonURL
{
	
	
	
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	
	
	
	if (jsonData == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webservice Down" message:@"The webservice you are accessing is down. Please try again later."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else {
		NSMutableString *ms = [[NSMutableString alloc] initWithString: jsonData];
		while([ms replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [ms length])] > 0);
		jsonData = ms;
		
		// converting the json data into an array
		self.jsonFArray = [jsonData JSONValue]; 
		
	
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
		button.opaque=YES;
		[button setTag:model_id];
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		//add
		[detailedImageView addSubview:button];
		
		
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
		owner = [[itemAtIndex objectForKey:@"owner"] intValue];
		
		lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
		lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
		
		btn.x=(lng-minBound.x)*imgSize/(maxBound.x-minBound.x);
		btn.y=(lat-minBound.y)*imgSize/(maxBound.y-minBound.y);
		
		CGPoint pos = CGPointMake(btn.x*scale-p.x,btn.y*scale-p.y);
		
		if ( pos.x < 0 ||  pos.y < 0 || pos.x > self.frame.size.width || pos.y > self.frame.size.height )
		{   
			//NSLog(@"no show %s , %f, %f", [name cString], pos.x, pos.y);
			continue;
		}
		
		//NSLog(@"show %s , %f, %f", [name cString], pos.x, pos.y);
		
		UIButton *flagBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
		[flagBtn setFrame:CGRectMake(btn.x-(p.x+16)/scale, btn.y-(p.y+32)/scale, 32/scale, 32/scale)]; 
		if (owner == 1)
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"red_flag.png"] forState:UIControlStateNormal];
		else if (owner == 2)
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"blue_flag.png"] forState:UIControlStateNormal];
		else
			[flagBtn setBackgroundImage:[UIImage imageNamed:@"white_flag.png"] forState:UIControlStateNormal];
		
		//UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark ]; 
		//button.center=CGPointMake(btn.x-p.x/scale, btn.y-p.y/scale);
		flagBtn.opaque=YES;
		[flagBtn setTag:flag_id];
		[flagBtn addTarget:self action:@selector(flagTouched:) forControlEvents:UIControlEventTouchUpInside];
		
		//add
		[detailedImageView addSubview:flagBtn];
		
		
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:92];
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
		
		
		// as we start the fade effect, start the timeout timer for automatically hiding HoverView
		[self buildWebView];
		webViewFrame.alpha = 1.0;
		self.scrollEnabled = NO;
		detailedImageView.userInteractionEnabled = NO;
		[detailedImageView bringSubviewToFront:webViewFrame];
		if ( [self.serverButton isEnabled]==YES )
		{
			
		}
	}
	else
	{
		webViewFrame.alpha = 0.0;
		self.scrollEnabled = YES;
		detailedImageView.userInteractionEnabled = YES;
		self.uploadButton.enabled  = NO;
		self.uploadButton.badgeValue=@"Off";
		self.captureButton.enabled = NO;
		self.captureButton.badgeValue=@"Off";
	}
	
	[UIView commitAnimations];
}


- (void)showLoginView:(BOOL)show
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
		[self buildLoginView];
		loginView.alpha = 1.0;
		myTimer = [[NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
		self.scrollEnabled = NO;
		detailedImageView.userInteractionEnabled = NO;
		[detailedImageView bringSubviewToFront:loginView];
		if ( [self.serverButton isEnabled]==YES )
		{
		
		}
	}
	else
	{
		loginView.alpha = 0.0;
		self.scrollEnabled = YES;
		detailedImageView.userInteractionEnabled = YES;
		self.uploadButton.enabled  = NO;
		self.uploadButton.badgeValue=@"Off";
		self.captureButton.enabled = NO;
		self.captureButton.badgeValue=@"Off";
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
		more_btn.enabled = YES;
		infoView.image=nil;
		[self buildHoverView];
		hoverView.alpha = 1.0;
		myTimer = [[NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
		self.scrollEnabled = NO;
		[detailedImageView bringSubviewToFront:hoverView];
		if ( [self.serverButton isEnabled]==YES && theDelegate.is_login==1 )
		{
			self.uploadButton.enabled  = YES;
			self.uploadButton.badgeValue=@"On";
			self.captureButton.enabled = YES;
			self.captureButton.badgeValue=@"On";
		}
	}
	else
	{
		hoverView.alpha = 0.0;
		self.scrollEnabled = YES;
		if ( check_focusFlag == 1 ) 
		{
			[focusFlag removeFromSuperview];
			check_focusFlag = 0;
		}
		detailedImageView.userInteractionEnabled = YES;
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

- (void)showLoginViewNotif:(NSNotification *)aNotification
{
	// start over - reset the timer
	[myTimer invalidate];
	[myTimer release];
	myTimer = nil;
	
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
	[userID resignFirstResponder];
	[userPSWD resignFirstResponder];
	dispStatus_ind=-1;
	[self showLoginView:0];
	[self showWebView:1];
}

- (IBAction)uploadPic
{
	// user touched the left button in HoverView
	NSLog(@"Left btn");
	[self showHoverView:NO];
	//ImageViewAppDelegate *theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	[theDelegate flipView:1];
	//[theDelegate release];
}

- (IBAction)takePic
{
	// user touched the right button in HoverView
	NSLog(@"Right btn");
	[self showHoverView:NO];
	
	//ImageViewDelegate *appDelegate = (ImageViewDelegate *)[[UIApplication sharedApplication] delegate];
	//ImageViewAppDelegate *theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	[theDelegate flipView:2];
	//[theDelegate release];
	//[self. flipView:YES];
	//[self.superview.window addSubview:viewPickerController.view];
	


}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	//NSLog(@"tabbar");
    NSString *title =  item.title;
	if ( [title isEqualToString:@"Upload Image"] )
	{
		//NSLog(@"%s", title);
		[self uploadPic];
	}
	else if ([title isEqualToString:@"Capture Image"] )
	{
		
		[self takePic];
	}
	else if ( [title isEqualToString:@"Score Board"] )
	{
		
		[self showHoverView:0];
		[self showLoginView:0];
		[self showWebView:1];
	}
	else if ( [title isEqualToString:@"Server Status"] )
	{
	}
	
	
	
}


 
@end
///////////////////////


@implementation GYImageView (ScrollViewDelegate)


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView
{
	if ([self isScrollEnabled])
	{
	if ([imageViewDelegate respondsToSelector:@selector(imageViewWillZoom:)])
		[imageViewDelegate imageViewWillZoom:self];
	
	[detailedImageView removeFromSuperview];
	[detailedImageView release];
	detailedImageView = nil;
	return contentView;
	}
	
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)aScale
{
	
	scale = aScale;
	[self updateDetailedImageView];
	
	if ([imageViewDelegate respondsToSelector:@selector(imageViewDidEndZooming:atScale:)])
		[imageViewDelegate imageViewDidEndZooming:self atScale:scale];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
	if (decelerate)
		return;
	
	[self updateDetailedImageView];
	
	if ([imageViewDelegate respondsToSelector:@selector(imageViewDidScroll:)])
		[imageViewDelegate imageViewDidScroll:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
	[self updateDetailedImageView];
	
	if ([imageViewDelegate respondsToSelector:@selector(imageViewDidScroll:)])
		[imageViewDelegate imageViewDidScroll:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (!scrollView.tracking && !scrollView.dragging && !scrollView.decelerating && !scrollView.zooming)
    {
		[self updateDetailedImageView];
		
		if ([imageViewDelegate respondsToSelector:@selector(imageViewDidScroll:)])
			[imageViewDelegate imageViewDidScroll:self];
    }
}

@end
