//
//  Model.h
//
//  Created by P. Mark Anderson on 1/22/2010.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject {
  NSMutableDictionary *dictionary;
}

@property (nonatomic, retain) NSMutableDictionary *dictionary;

- (NSString*) getString:(NSString*)key;
- (BOOL) getBoolFromString:(NSString*)value;

@end
