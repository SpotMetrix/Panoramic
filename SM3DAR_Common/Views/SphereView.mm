//
//  SphereView.m
//
//  Created by Josh Aller 1/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import "SphereView.h"

@implementation SphereView

- (void) loadWireframe {
  NSLog(@"Loading geometry in sphere.obj");
  NSString* path = [[NSBundle mainBundle] pathForResource:@"sphere" ofType:@"obj"];
  self.geometry = [[Geometry newOBJFromResource:path] autorelease];
  geometry.cullFace = NO;
  self.textureImage = nil;
}

- (void) buildView {
  self.hidden = NO;
  
  self.zrot = 0.0;
  
	self.frame = CGRectZero;

  if (texture == nil && [textureName length] > 0) {
    [self setTextureWithImageNamed:textureName];
    
  } else if (geometry == nil) {
    [self loadWireframe];
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
  
  glDepthMask(0);
  if (textureImage) {
    [Geometry displaySphereWithTexture:texture];

  } else {
    [geometry displayWireframe];
  }  
  glDepthMask(1);
}


@end
