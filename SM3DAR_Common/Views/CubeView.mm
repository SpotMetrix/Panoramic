//
//  CubeView.m
//
//  Created by P. Mark Anderson 2/23/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import "CubeView.h"

@implementation CubeView

- (void) buildView {
  self.hidden = NO;

  self.zrot = 0.0;
  
	self.frame = CGRectZero;
  
  if (texture == nil && [textureName length] > 0)
  {
    NSLog(@"Loading texture named %@", textureName);
    self.textureImage = [UIImage imageNamed:textureName];
    self.texture = [[Texture newTextureFromImage:textureImage.CGImage] autorelease];
  }

  if (self.textureURL) 
  {
    [self fetchTextureImage:self.textureURL];
  }
}

- (void) displayGeometry {  
  glDepthMask(0);

  if (textureImage) {
    //[Geometry displayCubeWithTexture:self.texture];
  }

  glDepthMask(1);  
}

@end
