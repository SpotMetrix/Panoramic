//
//  Dpad.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/22/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "Dpad.h"


@implementation Dpad

- (id) init {
	if (self = [super initWithBackground:[UIImage imageNamed:@"DPad_BG.png"]]) {    
		self.thumbRadius = 0.0f;
		self.deadRadius = 0.0f;
		self.isDPad = YES;
		self.numberOfDirections = 8;
	}
	return self;
}

@end
