//
//  Joystick.h
//  Panoramic
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Joystick : UIView {
	UIImageView *thumb;
	UIImageView *background;

	CGPoint stickPosition;
	float degrees;
	CGPoint velocity;
	BOOL autoCenter;
	BOOL isDPad;
	BOOL active;
	NSUInteger numberOfDirections; //Used only when isDpad == YES
 
	float joystickRadius;
	float thumbRadius;
	float deadRadius; //If the stick isn't moved enough then just don't apply any velocity
 
	//Optimizations (keep Squared values of all radii for faster calculations) (updated internally when changing joy/thumb radii)
	float joystickRadiusSq;
	float thumbRadiusSq;
	float deadRadiusSq;
}

@property (nonatomic, retain) UIImageView *thumb;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, readonly) CGPoint stickPosition;
@property (nonatomic, readonly) float degrees;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, assign) BOOL autoCenter;
@property (nonatomic, assign) BOOL isDPad;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) NSUInteger numberOfDirections;
 
@property (nonatomic, assign) float joystickRadius;
@property (nonatomic, assign) float thumbRadius;
@property (nonatomic, assign) float deadRadius;

- (id)initWithBackground:(UIImage*)image;
- (void) updateThumbPosition;

@end
