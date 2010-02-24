//
//  ListingClient.m
//
//  This client handles listing CRUD.
//
//  Created by P. Mark Anderson on 12/7/09.
//  Copyright 2010 Spot Metrix. All rights reserved.
//

#import "WebcamsTravelClient.h"
#import "SM3DAR.h"
#import "Webcam.h"

// see http://www.webcams.travel/developers/
// webcams.travel developer ID

#define API_KEY @"6edcac77158f8433f2767a4a1b37a01a"
#define API_WEBCAMS_BASE_URL @"http://api.webcams.travel"
#define API_WEBCAMS_ENDPOINT @"/rest"
#define API_METHOD_NEARBY @"wct.webcams.list_nearby"
#define API_PER_PAGE @"10"
#define API_RESPONSE_FORMAT @"xml"

@implementation WebcamsTravelClient

- (void) fetch:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CGFloat)radius unit:(NSString*)unit {
  self.baseURL = API_WEBCAMS_BASE_URL;
  
  NSString *latitudeString = [NSString stringWithFormat:@"%f", latitude];
  NSString *longitudeString = [NSString stringWithFormat:@"%f", longitude];
  NSString *radiusString = [NSString stringWithFormat:@"%f", radius];  

  [self initParameters];
  
  [self.httpParameters setValue:API_METHOD_NEARBY forKey:@"method"];  
  [self.httpParameters setValue:self.apiKey forKey:@"devid"];  
  [self.httpParameters setValue:latitudeString forKey:@"lat"];  
  [self.httpParameters setValue:longitudeString forKey:@"lng"];  
  [self.httpParameters setValue:unit forKey:@"unit"];  
  [self.httpParameters setValue:radiusString forKey:@"radius"];  
  [self.httpParameters setValue:API_PER_PAGE forKey:@"per_page"];  
  [self.httpParameters setValue:@"1" forKey:@"page"];  
  [self.httpParameters setValue:API_RESPONSE_FORMAT forKey:@"format"];  

  [self executeRequest:API_WEBCAMS_ENDPOINT];
}

#pragma mark -
- (void) sendRemoteItems:(id)results {
  if ([results isKindOfClass:[NSDictionary class]]) {
    results = [NSArray arrayWithObject:results];
  }
  
  NSLog(@"[API] Preparing %i items", [results count]);

  Webcam *webcam;
  SM3DAR_PointOfInterest *poi;
  
  // turn results into Listing objects
  NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:[results count]];
  for (NSDictionary *properties in results) {
    //NSLog(@"[API] init webcam with properties: %@", properties);
    webcam = [[Webcam alloc] initWithDictionary:properties];
    poi = [[SM3DAR_Controller sharedSM3DAR_Controller] initPointOfInterest:[webcam pointOfInterestData]];
    [itemArray addObject:poi];
    //[poi release];
  }
  
  [self.resultsDelegate apiClient:self didReceiveRemoteItems:itemArray];
}

- (void) prepareResults:(NSDictionary*)tree {
  if (self.resultsDelegate == nil) {
    return;
  }
  
  NSDictionary *subtree = [tree objectForKey:@"wct_response"];
  if (subtree == nil || [subtree count] == 0) {
    NSLog(@"Error while parsing wct_response from %@", tree);
    return;
  }
  
  subtree = [subtree objectForKey:@"webcams"];
  if (subtree == nil || [subtree count] == 0) {
    NSLog(@"[API] No 'webcams' items:\n%@", tree);
    if (self.resultsDelegate)
      [self.resultsDelegate apiClient:self didReceiveEmptyResultSet:self.httpParameters];  
    return;
  }

  id results = [subtree objectForKey:@"webcam"];
  if (results) {
    [self sendRemoteItems:results];
    return;
  }

  // No results
  [self.resultsDelegate apiClient:self didReceiveEmptyResultSet:self.httpParameters];  
}




@end
