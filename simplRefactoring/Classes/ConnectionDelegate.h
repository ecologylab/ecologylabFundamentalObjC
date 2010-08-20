#import <Foundation/Foundation.h>

@class Connection;

@protocol ConnectionDelegate

- (void) connectionAttemptFailed:(Connection*)connection;
- (void) connectionTerminated:(Connection*)connection;
- (int) receivedNetworkData:(NSData*)message viaConnection:(Connection*)connection;

@end
