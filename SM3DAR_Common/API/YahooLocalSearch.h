//
//  YahooLocalSearch.h
//
//  Created by P. Mark Anderson on 12/18/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooLocalSearch : NSObject {
	NSMutableData *webData;
  NSString *query;
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *query;

- (void)execute:(NSString*)searchQuery;

@end
