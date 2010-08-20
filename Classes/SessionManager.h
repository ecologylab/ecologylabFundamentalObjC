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
extern NSString * const SESSION_MANAGER;


/*!
 @class SessionManager
 @abstract Serves as a handle for sessions on a OODSS server.
 */
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

/*!
 @function intiWithId
 @abstract initializes the SessionManager
 */
-(id) initWithId:(NSString*) sessionId parentScope:(Scope*) scope translationScope: (TranslationScope*) trans 
		delegate:(id<ServerDelegate>) delegate;

/*!
 @function receivedNetworkData
 @abstract call back for indicating the delivery of network data is parsed by translation scope
 */
- (void) receivedNetworkData:(NSData*) incomingData;

/*!
 @abstract Forwards message to the server to sent back to client connected to this client.
 @param message Sevice Message to be sent
 @param uid Uid it is to be sent with.
 */
-(void) sendMessage:(ServiceMessage*) message withUID:(int) uid;

@end
