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

static const mapSize = 450.0f;
static const GLfloat floorVertices[] = {
-32.0, -32.0, 0.0,     // Top left
-32.0, 32.0, 0.0,    // Bottom left
32.0, 32.0, 0.0,     // Bottom right
32.0, -32.0, 0.0       // Top right
};
static const GLfloat floorTC[] = {
0.0, 0.0,
0.0, 1.0,
1.0, 1.0,
1.0, 0.0
};
static const GLfloat flagVertices[] = {
-0.75, -0.75, 0.0,     // Top left
-0.75, 0.75, 0.0,    // Bottom left
0.75, 0.75, 0.0,     // Bottom right
0.75, -0.75, 0.0       // Top right
};
static const GLfloat flagTC[] = {
0.0, 0.0,
0.0, 1.0,
1.0, 1.0,
1.0, 0.0
};


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
		

		
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawView:) name:Change_Center object:nil];
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	//	float x_ext = 0.25;
	//	float y_ext = 0.15;
		
		//eaglLayer.frame = CGRectMake(-x_ext*320, -y_ext*460, (1+x_ext*2)*320, (1+y_ext*2)*460) ;
				
	//	CATransform3D initialTransform = eaglLayer.sublayerTransform;
	//	initialTransform.m34 = 1.0 / -250;
	//	eaglLayer.sublayerTransform = initialTransform;
	
		
        eaglLayer.opaque = NO;
		float x_ext = 0.25;
		float y_ext = 0.15;
		self.frame=CGRectMake(-x_ext*self.frame.size.width, -y_ext*self.frame.size.height, (1+x_ext*2)*self.frame.size.width, (1+y_ext*2)*self.frame.size.height);
		
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8,
										kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 10.0;
		
        
        //lookat here
        center[0] = mapSize + 20;//577.35+20;//-32.0 + 75.5;
        center[1] = -mapSize - 60;//612;
        center[2] = 0;//577.35+80;//-32 + 90.5;
		
		//eye here
		eye[0] = center[0] + 0.0;
        eye[1] = center[1] - 90.9926*1.08;//*0.85;//234.9232;//81.4;//7*4;//234.9232;
        eye[2] = center[2] + 250.0*1.08;//*0.85;//85.5050;//29.6;//2.5478*4;//85.5050;
		
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
    //glViewport(0, 0, backingWidth, backingHeight);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//	glEnable(GL_TEXTURE_2D);
	
	
	//[self handleTouches];
	gluLookAt(eye[0], eye[1], eye[2], center[0], center[1], center[2], 0.0, 1.0, 0.0);
	
	//draw the background
	//glVertexPointer(3, GL_FLOAT, 0, floorVertices);
	//glTexCoordPointer(2, GL_FLOAT, 0, floorTC);
	//glBindTexture(GL_TEXTURE_2D, textures[0]);
	
	//glDisable(GL_DITHER);
	//glMatrixMode(GL_PROJECTION);
	//glOrthof(0, 320, 0, 480, -1, 1);
	//glMatrixMode(GL_MODELVIEW);
	
	
	
	
	glPushMatrix();
	
	
	//glRotatef(-90.0, 1.0, 0.0, 0.0);

	glScalef((mapSize*2)/(theDelegate.maxLatLon.y-theDelegate.minLatLon.y), (mapSize*2)/(theDelegate.maxLatLon.x-theDelegate.minLatLon.x), 1.0);
	//reverse in y-axis
	glTranslatef(-theDelegate.minLatLon.y, theDelegate.minLatLon.x, 0.0);
	
	
	//glScalef((1154.7)/(theDelegate.maxLatLon.y-theDelegate.minLatLon.y), (1154.7)/(theDelegate.maxLatLon.x-theDelegate.minLatLon.x), 0.0);
	//glTranslatef(theDelegate.minLatLon.y, -theDelegate.minLatLon.x, 1.5);
	//glScalef(64/(theDelegate.maxLatLon.y-theDelegate.minLatLon.y), (-64)/(theDelegate.maxLatLon.x-theDelegate.minLatLon.x), 1.0f);
	//glTranslatef(-theDelegate.minLatLon.y*64/(theDelegate.maxLatLon.y-theDelegate.minLatLon.y), 
	//			 -theDelegate.minLatLon.x*(-64)/(theDelegate.maxLatLon.x-theDelegate.minLatLon.x), 0.0f);
	
//	glRotatef(-120.0, 1.0, 0.0, 0.0);
//	glRotatef(180.0, 0.0, 1.0, 0.0);
//	glRotatef(180.0, 0.0, 0.0, 1.0);
//	glTranslatef(0, 0.0, 1.5);
	
	glVertexPointer(3, GL_FLOAT, 0, flagVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, flagTC);
	glBindTexture(GL_TEXTURE_2D, textures[2]);
	glVertexPointer(3, GL_FLOAT, 0, theDelegate.vertexBuffer_1);
	glDrawArrays(GL_POINTS, 0, theDelegate.vertexCount_1);
	glBindTexture(GL_TEXTURE_2D, textures[3]);
	glVertexPointer(3, GL_FLOAT, 0, theDelegate.vertexBuffer_2);
	glDrawArrays(GL_POINTS, 0, theDelegate.vertexCount_2);
	glBindTexture(GL_TEXTURE_2D, textures[4]);
	glVertexPointer(3, GL_FLOAT, 0, theDelegate.vertexBuffer_3);
	glDrawArrays(GL_POINTS, 0, theDelegate.vertexCount_3);
	glBindTexture(GL_TEXTURE_2D, textures[5]);
	glVertexPointer(3, GL_FLOAT, 0, theDelegate.vertexBuffer_4);
	glDrawArrays(GL_POINTS, 0, theDelegate.vertexCount_4);

	glPopMatrix();
	
	glPushMatrix();
	{
		//glTranslatef(nowPosition[0], 0.0, nowPosition[1]);
	//	newLocation[1] =  12*(- (float)theDelegate.touchStartPoint.y/480.0f + (float)theDelegate.touchMovingPoint.y/480.0f);
	//	newLocation[0] = 9*(- (float)theDelegate.touchStartPoint.x/320.0f + (float)theDelegate.touchMovingPoint.x/320.0f);
	//	glTranslatef(newLocation[0], 0.0, newLocation[1]);
		//glTranslatef(10.0+(j*-2.0), -2.0, -2.0+(i*-2.0));
		//glRotatef(-90.0, 1.0, 0.0, 0.0);
		//glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		
		
		
		//draw model	
		
		
		
		glPushMatrix();
		{
			
			
			
		//	glVertexPointer(3, GL_FLOAT, 0, flagVertices);
		//	glTexCoordPointer(2, GL_FLOAT, 0, flagTC);
			
			
			
			glPushMatrix();
			
			//Render the vertex array
		//	glBindTexture(GL_TEXTURE_2D, textures[2]);
			//glEnableClientState(GL_VERTEX_ARRAY);
			
						
			//glTranslatef(btn.x, btn.y, 0);
			//glRotatef(-120.0, 1.0, 0.0, 0.0);
			//glRotatef(180.0, 0.0, 1.0, 0.0);
			//glRotatef(180.0, 0.0, 0.0, 1.0);
			//glTranslatef(0, 0.0, 1.5);
			//glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glPopMatrix();
			
			CGPoint btn;
			btn.x=-(theDelegate.s_btnLoc.y-theDelegate.minLatLon.y)*(-64)/(theDelegate.maxLatLon.y-theDelegate.minLatLon.y);//-32; lng
			btn.y=(theDelegate.s_btnLoc.x-theDelegate.minLatLon.x)*(-64)/(theDelegate.maxLatLon.x-theDelegate.minLatLon.x);//+34; lat

			glPushMatrix();
			glBindTexture(GL_TEXTURE_2D, textures[7]);
			glTranslatef(btn.x, btn.y, 0);
			glRotatef(-120.0, 1.0, 0.0, 0.0);
			glRotatef(180.0, 0.0, 1.0, 0.0);
			glRotatef(180.0, 0.0, 0.0, 1.0);
			glTranslatef(0, 0.0, 1.5);
			//glScalef(0.5, 0.5, 0.5);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			glPopMatrix();
			
				 
			
		}
		glPopMatrix();
	
	//	glDisable(GL_ALPHA_TEST);
		
		
	}
	glPopMatrix();
		
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	/*
	glBindTexture(GL_TEXTURE_2D, textures[7]);
	glTranslatef(0,10, 0);
	glRotatef(-120.0, 1.0, 0.0, 0.0);
	glRotatef(180.0, 0.0, 1.0, 0.0);
	glRotatef(180.0, 0.0, 0.0, 1.0);
	glTranslatef(0, 0.0, 1.5);
	glScalef(0.5, 0.5, 0.5);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glPopMatrix();
	*/
	
	/*
	if (!theDelegate.updateLoc_ind)
	{
		meBtn.hidden=NO;
		[meBtn setFrame:CGRectMake(theDelegate.lastLocation.x-nowPosition[0], theDelegate.lastLocation.y-nowPosition[1], 50, 50)];
	}
	else
	{
		meBtn.hidden=YES;
	}
	 */

	
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
	
	/*
	NSMutableArray*	recordedPaths;
	
	
	CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;
	
		// Create a texture from an image
		// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
		brushImage = [UIImage imageNamed:@"blue_flag.png"].CGImage;
		
		// Get the width and height of the image
		width = CGImageGetWidth(brushImage);
		height = CGImageGetHeight(brushImage);
		
		// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
		// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
		
		// Make sure the image exists
		if(brushImage) {
			// Allocate  memory needed for the bitmap context
			brushData = (GLubyte *) malloc(width * height * 4);
			// Use  the bitmatp creation function provided by the Core Graphics framework. 
			brushContext = CGBitmapContextCreate(brushData, width, width, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
			// After you create the context, you can draw the  image to the context.
			CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
			// You don't need the context at this point, so you need to release it to avoid memory leaks.
			CGContextRelease(brushContext);
			// Use OpenGL ES to generate a name for the texture.
			glGenTextures(1, &brushTexture);
			// Bind the texture name. 
			glBindTexture(GL_TEXTURE_2D, brushTexture);
			// Specify a 2D texture image, providing the a pointer to the image data in memory
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
			// Release  the image data; it's no longer needed
            free(brushData);		
			// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			
			// Enable use of the texture
			glEnable(GL_TEXTURE_2D);
			// Set a blending function to use
			glBlendFunc(GL_SRC_ALPHA, GL_ONE);
			// Enable blending
			glEnable(GL_BLEND);
		}
	
	glDisable(GL_DITHER);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	*/
	
		
		
	theDelegate = (ImageViewAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	/*
	meBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
	[meBtn setBackgroundImage:[UIImage imageNamed:@"me3.png"] forState:UIControlStateNormal];
	[meBtn setFrame:CGRectMake(theDelegate.lastLocation.x, theDelegate.lastLocation.y, 50, 50)];
	[self insertSubview:meBtn atIndex:6];
	*/
	
	const GLfloat zNear = 1, zFar = 1000.0, fieldOfView = 60.0;
    GLfloat size;
	
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
	
	// This give us the size of the iPhone display
    CGRect rect = self.bounds;
    glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
    glViewport(0, 0, rect.size.width, rect.size.height);
	
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_ALPHA_TEST);
	glAlphaFunc(GL_GEQUAL, 0.5f);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	glPointSize(32);
	
	
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
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:NO];
	
	//[NSThread detachNewThreadSelector:@selector(updaterThread) toTarget:self withObject:nil];

}


- (void)updaterThread {
	while(YES) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[self performSelectorOnMainThread:@selector(drawView) withObject:nil waitUntilDone:NO];
		[NSThread sleepForTimeInterval:0.1];
		[pool release];
	}
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
	//[meBtn release];
    [context release];  
    [super dealloc];
}

/*
#pragma mark -
#pragma mark OpenGL drawing routines

- (void)addNormal:(GLfixed *)newNormal;
{
	[m_normalArray appendBytes:newNormal length:(sizeof(GLfixed) * 3)];	
	//TODO: Check number of normals against vertices
}

- (void)addVertex:(GLfixed *)newVertex;
{
	[m_vertexArray appendBytes:newVertex length:(sizeof(GLfixed) * 3)];
	m_numVertices++;
	totalNumberOfVertices++;
}

- (void)addIndex:(GLushort *)newIndex;
{
	[m_indexArray appendBytes:newIndex length:sizeof(GLushort)];
	m_numIndices++;
}

- (void)addColor:(GLubyte *)newColor;
{
	[m_colorArray appendBytes:newColor length:(sizeof(GLubyte) * 4)];
}


- (void)addAtomToVertexBuffers:(SLSAtomType)atomType atPoint:(SLS3DPoint)newPoint;
{
	GLfixed newVertex[3];
	GLubyte newColor[4];
	GLfloat atomRadius = 0.4f;
	
	// To avoid an overflow due to OpenGL ES's limit to unsigned short values in index buffers, we need to split vertices into multiple buffers
	if (m_numVertices > 65000)
	{
		[self addVertexBuffer];
	}
	GLushort baseToAddToIndices = m_numVertices;
	
	switch (atomType)
	{
		case CARBON:
		{
			newColor[0] = 144;
			newColor[1] = 144;
			newColor[2] = 144;
			newColor[3] = 255;
			atomRadius = 1.70f; // van der Waals radius
		}; break;
		case HYDROGEN:
		{
			newColor[0] = 255;
			newColor[1] = 255;
			newColor[2] = 255;
			newColor[3] = 255;
			atomRadius = 1.09f;
		}; break;
		case OXYGEN:
		{
			newColor[0] = 240;
			newColor[1] = 0;
			newColor[2] = 0;
			newColor[3] = 255;
			atomRadius = 1.52f;
		}; break;
		case NITROGEN:
		{
			newColor[0] = 48;
			newColor[1] = 80;
			newColor[2] = 248;
			newColor[3] = 255;
			atomRadius = 1.55f;
		}; break;
		case SULFUR:
		{
			newColor[0] = 255;
			newColor[1] = 255;
			newColor[2] = 48;
			newColor[3] = 255;
			atomRadius = 1.80f;
		}; break;
		case PHOSPHOROUS:
		{
			newColor[0] = 255;
			newColor[1] = 128;
			newColor[2] = 0;
			newColor[3] = 255;
			atomRadius = 1.80f;
		}; break;
		case IRON:
		{
			newColor[0] = 224;
			newColor[1] = 102;
			newColor[2] = 51;
			newColor[3] = 255;
			atomRadius = 2.00f;
		}
		case SILICON:
		{
			newColor[0] = 240;
			newColor[1] = 200;
			newColor[2] = 160;
			newColor[3] = 255;
			atomRadius = 1.09f;
		}; break;
		default:
		{ // Use green to highlight missing elements in lookup table
			newColor[0] = 0;
			newColor[1] = 255;
			newColor[2] = 0;
			newColor[3] = 255;
			atomRadius = 1.70f;
		}; break;
	}
	
	// Use a smaller radius for the models in the ball-and-stick visualization
	if (currentVisualizationType == BALLANDSTICK)
		atomRadius = 0.4f;
	
	atomRadius *= scaleAdjustmentForX;
	
	int currentCounter;
	for (currentCounter = 0; currentCounter < 12; currentCounter++)
	{
		newVertex[0] = [self floatToFixed:(vdata[currentCounter][0])];
		newVertex[1] = [self floatToFixed:(vdata[currentCounter][1])];
		newVertex[2] = [self floatToFixed:(vdata[currentCounter][2])];
		
		// Add sphere normal
		[self addNormal:newVertex];
		
		// Adjust radius and shift to match center
		newVertex[0] = [self floatToFixed:((vdata[currentCounter][0] * atomRadius) + newPoint.x)];
		newVertex[1] = [self floatToFixed:((vdata[currentCounter][1] * atomRadius) + newPoint.y)];
		newVertex[2] = [self floatToFixed:((vdata[currentCounter][2] * atomRadius) + newPoint.z)];
		
		// Add vertex from table
		[self addVertex:newVertex];
		
		// Add a color corresponding to this vertex
		[self addColor:newColor];
	}
	
	GLushort indexHolder;
	for (currentCounter = 0; currentCounter < 20; currentCounter++)
	{
		int internalCounter;
		totalNumberOfTriangles++;
		for (internalCounter = 0; internalCounter < 3; internalCounter++)
		{
			indexHolder = baseToAddToIndices + tindices[currentCounter][internalCounter];
			[self addIndex:&indexHolder];
		}
	}
	
	//	usleep(1000);
}


- (void)addVertexBuffer;
{
	if (m_vertexArray != nil)
	{
		[m_vertexArray release];
		[m_normalArray release];
		[m_indexArray release];
		[m_colorArray release];
	}
	m_vertexArray = [[NSMutableData alloc] init];
	m_normalArray = [[NSMutableData alloc] init];
	m_indexArray = [[NSMutableData alloc] init];
	m_colorArray = [[NSMutableData alloc] init];
	m_numberOfVertexBuffers++;
	[m_vertexArrays addObject:m_vertexArray];
	[m_normalArrays addObject:m_normalArray];
	[m_indexArrays addObject:m_indexArray];
	[m_colorArrays addObject:m_colorArray];
	m_numVertices = 0;
	m_numIndices = 0;
}

- (BOOL)renderMolecule;
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	isDoneRendering = NO;
	[self performSelectorOnMainThread:@selector(showStatusIndicator) withObject:nil waitUntilDone:NO];
	
	m_vertexArrays = [[NSMutableArray alloc] init];
	m_normalArrays = [[NSMutableArray alloc] init];
	m_indexArrays = [[NSMutableArray alloc] init];
	m_colorArrays = [[NSMutableArray alloc] init];
	
	m_numberOfVertexBuffers = 0;
	[self addVertexBuffer];
	
	currentFeatureBeingRendered = 0;
	
	switch(currentVisualizationType)
	{
		case BALLANDSTICK:
		{
			totalNumberOfFeaturesToRender = numberOfAtoms + numberOfBonds;
			
			[self readAndRenderAtoms];
			[self readAndRenderBonds];
		}; break;
		case SPACEFILLING:
		{
			totalNumberOfFeaturesToRender = numberOfAtoms;
			[self readAndRenderAtoms];
		}; break;
		case CYLINDRICAL:
		{
			totalNumberOfFeaturesToRender = numberOfBonds;
			[self readAndRenderBonds];
		}; break;
	}
	
	if (!isRenderingCancelled)
	{
		[self performSelectorOnMainThread:@selector(bindVertexBuffersForMolecule) withObject:nil waitUntilDone:YES];
		
	}
	else
	{
		m_numberOfVertexBuffers = 0;
		
		isBeingDisplayed = NO;
		isRenderingCancelled = NO;
		
		// Release all the NSData arrays that were partially generated
		[m_indexArray release];	
		m_indexArray = nil;
		[m_indexArrays release];
		
		[m_vertexArray release];
		m_vertexArray = nil;
		[m_vertexArrays release];	
		
		[m_normalArray release];			
		m_normalArray = nil;
		[m_normalArrays release];			
		
		[m_colorArray release];			
		m_colorArray = nil;
		[m_colorArrays release];					
	}
	
	
	isDoneRendering = YES;
	[self performSelectorOnMainThread:@selector(hideStatusIndicator) withObject:nil waitUntilDone:NO];
	
	[pool release];
	return YES;
}

- (void)bindVertexBuffersForMolecule;
{
	m_vertexBufferHandle = (GLuint *) malloc(sizeof(GLuint) * m_numberOfVertexBuffers);
	m_normalBufferHandle = (GLuint *) malloc(sizeof(GLuint) * m_numberOfVertexBuffers);
	m_indexBufferHandle = (GLuint *) malloc(sizeof(GLuint) * m_numberOfVertexBuffers);
	m_colorBufferHandle = (GLuint *) malloc(sizeof(GLuint) * m_numberOfVertexBuffers);
	m_numberOfIndicesForBuffers = (unsigned int *) malloc(sizeof(unsigned int) * m_numberOfVertexBuffers);
	
	unsigned int bufferIndex;
	for (bufferIndex = 0; bufferIndex < m_numberOfVertexBuffers; bufferIndex++)
	{
		glGenBuffers(1, &m_indexBufferHandle[bufferIndex]); 
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBufferHandle[bufferIndex]);   
		
		NSData *currentIndexBuffer = [m_indexArrays objectAtIndex:bufferIndex];
		GLushort *indexBuffer = (GLushort *)[currentIndexBuffer bytes];
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, [currentIndexBuffer length], indexBuffer, GL_STATIC_DRAW);     
		m_numberOfIndicesForBuffers[bufferIndex] = ([currentIndexBuffer length] / sizeof(GLushort));
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); // Is this necessary?
	}	
	// Now that the data is in the OpenGL buffer, can release the NSData
    [m_indexArray release];	
	m_indexArray = nil;
	[m_indexArrays release];
	
	for (bufferIndex = 0; bufferIndex < m_numberOfVertexBuffers; bufferIndex++)
	{	
		glGenBuffers(1, &m_vertexBufferHandle[bufferIndex]); 
		glBindBuffer(GL_ARRAY_BUFFER, m_vertexBufferHandle[bufferIndex]); 
		
		NSData *currentVertexBuffer = [m_vertexArrays objectAtIndex:bufferIndex];
		GLfixed *vertexBuffer = (GLfixed *)[currentVertexBuffer bytes];
		glBufferData(GL_ARRAY_BUFFER, [currentVertexBuffer length], vertexBuffer, GL_STATIC_DRAW); 
		glBindBuffer(GL_ARRAY_BUFFER, 0); 
	}
	[m_vertexArray release];
	m_vertexArray = nil;
	[m_vertexArrays release];	
	
	for (bufferIndex = 0; bufferIndex < m_numberOfVertexBuffers; bufferIndex++)
	{	
		glGenBuffers(1, &m_normalBufferHandle[bufferIndex]); 
		glBindBuffer(GL_ARRAY_BUFFER, m_normalBufferHandle[bufferIndex]); 
		
		NSData *currentNormalBuffer = [m_normalArrays objectAtIndex:bufferIndex];
		GLfixed *normalBuffer = (GLfixed *)[currentNormalBuffer bytes];
		glBufferData(GL_ARRAY_BUFFER, [currentNormalBuffer length], normalBuffer, GL_STATIC_DRAW); 
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}	
    [m_normalArray release];			
	m_normalArray = nil;
    [m_normalArrays release];			
	
	for (bufferIndex = 0; bufferIndex < m_numberOfVertexBuffers; bufferIndex++)
	{	
		glGenBuffers(1, &m_colorBufferHandle[bufferIndex]); 
		glBindBuffer(GL_ARRAY_BUFFER, m_colorBufferHandle[bufferIndex]); 
		
		NSData *currentColorBuffer = [m_colorArrays objectAtIndex:bufferIndex];
		GLubyte *colorBuffer = (GLubyte *)[currentColorBuffer bytes];
		glBufferData(GL_ARRAY_BUFFER, [currentColorBuffer length], colorBuffer, GL_STATIC_DRAW); 
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}	
    [m_colorArray release];			
	m_colorArray = nil;
    [m_colorArrays release];			
	
}

- (void)drawMolecule;
{
	glEnableClientState (GL_VERTEX_ARRAY);
	glEnableClientState (GL_NORMAL_ARRAY);
	glEnableClientState (GL_COLOR_ARRAY);
	
	unsigned int bufferIndex;
	for (bufferIndex = 0; bufferIndex < m_numberOfVertexBuffers; bufferIndex++)
	{
		// Bind the buffers
		glBindBuffer(GL_ARRAY_BUFFER, m_vertexBufferHandle[bufferIndex]); 
		glVertexPointer(3, GL_FIXED, 0, NULL); 
		
		glBindBuffer(GL_ARRAY_BUFFER, m_normalBufferHandle[bufferIndex]); 
		glNormalPointer(GL_FIXED, 0, NULL); 
		
		glBindBuffer(GL_ARRAY_BUFFER, m_colorBufferHandle[bufferIndex]); 
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, NULL);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexBufferHandle[bufferIndex]);    
		
		// Do the actual drawing to the screen
		glDrawElements(GL_TRIANGLES,m_numberOfIndicesForBuffers[bufferIndex],GL_UNSIGNED_SHORT, NULL);
		
		// Unbind the buffers
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); 
		glBindBuffer(GL_ARRAY_BUFFER, 0); 
	}
	
	
	glDisableClientState (GL_COLOR_ARRAY);	
	glDisableClientState (GL_VERTEX_ARRAY);
	glDisableClientState (GL_NORMAL_ARRAY);	
}

- (void)freeVertexBuffers;
{
	if (isRenderingCancelled)
		return;
	unsigned int bufferIndex;
	for (bufferIndex = 0; bufferIndex < m_numberOfVertexBuffers; bufferIndex++)
	{
		glDeleteBuffers(1, &m_indexBufferHandle[bufferIndex]);
		glDeleteBuffers(1, &m_vertexBufferHandle[bufferIndex]);
		glDeleteBuffers(1, &m_normalBufferHandle[bufferIndex]);
		glDeleteBuffers(1, &m_colorBufferHandle[bufferIndex]);
	}
	
	
	if (m_vertexBufferHandle != NULL)
		free(m_vertexBufferHandle);
	if (m_normalBufferHandle != NULL)
		free(m_normalBufferHandle);
	if (m_indexBufferHandle != NULL)
		free(m_indexBufferHandle);
	if (m_colorBufferHandle != NULL)
		free(m_colorBufferHandle);
	if (m_numberOfIndicesForBuffers != NULL)
		free(m_numberOfIndicesForBuffers);
	
	totalNumberOfTriangles = 0;
	totalNumberOfVertices = 0;
}

*/


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
/*
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
	
//    CGRect touchArea = CGRectMake((3.0 * p.y) - 0.1, (2.0 * p.x) - 0.1, 0.2, 0.2);
//    if ((newLocation[0] > touchArea.origin.x) && (newLocation[0] < (touchArea.origin.x + touchArea.size.width))) {
//        if ((newLocation[1] > touchArea.origin.y) && (newLocation[1] < (touchArea.origin.y + touchArea.size.height))) {
//            fingerOnObject = YES;
//        }
//    }
	 
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

*/
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
