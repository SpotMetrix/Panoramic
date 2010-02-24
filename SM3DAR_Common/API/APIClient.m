//
//  APIClient.m
//
//  Created by P. Mark Anderson on 1/22/2010.
//

#import "APIClient.h"
#import "UIApplication_TLCommon.h"

@implementation APIClient

@synthesize httpParameters, resultsDelegate, apiKey, baseURL, status;

- (void) dealloc {
  [apiKey release];
  [baseURL release];
  [httpParameters release];
  [resultsDelegate release];
  [super dealloc];
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
	if (self = [super init]) {
    if (dictionary) {
      self.httpParameters = [dictionary mutableCopy];
      self.apiKey = [dictionary valueForKeyPath:@"apiKey"];
      self.baseURL = [dictionary valueForKeyPath:@"baseURL"];
      
      [[self class] setDefaultParams:self.httpParameters];
    }
  }
	return self;
}

- (void) executeRequest:(NSString*)endpoint {
  [[self class] setBaseURL:[NSURL URLWithString:self.baseURL]];
	[[self class] setDelegate:self];

	//tell the REST parser that we're getting back XML, not JSON
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:HRDataFormatXML] forKey:kHRClassAttributesFormatKey];


	NSString *url = [NSString stringWithFormat:@"%@%@", [[self class] baseURL], endpoint];
  NSLog(@"[API] executing request with parameters: %@\n%@", url, self.httpParameters);
  [[self class] setDefaultParams:self.httpParameters];
  //[[self class] printDict:self.httpParameters];
  
  [[UIApplication sharedApplication] didStartNetworkRequest];
//  [[HOTT_Session sharedHOTT_Session] retainClient:self];
	[[self class] getPath:endpoint withOptions:options object:nil];
}

- (void)restConnection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response object:(id)object {
  [[UIApplication sharedApplication] didStopNetworkRequest];
	NSURL *url = [response URL];
	NSString *urlStr = [url absoluteString];
	NSLog(@"[API] Received response (code %i) URL: %@", [response statusCode], urlStr);
	//[[self class] printDict:[response allHeaderFields]];
}

- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource  object:(id)object {
  resource = (NSDictionary*)resource;

  if ([self extractErrors:resource] == 0) 
    [self prepareResults:resource];

//  [[HOTT_Session sharedHOTT_Session] releaseClient:self];
}

- (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)object {
	//Recieved a bad status code 404, 500, etc.
	NSURL *url = [response URL];
	NSString *urlStr = [url absoluteString];
	NSLog(@"[API] Error (code %i) URL: %@", [error code], urlStr);

  NSString *message = [NSString stringWithFormat:@"Sorry, the server is temporarily experiencing technical difficulties (code %i).", [error code]];
  if (self.resultsDelegate)
    [self.resultsDelegate apiClient:self didReceiveErrorMessages:[NSArray arrayWithObject:message]];

//  [[HOTT_Session sharedHOTT_Session] releaseClient:self];
}

- (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error responseBody:(NSString *)string object:(id)object{
//  [HOTT_Session stopActivitySpinner];
	NSLog(@"[API] Parse error (code %i): %@", [error code], error);
	NSLog(@"[API] Response Body: %@", string);

  NSString *message = [NSString stringWithFormat:@"Sorry, the server is temporarily experiencing technical difficulties (format error)."];
  if (self.resultsDelegate)
    [self.resultsDelegate apiClient:self didReceiveErrorMessages:[NSArray arrayWithObject:message]];    
  
// [[HOTT_Session sharedHOTT_Session] releaseClient:self];
}

- (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object {
	NSLog(@"[API] Error getting connection: code: %i", [error code]);	
//  [[HOTT_Session sharedHOTT_Session] releaseClient:self];
}

// Returns number of errors;
- (NSInteger) extractErrors:(NSDictionary*)tree {
  return 0;
}

- (void) prepareResults:(NSDictionary*)tree {
  NSLog(@"[API] prepareResults is meant to be implemented by a subclass.");
}

#pragma mark -
- (void) initParameters {
  self.httpParameters = [NSMutableDictionary dictionary];
}

- (void) addParameters:(NSDictionary*)parameters {
  [self.httpParameters addEntriesFromDictionary:parameters];
}


@end
