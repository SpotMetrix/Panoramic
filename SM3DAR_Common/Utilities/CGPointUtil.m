//
//  CGPoint_SMCommon.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/22/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "CGPointUtil.h"


@implementation CGPointUtil

+ (CGPoint) multiply:(CGPoint)p s:(CGFloat)s {
  return CGPointMake(p.x*s, p.y*s);
}

+ (CGPoint) add:(CGPoint)p1 p2:(CGPoint)p2 {
  return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

+ (CGPoint) subtract:(CGPoint)p1 p2:(CGPoint)p2 {
  return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

+ (CGFloat) dot:(CGPoint)p1 p2:(CGPoint)p2 {
  return p1.x*p2.x + p1.y*p2.y;
}

+ (CGFloat) cross:(CGPoint)p1 p2:(CGPoint)p2 {
  return p1.x*p2.x - p1.y*p2.y;
}

+ (CGPoint) perpendicularClockwise:(CGPoint)p {
  return CGPointMake(-p.y, p.x);
}

+ (CGPoint) perpendicularCounterClockwise:(CGPoint)p {
  return CGPointMake(p.y, -p.x);
}

+ (CGPoint) project:(CGPoint)p1 p2:(CGPoint)p2 {
  CGFloat dot1 = [CGPointUtil dot:p1 p2:p2];
  CGFloat dot2 = [CGPointUtil dot:p2 p2:p2];
  return [CGPointUtil multiply:p2 s:(dot1/dot2)];
}

+ (CGPoint) rotate:(CGPoint)p1 p2:(CGPoint)p2 {
  return CGPointMake(p1.x*p2.x - p1.y*p2.y, p1.x*p2.y + p1.y*p2.x);
}

+ (CGPoint) unrotate:(CGPoint)p1 p2:(CGPoint)p2 {
  return CGPointMake(p1.x*p2.x + p1.y*p2.y, p1.y*p2.x - p1.x*p2.y);
}

+ (CGFloat) squareLength:(CGPoint)p {
  return [CGPointUtil dot:p p2:p];
}

/** Calculates distance between point an origin
 @return CGFloat
 */
+ (CGFloat) length:(CGPoint)p {
  return sqrtf([CGPointUtil squareLength:p]);
}

/** Calculates the distance between two points
 @return CGFloat
 */
+ (CGFloat) distance:(CGPoint)p1 p2:(CGPoint)p2 {
  CGPoint difference = [CGPointUtil subtract:p1 p2:p2];
  return [CGPointUtil length:difference];
}

/** Returns point multiplied to a length of 1.
 @return CGPoint
 */
+ (CGPoint) normalize:(CGPoint)p {
  CGFloat l = [CGPointUtil length:p];
  return [CGPointUtil multiply:p s:(1.0f/l)];
}

/** Converts radians to a normalized vector.
 @return CGPoint
 */
+ (CGPoint) forAngle:(CGFloat)a {
  return CGPointMake(cosf(a), sinf(a));
}

/** Converts a vector to radians.
 @return CGFloat
 */
+ (CGFloat) toAngle:(CGPoint)p {
  return atan2f(p.y, p.x);
}

@end
