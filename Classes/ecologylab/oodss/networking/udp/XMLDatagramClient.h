/*!
 @header	 XMLDatagramClient.h
 @abstract Client for communicating with OODSS UDP servers.
 @discussion This class is based on the AsyncUdpSocket open source library.
 @updated    05/24/10
 @created	 05/10/10
 @author	 William Hamilton
 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "DefaultServicesTranslations.h"
#import "XMLClientDelegate.h"
#import "Client.h"


@interface MessageWithMetadata : NSObject {
	RequestMessage* message;
	long uid;
	NSDate* enqueueDate;
	int transmissionCount;
}

@property (readonly, retain) RequestMessage* message;
@property (readonly, assign) long uid;
@property (readwrite, assign) int transmissionCount;
@property (readonly, retain) NSDate* enqueueDate;

-(id) initWithMessage:(RequestMessage*) req uid:(long) u;
-(void) resetDate;
@end

/*!
 @class XMLDatagramClient
 @abstract Client for communicating with OODSS UDP servers.
 @discussion This class is based on the AsyncUdpSocket open source library.
 */
@interface XMLDatagramClient : NSObject<Client> {
	long currentUIDIndex;
	id<XMLClientDelegate> delegate;
	BOOL doCompress;
	NSString* sessionId;
	
	
	TranslationScope* translationScope;
	Scope* scope;
	
	AsyncUdpSocket* socket;	
	NSMutableArray* recieveQueue;
	NSMutableDictionary* uidToMessage;
	MessageWithMetadata* receivePending;
	NSMutableString* messageConstructionString;
	NSTimeInterval timeout;
}

@property(nonatomic, readwrite, retain) id<XMLClientDelegate> delegate;
@property(nonatomic, readonly, copy) NSString* sessionId;
@property(nonatomic, readonly, retain) Scope* scope;
@property(nonatomic, readonly, retain) TranslationScope* translationScope;
@property(nonatomic, readwrite, assign) NSTimeInterval timeout;


/*!
 @abstract Initializes the client. Starts the connection process.
 @discussion This method intitializes the client and uses compression if specified.
 @param host The server's address
 @param port The server's port
 @param transScope The translation scope to be used by the client
 @param compress Whether or not to use compression.
 */
- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope 
			doCompression:(BOOL) compress;

/*!
 @abstract Initializes the client. Starts the connection process.
 @discussion This method intitializes the client and uses compression by default.
 @param host The server's address
 @param port The server's port
 @param transScope The translation scope to be used by the client
 */
- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope;
/*!
 @function sendMessage
 @abstract Sends a request message to the server.
 @discussion This method will retransmit the message an infinite ammount of times.
 @param request The message to send.
*/
- (void) sendMessage:(RequestMessage*) request;

/*!
 @function sendMessage
 @abstract Sends a request message to the server.
 @discussion This method will retransmit the message the number of times specified.
 @param request The message to send.
 @param t number of retransmissions to make
 */
- (void) sendMessage:(RequestMessage*) request withTransmissions:(int) t;

/* AysncUdpSocket Delegate Methods */
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag;

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error;

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port;

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error;

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock;

@end
