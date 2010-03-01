//
//  SphereView.m
//
//  Created by Josh Aller 1/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import "SphereView.h"

@implementation SphereView

- (void) buildView {
  self.hidden = NO;
  
  self.zrot = 0.0;
  
	self.frame = CGRectZero;
  
  if (texture == nil && [textureName length] > 0) {
    NSLog(@"Loading texture named %@", textureName);
    self.textureImage = [UIImage imageNamed:textureName];
    
    // TODO: flip horizontal
    
    self.texture = [[Texture newTextureFromImage:textureImage.CGImage] autorelease];
  }
  
  if (self.textureURL) {
    [self fetchTextureImage:self.textureURL];
  }
  
  [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateTexture) userInfo:nil repeats:NO];
}

- (void) displayGeometry {
  CGFloat scalar = 100.0f;
  glScalef (-scalar, scalar, scalar);
  glRotatef (180, 1, 0, 0);
  
  //[self updateTexture];
  
  glDepthMask(0);
  if (textureImage) {
    [Geometry displaySphereWithTexture:self.texture];
  }  
  glDepthMask(1);
}


@end
