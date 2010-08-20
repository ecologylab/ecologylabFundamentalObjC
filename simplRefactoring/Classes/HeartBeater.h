/*!
 @header	 HeartBeater.h
 @abstract   Class that sends "heart beats" at regular interval on a client. Used for keeping connection alive.
 @created 04/1/10
 @author William Hamilton
 @copyright Interface Ecology Lab
 */

#import <Foundation/Foundation.h>
#import "Ping.h"
#import "Client.h"
/*!
 @class HeartBeater
 @abstract Class that sends "heart beats" at regular interval on a client.
 @discussion Used for keeping connection alive.
 */
@interface HeartBeater : NSObject {
	BOOL started;
	Ping* cachedPing;
	id<Client> client;
	double delay;
}

@property(readwrite, retain) id<Client> client;

-(id) initWithClient:(id<Client>) c andDelay:(double) d;
-(void) start;
-(void) stop;
@end
