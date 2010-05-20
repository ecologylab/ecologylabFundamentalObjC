//
//  SessionManager.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/25/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "ServerDelegate.h"
#import "IncomingMessageProcessor.h"
#import "TranslationScope.h"
#import "ServiceMessage.h"
#import "RequestMessage.h"
#import "DisconnectRequest.h"
#import "OkResponse.h"
#import "InitConnectionRequest.h"
#import "InitConnectionResponse.h"
#import "NSDataAdditions.h"

extern NSString * const SESSION_ID;

@interface SessionManager : NSObject {
	NSString* sessionToken;
	NSString* clientID;
	Scope* sessionScope;
	IncomingMessageProcessor* messageProcessor;
	id<ServerDelegate> serverDelegate;
	TranslationScope* translations;
	BOOL disconnected;
}

@property(retain, readonly) NSString* clientID;
@property(retain, readwrite) Scope* sessionScope;
@property(retain, readwrite) id<ServerDelegate> serverDelegate;
@property(assign, readonly) BOOL disconnected;
@property(copy, readonly) NSString* sessionToken;

-(id) initWithId:(NSString*) sessionId parentScope:(Scope*) scope translationScope: (TranslationScope*) trans 
		delegate:(id<ServerDelegate>) delegate;

- (void) receivedNetworkData:(NSData*) incomingData;

-(void) sendMessage:(NSData*) message withUID:(int) uid;

@end
