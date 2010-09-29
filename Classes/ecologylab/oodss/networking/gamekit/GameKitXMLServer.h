/*!
 @header	 GameKitXMLServer.h
 @abstract Gamekit OODSS server.
 @updated    05/24/10
 @created	 05/10/10
 @author	 William Hamilton
 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ServerDelegate.h"
#import "MessageComposer.h"
#import "Scope.h"
#import "SessionManager.h"
#import "DisconnectsDelegate.h"

/*!
 @class GameKitXMLServer
 @abstract GameKit OODSS server. Is based on a TCP over Bluetooth Model.
 */
@interface GameKitXMLServer : NSObject<GKSessionDelegate, ServerDelegate> {
	GKSession* session;
	Scope* applicationScope;
	NSMutableDictionary* activePeerIdsToSessionManagers;
	NSMutableDictionary* allSessionTokensToSessionManagers;
	MessageComposer* composer;
	
	TranslationScope* translations;
	id<DisconnectsDelegate> delegate;
}

@property(readwrite, retain) id<DisconnectsDelegate> delegate;

/*!
 @abstract Initializes the server. Server is ready to go after this initializer.
 @param sessionId session id for Gamekit Service
 @param displayName name of the server to advertised over bonjour
 @param trans Translation scope of the 
 @param scope application scope
 */
-(id) initWithSessionID:(NSString*) sessionId 
            displayName:(NSString*) name 
       translationScope:(TranslationScope*) trans 
       applicationScope:(Scope*) scope;

@end
