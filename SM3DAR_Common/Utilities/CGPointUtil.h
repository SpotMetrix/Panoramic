//
//  CGPoint_SMCommon.h
//  Panoramic
//
//  Created by P. Mark Anderson on 2/22/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGPointUtil : NSObject {
}

+ (CGPoint) multiply:(CGPoint)p s:(CGFloat)s;
+ (CGPoint) add:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGPoint) subtract:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGFloat) dot:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGFloat) cross:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGPoint) perpendicularClockwise:(CGPoint)p;
+ (CGPoint) perpendicularCounterClockwise:(CGPoint)p;
+ (CGPoint) project:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGPoint) rotate:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGPoint) unrotate:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGFloat) squareLength:(CGPoint)p;
+ (CGFloat) length:(CGPoint)p;
+ (CGFloat) distance:(CGPoint)p1 p2:(CGPoint)p2;
+ (CGPoint) normalize:(CGPoint)p;
+ (CGPoint) forAngle:(CGFloat)a;
+ (CGFloat) toAngle:(CGPoint)p;

@end
