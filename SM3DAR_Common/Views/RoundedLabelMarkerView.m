//
//  RoundedLabelMarkerView.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "RoundedLabelMarkerView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation RoundedLabelMarkerView

- (void) buildView {
  NSInteger fontSize = 18;
  UILabel *label = [[UILabel alloc] init];
  label.text = self.poi.title;
  label.font = [UIFont boldSystemFontOfSize:fontSize];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor blackColor];
  
  CGFloat w = [label.text length] * fontSize + (2*fontSize);
	label.frame = self.frame = CGRectMake(0, 0, w, (2*fontSize));
  
  label.textAlignment = UITextAlignmentCenter;
	[self addSubview:label];

  CALayer *l = [self layer];
  [l setMasksToBounds:YES];
  [l setCornerRadius:7.0];
  [l setBorderWidth:2.0];
  [l setBorderColor:[[UIColor whiteColor] CGColor]];
}

- (void) didReceiveFocus {
}

- (void) didLoseFocus {
}

#pragma mark -

- (void) drawInGLContext {  
}

@end
