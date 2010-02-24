//
//  Model.m
//
//  Created by P. Mark Anderson on 1/22/2010.
//

#import "Model.h"

@implementation Model

@synthesize dictionary;

- (id)initWithDictionary:(NSDictionary *)otherDictionary {
  if (self = [super init]) {	
    self.dictionary = [otherDictionary mutableCopy];
  }
	return self;
}

- (void) dealloc {
  [dictionary release];
  [super dealloc];
}

- (NSString*) getString:(NSString*)key {
  NSString *value = [self.dictionary objectForKey:key];
  if (![value isKindOfClass:[NSString class]]) {
    return nil;
  }
  // clean up string
  return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
}

// Return NO if given string is empty or "false" (case insensitive)
- (BOOL) getBoolFromString:(NSString*)value {
  if (value == nil || [value isEqualToString:@""] ||[value isEqualToString:@"0"] || [[value lowercaseString] isEqualToString:@"false"] ) {
    return NO;
  } else {
    return YES;
  }
}

@end
