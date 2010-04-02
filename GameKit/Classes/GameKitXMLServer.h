//
//  GameKitXMLServer.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/24/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ServerDelegate.h"
#import "MessageComposer.h"
#import "Scope.h"
#import "SessionManager.h"

@interface GameKitXMLServer : NSObject<GKSessionDelegate, ServerDelegate> {
	GKSession* session;
	Scope* applicationScope;
	NSMutableDictionary* activePeerIdsToSessionManagers;
	NSMutableDictionary* allSessionTokensToSessionManagers;
	MessageComposer* composer;
	
	TranslationScope* translations;
}

-(id) initWithSessionID:(NSString*) sessionId displayName:(NSString*) name translationScope:(TranslationScope*) trans;

@end
