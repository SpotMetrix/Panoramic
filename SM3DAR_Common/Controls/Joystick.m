//
//  Joystick.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#define DS_PI 3.14159265359f
#define DS_PI_X_2 6.28318530718f
#define DS_RAD2DEG 180.0f/DS_PI
#define DS_DEG2RAD DS_PI/180.0f

#define THUMB_HIDE_DELAY 3.0f

#import "Joystick.h"
#import "CGPointUtil.h"
#import "SM3DAR.h"

@interface Joystick(hidden)
- (void)updateVelocity:(CGPoint)point;
- (void)resetJoystick;
@end

@implementation Joystick

@synthesize
thumb,
background,
stickPosition,
degrees,
velocity,
autoCenter,
isDPad,
active,
numberOfDirections,
joystickRadius,
thumbRadius,
deadRadius;

- (void) dealloc {
  [thumb release];
  [background release];
	[super dealloc];
}

- (CGPoint) endPoint {
  CGFloat w = self.bounds.size.width;
  CGFloat h = self.bounds.size.height;
  return CGPointMake(-w/2, -h/2);
}

- (CGPoint) centerPoint {
  CGFloat w = self.bounds.size.width;
  CGFloat h = self.bounds.size.height;
  return CGPointMake(w/2, h/2);
}

- (void) updateThumbPosition {
//  NSString *msg = [NSString stringWithFormat:@"joystick: %i, %i", (int)stickPosition.x, (int)stickPosition.y];
//  SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedSM3DAR_Controller];
  //[sm3dar debug:msg];

  thumb.center = self.stickPosition;
}

-(void)updateVelocity:(CGPoint)point {
	// Calculate distance and angle from the center.
	float dx = point.x;
	float dy = point.y;
	float dSq = dx * dx + dy * dy;
  
	if (dSq <= deadRadiusSq) {
    [self resetJoystick];
		return;
	}
  
	float angle = atan2f(dy, dx); // in radians
	if (angle < 0){
		angle	+= DS_PI_X_2;
	}
  
	float cosAngle;
	float sinAngle;
  
	if (isDPad) {
		float anglePerSector = 360.0f / numberOfDirections * DS_DEG2RAD;
		angle = roundf(angle/anglePerSector) * anglePerSector;
	}
  
	cosAngle = cosf(angle);
	sinAngle = sinf(angle);
  
	// NOTE: Velocity goes from -1.0 to 1.0.
	if (dSq > joystickRadiusSq || isDPad) {
		dx = cosAngle * joystickRadius;
		dy = sinAngle * joystickRadius;
	}
  
	velocity = CGPointMake(dx/joystickRadius, dy/joystickRadius);
	degrees = angle * DS_RAD2DEG;
  
	// Update the thumb's position
  CGFloat w = self.bounds.size.width /2;
  CGFloat h = self.bounds.size.height /2;
	stickPosition = CGPointMake(dx+w, dy+h);

//  NSString *msg = [NSString stringWithFormat:@"vel: %f, %f\nstk: %i, %i\ndeg: %i", 
//      velocity.x, velocity.y,
//      (int)dx, (int)dy,
//      (int)degrees];
//  [[SM3DAR_Controller sharedSM3DAR_Controller] debug:msg];
}

- (void) setJoystickRadius:(float)r
{
	joystickRadius = r;
	joystickRadiusSq = r*r;
}

- (void) setThumbRadius:(float)r
{
	thumbRadius = r;
	thumbRadiusSq = r*r;
}

- (void) setDeadRadius:(float)r
{
	deadRadius = r;
	deadRadiusSq = r*r;
}

- (void)resetJoystick {
  //NSLog(@"RESET JOYSTICK TO: %f, %f", self.center.x, self.center.y);  
  degrees = 0.0f;
  velocity = CGPointZero;
  stickPosition = thumb.center = [self centerPoint];
  //[self performSelector:@selector(hideThumb) withObject:nil afterDelay:THUMB_HIDE_DELAY];
}

-(void)setup {
  NSLog(@"setup");
  
  self.backgroundColor = [UIColor clearColor];
  if (!background) {
    self.background = [[UIImageView alloc] initWithImage:@"128_white.png"];
    [self addSubview:background];    
  }

  self.frame = CGRectMake(0, 0, background.image.size.width, background.image.size.height);

 
  if (!isDPad) {
    self.thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"84_white.png"]];
    thumb.backgroundColor = [UIColor clearColor];
    thumb.hidden = NO;
    thumb.center = self.center;
    [self addSubview:thumb];
  }
  
  stickPosition = background.center;
  degrees = 0.0f;
  velocity = CGPointZero;
  self.autoCenter = YES;
  self.isDPad = NO;
  self.numberOfDirections = 4; 
  self.joystickRadius = self.frame.size.width/2;
  self.thumbRadius = joystickRadius / 3;
  self.deadRadius = joystickRadius / 10;
  
  NSLog(@"Joystick radius: %f", joystickRadius);
}

- (id)initWithBackground:(UIImage*)image {  
  NSLog(@"initWithBackground");
	if (self = [super init]) {
    self.background = [[UIImageView alloc] initWithImage:image];
		[self addSubview:background];
    [self setup];    
  }  
  return self;
}

// make 0, 0 be in the middle
- (CGPoint)centeredTouchLocation:(UITouch*)touch {
  CGPoint location = [touch locationInView:self];
  CGPoint difference = [CGPointUtil subtract:location p2:[self centerPoint]];

//  NSString *msg = [NSString stringWithFormat:@"loc: %i, %i\ncnt: %i, %i\npnt: %i, %i", 
//      (int)location.x, (int)location.y,
//      (int)centerPoint.x, (int)centerPoint.y,
//      (int)difference.x, (int)difference.y];
//  [[SM3DAR_Controller sharedSM3DAR_Controller] debug:msg];

  return difference;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [Joystick cancelPreviousPerformRequestsWithTarget:self];
  UITouch *touch = [touches anyObject];
	CGPoint location = [self centeredTouchLocation:touch];

	//Do a fast rect check before doing a circle hit check:
	if(location.x < -joystickRadius || location.x > joystickRadius || location.y < -joystickRadius || location.y > joystickRadius){
		return;

	} else {
    thumb.hidden = NO;
		float dSq = location.x*location.x + location.y*location.y;
		if(joystickRadiusSq > dSq){
			[self updateVelocity:location];
			return;
		}
	}
	return;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  thumb.hidden = NO;
  UITouch *touch = [touches anyObject];
	CGPoint location = [self centeredTouchLocation:touch];
	[self updateVelocity:location];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self resetJoystick];
}

- (void) hideThumb {
  NSLog(@"NOT hiding thumb");
//  thumb.hidden = YES;
}

@end
