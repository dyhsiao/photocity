//
//  EAGLView.m
//  OpenGLES13
//
//  Created by Simon Maurice on 24/05/09.
//  Copyright Simon Maurice 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import "ImageViewAppDelegate.h"
#import "EAGLView.h"
#import "ImageViewViewController.h"

#define USE_DEPTH_BUFFER 1
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,
			   GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy,
			   GLfloat upz);

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end



@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize theDelegate;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
   
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8,
										kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 60.0;
		
        
        
        center[0] = -32.0 + 30;
        center[1] = 0;
        center[2] = -32 + 55;
		
		eye[0] = center[0] + 0.0;
        eye[1] = center[1] + 7;
        eye[2] = center[2] + 4.0;
		
		[self setupView];
		glGenTextures(10, textures);
		[self loadTexture:@"Brickn1.jpg" intoLocation:textures[0]];
		[self loadTexture:@"model.png" intoLocation:textures[1]];
		[self loadTexture:@"red_flag.png" intoLocation:textures[2]];
		[self loadTexture:@"cyan_flag.png" intoLocation:textures[3]];
		[self loadTexture:@"yellow_flag.png" intoLocation:textures[4]];
		[self loadTexture:@"green_flag.png" intoLocation:textures[5]];
		[self loadTexture:@"white_flag.png" intoLocation:textures[6]];
		[self loadTexture:@"focus_flag.png" intoLocation:textures[7]];
		
		
		newLocation[0] = 0;
		newLocation[1] = 0;
		oldLocation[0] = 0;
		oldLocation[1] = 0;
		fingerOnObject = NO;
		drag_ind = 1;
		hoverView_ind = 0;
		
		
    }
    return self;
}

- (void)BuildLists{
	
	//int listID = glGenLists(1);   // start the display list
	
   // glNewList(listID, GL_COMPILE);
	
	
	
}

- (void)drawView {
    [EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
	glMatrixMode(GL_MODELVIEW);
	
	const GLfloat floorVertices[] = {
        -32.0, 32.0, 0.0,     // Top left
        -32.0, -32.0, 0.0,    // Bottom left
        32.0, -32.0, 0.0,     // Bottom right
        32.0, 32.0, 0.0       // Top right
    };
	const GLfloat floorTC[] = {
		0.0, 1.0,
		0.0, 0.0,
		1.0, 0.0,
		1.0, 1.0
	};
	
	const GLfloat flagVertices[] = {
        -1.0, 1.0, 0.0,     // Top left
        -1.0, -1.0, 0.0,    // Bottom left
        1.0, -1.0, 0.0,     // Bottom right
        1.0, 1.0, 0.0       // Top right
    };
	const GLfloat flagTC[] = {
		0.0, 1.0,
		0.0, 0.0,
		1.0, 0.0,
		1.0, 1.0
	};
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	glLoadIdentity();
	
	//[self handleTouches];
	gluLookAt(eye[0], eye[1], eye[2], center[0], center[1], center[2], 0.0, 1.0, 0.0);
	
	//draw the background
	glVertexPointer(3, GL_FLOAT, 0, floorVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, floorTC);
	glBindTexture(GL_TEXTURE_2D, textures[0]);
	glPushMatrix();
	{
		glTranslatef(nowPosition[0], 0.0, nowPosition[1]);
		glTranslatef(newLocation[0], 0.0, newLocation[1]);
		//glTranslatef(10.0+(j*-2.0), -2.0, -2.0+(i*-2.0));
		glRotatef(-90.0, 1.0, 0.0, 0.0);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		
		
		
		//draw model	
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_ALPHA_TEST);
		glAlphaFunc(GL_GEQUAL, 0.5f);
		
		glPushMatrix();
		{
			glVertexPointer(3, GL_FLOAT, 0, flagVertices);
			glEnableClientState(GL_VERTEX_ARRAY);
			glTexCoordPointer(2, GL_FLOAT, 0, flagTC);
			
			
			int ndx, s_ndx;
			NSInteger model_id, flag_id, owner, s_mid, s_fid, s_owner;
			float  lat, lng;
			
			CGPoint btn, s_btn;
			float imgSize = -64;
			float dist = 10000;
			CGPoint maxBound;
			CGPoint minBound;
			maxBound.x=-122.298571;
			maxBound.y=47.652337;
			minBound.x=-122.311885;
			minBound.y=47.661233;
			
			
			
			
			
			for (ndx = 0; ndx < theDelegate.jFArray.count; ndx++) {
				NSDictionary *itemAtIndex = (NSDictionary *)[theDelegate.jFArray objectAtIndex:ndx];
				model_id = [[itemAtIndex objectForKey:@"model_id"] intValue];
				flag_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];
				owner = [[itemAtIndex objectForKey:@"winner"] intValue];
				
				lat = [[itemAtIndex objectForKey:@"lat"] floatValue];
				lng = [[itemAtIndex objectForKey:@"lng"] floatValue];
				
				btn.x=-(lng-minBound.x)*imgSize/(maxBound.x-minBound.x)-32;
				btn.y=(lat-minBound.y)*imgSize/(maxBound.y-minBound.y)+34;
				
				//CGPoint pos = CGPointMake(btn.x*scale-p.x,btn.y*scale-p.y);
				
				if ( !drag_ind && fabs(-btn.x-nowPosition[0]-2.5+9*oldLocation[0]-4.3)<1 && fabs(btn.y-nowPosition[1]+24+12*oldLocation[1]-7.2)<1 )
				{
					float tmp_dist = (btn.x-nowPosition[0])*(btn.x-nowPosition[0]) + (btn.y-nowPosition[1])*(btn.y-nowPosition[1]);
					if (dist > tmp_dist)
					{
			
						glPushMatrix();
						if (s_owner == 1)
						{
							glBindTexture(GL_TEXTURE_2D, textures[2]);
						}
						else if (s_owner == 2)
						{
							glBindTexture(GL_TEXTURE_2D, textures[3]);
						}
						else if (s_owner == 3)
						{
							glBindTexture(GL_TEXTURE_2D, textures[4]);
						}
						else if (s_owner == 4)
						{
							glBindTexture(GL_TEXTURE_2D, textures[5]);
						}
						else
						{
							glBindTexture(GL_TEXTURE_2D, textures[6]);
						}
						glTranslatef(s_btn.x, s_btn.y, 0);
						glRotatef(-120.0, 1.0, 0.0, 0.0);
						glRotatef(180.0, 0.0, 1.0, 0.0);
						glRotatef(180.0, 0.0, 0.0, 1.0);
						glTranslatef(0, 0.0, 1.5);
						glScalef(0.5, 0.5, 0.5);
						glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
						glPopMatrix();
						
						dist = tmp_dist;
						s_btn = btn;
						s_fid = flag_id;
						s_mid = model_id;
						s_owner = owner;
						s_ndx = ndx;
						
						theDelegate.f_id = [[itemAtIndex objectForKey:@"flag_id"] intValue];
						
						
						
						
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
					
						
						if (theDelegate.is_login)
						{
							
							theDelegate.player_points = 0;
							if ([[theDelegate.jUFArray objectForKey:[NSString stringWithFormat:@"%d", s_fid]] intValue]!=nil)
							{
								theDelegate.player_points = [[theDelegate.jUFArray objectForKey:[NSString stringWithFormat:@"%d", s_fid]] intValue];
							}
							
						}
						else //not logged in
						{
							theDelegate.player_points = 0;
						}
						
						
						
						NSString* site = @"http://photocity.cs.washington.edu/";
						itemAtIndex = (NSDictionary *)[theDelegate.jArray objectAtIndex:s_mid-1];
						theDelegate.img_URL = [site stringByAppendingString:[itemAtIndex objectForKey:@"rep_image"]];
						theDelegate.m_name = [itemAtIndex objectForKey:@"name"];	
						
						//if(hoverView_ind==0)
						//{
							//[[NSNotificationCenter defaultCenter] postNotificationName:Show_HoverView object:nil];
						//	hoverView_ind = 1;
						//}			
						
						fingerOnObject = YES;
						
						
						
						continue;
					}
				}
				
		//		 if ( pos.x < 0 ||  pos.y < 0 || pos.x > self.frame.size.width || pos.y > self.frame.size.height )
		//		 {   
		//		 //NSLog(@"no show %s , %f, %f", [name cString], pos.x, pos.y);
		//		 continue;
		//		 }
				
				
				//NSLog(@"show %s , %f, %f", [name cString], pos.x, pos.y);
				
				glPushMatrix();
				if (owner == 1)
				{
					glBindTexture(GL_TEXTURE_2D, textures[2]);
				}
				else if (owner == 2)
				{
					glBindTexture(GL_TEXTURE_2D, textures[3]);
				}
				else if (owner == 3)
				{
					glBindTexture(GL_TEXTURE_2D, textures[4]);
				}
				else if (owner == 4)
				{
					glBindTexture(GL_TEXTURE_2D, textures[5]);
				}
				else
				{
					glBindTexture(GL_TEXTURE_2D, textures[6]);
				}
				glTranslatef(btn.x, btn.y, 0);
				glRotatef(-120.0, 1.0, 0.0, 0.0);
				glRotatef(180.0, 0.0, 1.0, 0.0);
				glRotatef(180.0, 0.0, 0.0, 1.0);
				glTranslatef(0, 0.0, 1.5);
				glScalef(0.5, 0.5, 0.5);
				glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
				glPopMatrix();
			}
			
			
			
			
			glPushMatrix();
			glBindTexture(GL_TEXTURE_2D, textures[7]);
			glTranslatef(s_btn.x, s_btn.y, 0);
			glRotatef(-120.0, 1.0, 0.0, 0.0);
			glRotatef(180.0, 0.0, 1.0, 0.0);
			glRotatef(180.0, 0.0, 0.0, 1.0);
			glTranslatef(0, 0.0, 1.5);
			glScalef(0.5, 0.5, 0.5);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glPopMatrix();
			
				 
			
		}
		glPopMatrix();
	
		glDisable(GL_ALPHA_TEST);
		
		
	}
	glPopMatrix();
		
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	glBindTexture(GL_TEXTURE_2D, textures[7]);
	glTranslatef(0,10, 0);
	glRotatef(-120.0, 1.0, 0.0, 0.0);
	glRotatef(180.0, 0.0, 1.0, 0.0);
	glRotatef(180.0, 0.0, 0.0, 1.0);
	glTranslatef(0, 0.0, 1.5);
	glScalef(0.5, 0.5, 0.5);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glPopMatrix();
	
	if (!theDelegate.updateLoc_ind)
	{
		meBtn.hidden=NO;
		[meBtn setFrame:CGRectMake(theDelegate.lastLocation.x-nowPosition[0], theDelegate.lastLocation.y-nowPosition[1], 50, 50)];
	}
	else
	{
		meBtn.hidden=YES;
	}

	
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)loadTexture:(NSString *)name intoLocation:(GLuint)location {
	
	CGImageRef textureImage = [UIImage imageNamed:name].CGImage;
	if (textureImage == nil) {
        NSLog(@"Failed to load texture image");
		return;
    }
	
    NSInteger texWidth = CGImageGetWidth(textureImage);
    NSInteger texHeight = CGImageGetHeight(textureImage);
	
	
	GLubyte *textureData = (GLubyte *)malloc(texWidth * texHeight * 4);
	
	memset(textureData, 0, texWidth * texHeight * 4);
	
    CGContextRef textureContext = CGBitmapContextCreate(textureData,
														texWidth, texHeight,
														8, texWidth * 4,
														CGImageGetColorSpace(textureImage),
														kCGImageAlphaPremultipliedLast);
	
	// Rotate the image
	CGContextTranslateCTM(textureContext, 0, texHeight);
	CGContextScaleCTM(textureContext, 1.0, -1.0);
	
	CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (float)texWidth, (float)texHeight), textureImage);
	CGContextRelease(textureContext);
	
	glBindTexture(GL_TEXTURE_2D, location);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
	
	free(textureData);
	
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
}

- (void)setupView {
	
	theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	meBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
	[meBtn setBackgroundImage:[UIImage imageNamed:@"me3.png"] forState:UIControlStateNormal];
	[meBtn setFrame:CGRectMake(theDelegate.lastLocation.x, theDelegate.lastLocation.y, 50, 50)];
	[self insertSubview:meBtn atIndex:6];
	
	const GLfloat zNear = 0.1, zFar = 1000.0, fieldOfView = 60.0;
    GLfloat size;
	
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
	
	// This give us the size of the iPhone display
    CGRect rect = self.bounds;
    glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
    glViewport(0, 0, rect.size.width, rect.size.height);
	
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	
	
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView)
														 userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}


	


- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
	[theDelegate release];
	[meBtn release];
    [context release];  
    [super dealloc];
}

#pragma mark Touch Handling

/*
- (void)handleTouches {
    
    if (currentMovement == MTNone) {
        // We're going nowhere, nothing to do here
        return;
    }
    
    GLfloat vector[3];
    
    vector[0] = center[0] - eye[0];
    vector[1] = center[1] - eye[1];
    vector[2] = center[2] - eye[2];
    
    switch (currentMovement) {
        case MTWalkForward:
            eye[0] += vector[0] * WALK_SPEED;
            eye[2] += vector[2] * WALK_SPEED;
            center[0] += vector[0] * WALK_SPEED;
            center[2] += vector[2] * WALK_SPEED;
            break;
            
        case MTWAlkBackward:
            eye[0] -= vector[0] * WALK_SPEED;
            eye[2] -= vector[2] * WALK_SPEED;
            center[0] -= vector[0] * WALK_SPEED;
            center[2] -= vector[2] * WALK_SPEED;
            break;
            
        case MTTurnLeft:
            center[0] = eye[0] + cos(-TURN_SPEED)*vector[0] - sin(-TURN_SPEED)*vector[2];
            center[2] = eye[2] + sin(-TURN_SPEED)*vector[0] + cos(-TURN_SPEED)*vector[2];
            break;
            
        case MTTurnRight:
            center[0] = eye[0] + cos(TURN_SPEED)*vector[0] - sin(TURN_SPEED)*vector[2];
            center[2] = eye[2] + sin(TURN_SPEED)*vector[0] + cos(TURN_SPEED)*vector[2];
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *t = [[touches allObjects] objectAtIndex:0];
	CGPoint touchPos = [t locationInView:t.view];
	
	// Detirmine the location on the screen. We are interested in iPhone Screen co-ordinates only, not the world co-ordinates
	//  because we are just trying to handle movement.
	//
	// (0, 0)
	//	+-----------+
	//  |           |
	//  |    160    |
	//  |-----------| 160
	//  |     |     |
	//  |     |     |
	//  |-----------| 320
	//  |           |
	//  |           |
	//	+-----------+ (320, 480)
	//
	
	if (touchPos.y < 160) {
		// We are moving forward
		currentMovement = MTWalkForward;
		
	} else if (touchPos.y > 320) {
		// We are moving backward
		currentMovement = MTWAlkBackward;
		
	} else if (touchPos.x < 160) {
		// Turn left
		currentMovement = MTTurnLeft;
	} else {
		// Turn Right
		currentMovement = MTTurnRight;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	currentMovement = MTNone;
}

*/

/*
-(CGPoint) getOGLPos:(CGPoint)winPos
{
	// I am doing this once at the beginning when I set the perspective view
	// glGetFloatv( GL_MODELVIEW_MATRIX, __modelview );
	// glGetFloatv( GL_PROJECTION_MATRIX, __projection );
	// glGetIntegerv( GL_VIEWPORT, __viewport );
	
	//opengl 0,0 is at the bottom not at the top
	winPos.y = (float)__viewport[3] - winPos.y;
	// float winZ;
	//we cannot do the following in openGL ES due to tile rendering
	// glReadPixels( (int)winPos.x, (int)winPos.y, 1, 1, GL_DEPTH_COMPONENT24_OES, GL_FLOAT, &winZ );
	
	float cX, cY, cZ, fX, fY, fZ;
	//gives us camera position (near plan)
	gluUnProject( winPos.x, winPos.y, 0, __modelview, __projection, __viewport, &cX, &cY, &cZ);
	//far plane
	gluUnProject( winPos.x, winPos.y, 1, __modelview, __projection, __viewport, &fX, &fY, &fZ);
	
	//We could use some vector3d class, but this will do fine for now
	//ray
	fX -= cX;
	fY -= cY;
	fZ -= cZ;
	float rayLength = sqrtf(cX*cX + cY*cY + cZ*cZ);
	//normalize
	fX /= rayLength;
	fY /= rayLength;
	fZ /= rayLength;
	
	//T = [planeNormal.(pointOnPlane - rayOrigin)]/planeNormal.rayDirection;
	//pointInPlane = rayOrigin + (rayDirection * T);
	
	float dot1, dot2;
	
	float pointInPlaneX = 0;
	float pointInPlaneY = 0;
	float pointInPlaneZ = 0;
	float planeNormalX = 0;
	float planeNormalY = 0;
	float planeNormalZ = -1;
	
	pointInPlaneX -= cX;
	pointInPlaneY -= cY;
	pointInPlaneZ -= cZ;
	
	dot1 = (planeNormalX * pointInPlaneX) + (planeNormalY * pointInPlaneY) + (planeNormalZ * pointInPlaneZ);
	dot2 = (planeNormalX * fX) + (planeNormalY * fY) + (planeNormalZ * fZ);
	
	float t = dot1/dot2;
	
	fX *= t;
	fY *= t;
	//we don't need the z coordinate in my case
	
	return CGPointMake(fX + cX, fY + cY);
} 
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	
	
	UITouch *t = [[touches allObjects] objectAtIndex:0];
	CGPoint touchPos = [t locationInView:t.view];
	
	CGRect bounds = [self bounds];
	
	// This takes our point and makes it into a "percentage" of the screen
	//   That is 0.85 = 85%
    CGPoint p = CGPointMake((touchPos.x - bounds.origin.x) / bounds.size.width,
							(touchPos.y - bounds.origin.y) / bounds.size.height);
	oldLocation[0]=p.x;
	oldLocation[1]=p.y;
	NSLog([NSString stringWithFormat:@"%f, %f",p.x, p.y]);
	newLocation[0]=0;
	newLocation[1]=0;
	/*
    CGRect touchArea = CGRectMake((3.0 * p.y) - 0.1, (2.0 * p.x) - 0.1, 0.2, 0.2);
    if ((newLocation[0] > touchArea.origin.x) && (newLocation[0] < (touchArea.origin.x + touchArea.size.width))) {
        if ((newLocation[1] > touchArea.origin.y) && (newLocation[1] < (touchArea.origin.y + touchArea.size.height))) {
            fingerOnObject = YES;
        }
    }
	 */
	//CGPoint fingerPosition = CGPointMake( nowPosition[0] + p.x , );
	if (fingerOnObject )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:Show_HoverView object:nil];
	}
	drag_ind = 0;
	


}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//if (!fingerOnObject) {
	//	return;
	//}
	
	drag_ind = 1;
	
    UITouch *t = [[touches allObjects] objectAtIndex:0];
    CGPoint touchPos = [t locationInView:t.view];
    
    CGRect bounds = [self bounds];
    
    // This takes our point and makes it into a "percentage" of the screen
    //   That is 0.85 = 85%
    CGPoint p = CGPointMake((touchPos.x - bounds.origin.x) / bounds.size.width,
                            (touchPos.y - bounds.origin.y) / bounds.size.height);
    
    newLocation[1] =  12*(- oldLocation[1] + p.y);
    newLocation[0] = 9*(- oldLocation[0] + p.x);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	fingerOnObject = NO;
	UITouch *t = [[touches allObjects] objectAtIndex:0];
    CGPoint touchPos = [t locationInView:t.view];
    
    CGRect bounds = [self bounds];

	CGPoint p = CGPointMake((touchPos.x - bounds.origin.x) / bounds.size.width,
                            (touchPos.y - bounds.origin.y) / bounds.size.height);
	nowPosition[1] = newLocation[1] + nowPosition[1];
    nowPosition[0] = newLocation[0] + nowPosition[0];
	newLocation[1] = 0;
	newLocation[0] = 0;
}


#pragma mark SGI Copyright Functions

/*
 * SGI FREE SOFTWARE LICENSE B (Version 2.0, Sept. 18, 2008)
 * Copyright (C) 1991-2000 Silicon Graphics, Inc. All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice including the dates of first publication and
 * either this permission notice or a reference to
 * http://oss.sgi.com/projects/FreeB/
 * shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * SILICON GRAPHICS, INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of Silicon Graphics, Inc.
 * shall not be used in advertising or otherwise to promote the sale, use or
 * other dealings in this Software without prior written authorization from
 * Silicon Graphics, Inc.
 */

static void normalize(float v[3])
{
    float r;
	
    r = sqrt( v[0]*v[0] + v[1]*v[1] + v[2]*v[2] );
    if (r == 0.0) return;
	
    v[0] /= r;
    v[1] /= r;
    v[2] /= r;
}

static void __gluMakeIdentityf(GLfloat m[16])
{
    m[0+4*0] = 1; m[0+4*1] = 0; m[0+4*2] = 0; m[0+4*3] = 0;
    m[1+4*0] = 0; m[1+4*1] = 1; m[1+4*2] = 0; m[1+4*3] = 0;
    m[2+4*0] = 0; m[2+4*1] = 0; m[2+4*2] = 1; m[2+4*3] = 0;
    m[3+4*0] = 0; m[3+4*1] = 0; m[3+4*2] = 0; m[3+4*3] = 1;
}

static void cross(float v1[3], float v2[3], float result[3])
{
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,
			   GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy,
			   GLfloat upz)
{
    float forward[3], side[3], up[3];
    GLfloat m[4][4];
	
    forward[0] = centerx - eyex;
    forward[1] = centery - eyey;
    forward[2] = centerz - eyez;
	
    up[0] = upx;
    up[1] = upy;
    up[2] = upz;
	
    normalize(forward);
	
    /* Side = forward x up */
    cross(forward, up, side);
    normalize(side);
	
    /* Recompute up as: up = side x forward */
    cross(side, forward, up);
	
    __gluMakeIdentityf(&m[0][0]);
    m[0][0] = side[0];
    m[1][0] = side[1];
    m[2][0] = side[2];
	
    m[0][1] = up[0];
    m[1][1] = up[1];
    m[2][1] = up[2];
	
    m[0][2] = -forward[0];
    m[1][2] = -forward[1];
    m[2][2] = -forward[2];
	
    glMultMatrixf(&m[0][0]);
    glTranslatef(-eyex, -eyey, -eyez);
}


@end
