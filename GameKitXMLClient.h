//
//  GameKitXMLClient.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/26/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

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

#import "UpdateMessage.h"
#import "ResponseMessage.h"
#import "DisconnectRequest.h"
#import "InitConnectionRequest.h"
#import "InitConnectionResponse.h"
#import "OkResponse.h"
#import "HeartBeater.h"

@interface GameKitXMLClient : NSObject<Client, GKSessionDelegate, GKPeerPickerControllerDelegate, ServerPickerDelegate> {
	GKSession* session;
	
	NSString* sessionId;
	NSString* displayName;
	NSString* serverId;
	NSString* sessionToken;
	
	int currentUID;
	int disconnectUID;
	
	Scope* applicationScope;
	MessageComposer* composer;
	IncomingMessageProcessor* processor;
	
	id<XMLClientDelegate> delegate;
	
	TranslationScope* translations;
	
	BOOL connected;
	BOOL userDisconnected;
	
	HeartBeater* beater;
}

@property(retain, readwrite) id<XMLClientDelegate> delegate;
@property(retain, readonly) Scope* scope;
@property(assign, readonly) BOOL connected;

-(id)initWithSessionID:(NSString*) sId 
		   displayName:(NSString*) name 
	  translationScope:(TranslationScope*) trans 
			   delgate:(id<XMLClientDelegate>) del 
			  appScope:(Scope*) scp;

-(void) disconnect;

@end
