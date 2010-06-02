/*!
 @header	 XMLClient.h
 @abstract Client for communicating with OODSS TCP servers.
 @discussion This class is based on the AsyncUdpSocket open source library.
 @updated    05/24/10
 @created	 05/10/10
 @author	 William Hamilton
 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>
#import "Connection.h"
#import "XMLClientDelegate.h"
#import "NetworkConstants.h"
#import "DefaultServicesTranslations.h"
#import "Scope.h"

/*!
 @class XMLClient
 @abstract Client for communicating with OODSS TCP servers.
 */
@interface XMLClient : NSObject<ConnectionDelegate, Client> {
  id<XMLClientDelegate> delegate;
  Scope* scope;
  Connection* theConnection;
  NSString* sessionId;
  NSMutableDictionary* headerMap;
  NSMutableData* incomingMessageBuffer;
  NSMutableData* currentKeyHeaderSequence;
  NSMutableData* currentHeaderSequence;
  NSMutableData* firstMessageBuffer;
  NSMutableString* headerConstructionString;
  NSMutableString* messageConstructionString;
  NSMutableData* outgoingMessageBuffer;
  NSString* contentCoding;
  
  TranslationScope* translationScope;
  
  int endOfFirstHeader;
  int startReadIndex;
  int contentLengthRemaining;
  int uidOfCurrentMessage;
  int currentUID;
}

@property(nonatomic, readwrite, retain) id<XMLClientDelegate> delegate;
@property(nonatomic, readonly, copy) NSString* sessionId;
@property(nonatomic, readonly, retain) Scope* scope;
@property(nonatomic, readonly, retain) TranslationScope* translationScope;

/*!
 @abstract Initializes the client.
 @discussion This method intitializes the client.
 @param host The server's address
 @param port The server's port
 @param transScope The translation scope to be used by the client
 */
- (id)initWithHostAddress:(NSString*)host andPort:(int) port andTranslationScope:(TranslationScope*) transScope;
- (void) sendMessage:(RequestMessage*) request;

/*!
 @abstract Starts the connection process. 
 @discussion Client will call the delegates connection status call backs based on result of connection process. 
 */
- (void) connect;

@end
