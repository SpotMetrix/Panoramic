//
//  APIClient.h
//
//  Created by Chad Berkley on 12/18/09.
//

#import <Foundation/Foundation.h>
#import "HTTPRiot.h"

@protocol APIClientDelegate;

typedef enum {
  READY,
  FETCHING
} OperationStatus;

@interface APIClient : HRRestModel <HRResponseDelegate> {
  NSObject<APIClientDelegate> *resultsDelegate;
  NSMutableDictionary *httpParameters;
	NSString *apiKey;
  NSString *baseURL;
  OperationStatus status;
}

@property (nonatomic, retain) NSObject<APIClientDelegate> *resultsDelegate;
@property (nonatomic, retain) NSMutableDictionary *httpParameters;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, assign) OperationStatus status;

- (id) initWithDictionary:(NSDictionary*)dictionary;
- (void) initParameters;
- (void) prepareResults:(NSDictionary*)tree;
- (void) executeRequest:(NSString*)endpoint;
- (NSInteger) extractErrors:(NSDictionary*)tree;
- (void) addParameters:(NSDictionary*)parameters;

@end

@protocol APIClientDelegate
- (void) apiClient:(APIClient*)client didReceiveErrorMessages:(NSArray*)messages;
- (void) apiClient:(APIClient*)client didReceiveEmptyResultSet:(NSDictionary*)parameters;
- (void) apiClient:(APIClient*)client didReceiveRemoteItems:(NSArray*)results;
@end


