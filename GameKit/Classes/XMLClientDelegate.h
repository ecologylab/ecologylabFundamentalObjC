

#import <Foundation/Foundation.h>
#import "NetworkConstants.h"
#import "Client.h"

@class XMLClient;

@protocol XMLClientDelegate<NSObject>

- (void) connectionTerminated:(id<Client>)connection;
- (void) connectionAttemptFailed:(id<Client>) connection;
- (void) connectionSuccessful:(id<Client>) connection withSessionId:(NSString*) sessionId;
- (void) reconnectSuccessful:(id<Client>) connection;
- (void) restablishSessionFailed:(id<Client>) connection withSessionId:(NSString*) sessionId;

@end
