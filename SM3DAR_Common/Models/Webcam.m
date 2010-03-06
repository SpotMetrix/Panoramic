//
//  Webcam.m
//  NearbyWebcams
//
//  Created by P. Mark Anderson on 1/22/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "Webcam.h"

@implementation Webcam

- (NSDictionary*) pointOfInterestData {
  NSDictionary *poiFields = [NSDictionary dictionaryWithObjectsAndKeys:
          // 3DAR POI attributes
          [self getString:@"latitude"], @"latitude",
          [self getString:@"longitude"], @"longitude",
          [self getString:@"title"], @"title",
          [self getString:@"user"], @"subtitle",
          [self getString:@"url"], @"url",
          @"0", @"altitude", nil];
          
  //NSLog(@"[WEBCAM] poi: %@", poiFields);

  NSMutableDictionary *allFields = [NSMutableDictionary dictionary];
  [allFields addEntriesFromDictionary:self.dictionary];
  [allFields addEntriesFromDictionary:poiFields];
  
  return allFields;
}

@end
