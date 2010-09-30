/*!
 @header	 GameKitXMLClient.h
 @abstract Client for communicating with OODSS TCP servers.
 @updated    05/24/10
 @created	 05/10/10
 @author	 William Hamilton
 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ServerDelegate.h"
#import "MessageComposer.h"
#import "IncomingMessageProcessor.h"
#import "XMLClientDelegate.h"
#import "Scope.h"
#import "Client.h"
#import "ServerPicker.h"
#import "ServerPickerDelegate.h"
#import "TranslationScope.h"
#import "UpdateMessage.h"
#import "ResponseMessage.h"
#import "DisconnectRequest.h"
#import "InitConnectionRequest.h"
#import "InitConnectionResponse.h"
#import "OkResponse.h"
#import "HeartBeater.h"

@class ServerPicker;

/*!
 @class GameKitXMLClient
 @abstract Client for communicating with OODSS TCP servers.
 */
@interface GameKitXMLClient : NSObject<Client, GKSessionDelegate, GKPeerPickerControllerDelegate, ServerPickerDelegate> {
	GKSession* session;
	
	NSString* sessionId;
	NSString* displayName;
	NSString* serverId;
	NSString* sessionToken;
	
	int currentUID;
	int disconnectUID;
	int reconnectAttempts;
	
	Scope* applicationScope;
	MessageComposer* composer;
	IncomingMessageProcessor* processor;
	ServerPicker* picker;
	
	id<XMLClientDelegate> delegate;
	
	TranslationScope* translations;
	
	BOOL connected;
	BOOL userDisconnected;
	
	HeartBeater* beater;
}

@property(retain, readwrite) id<XMLClientDelegate> delegate;
@property(retain, readonly) Scope* scope;
@property(assign, readonly) BOOL connected;
@property(retain, readonly) ServerPicker* picker;

/*!
 @function intiWithSessionID
 @abstract Initializes the client
 @discussion Server selection is done through the use of ServerPickerUI.
 @param trans translation scope
 @param del delegate that is informed of connection status
 @param scp application scope
*/
-(id)initWithSessionID:(NSString*) sId 
		   displayName:(NSString*) name 
	  translationScope:(TranslationScope*) trans 
			   delgate:(id<XMLClientDelegate>) del 
			  appScope:(Scope*) scp;

/*!
 @function disconnect
 @abstract disconnects the client from the server
 */
-(void) disconnect;

/*!
 @function reconnect
 @abstract reconnects the client after it's been disconnected
 */
-(void) reconnect;
@end
