//
//  GameKitXMLServer.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/24/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "GameKitXMLServer.h"

@interface GameKitXMLServer ()

@property(retain, readwrite) GKSession* session;

@end

@implementation GameKitXMLServer

@synthesize session, delegate;

-(id)initWithSessionID:(NSString*) sessionId displayName:(NSString*) name translationScope:(TranslationScope*) trans
{
	if( self = [super init] )
	{
		session = [[GKSession alloc] initWithSessionID:sessionId displayName: name sessionMode: GKSessionModeServer];
		session.delegate = self;
		[session setDataReceiveHandler:self withContext:NULL];
		session.available = YES;
		
		session.disconnectTimeout = 100.0;
		
		translations = trans;
		[translations retain];
		
		allSessionTokensToSessionManagers = [[NSMutableDictionary alloc] initWithCapacity:7];
		activePeerIdsToSessionManagers = [[NSMutableDictionary alloc] initWithCapacity:7];
		
		composer = [[MessageComposer alloc] init];
	}
	return self;
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	NSValue* managerPtr = [activePeerIdsToSessionManagers objectForKey:peer];
	SessionManager* manager = [managerPtr pointerValue];
	[manager receivedNetworkData:data];
}

/* ServerDelegate methods */
- (void) sendMessage:(ServiceMessage*) message withUid:(int) uid toClient:(NSString*) clientId
{
	NSData* msgBfr = [composer composeMessage:message withUID: uid];
	NSArray* peerArray = [NSArray arrayWithObject:clientId];
	
	NSError* err;
	
	if(![session sendData:msgBfr toPeers:peerArray withDataMode:GKSendDataReliable error:&err])
	{
		NSLog(@"Failed to send message to client: %@ because: %@", [err description]);
	}
}

/* GKSessionDelegate methods */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	if(state == GKPeerStateDisconnected)
	{
		NSLog(@"Disconnecting peer: %@", peerID);
		
		NSValue* managerPtr = [activePeerIdsToSessionManagers objectForKey:peerID];
		
		if(managerPtr != nil)
		{
			[delegate sessionDisconnected:[managerPtr pointerValue]];
			[activePeerIdsToSessionManagers removeObjectForKey:peerID];
		}
	}
}

- (void)session:(GKSession *)sess didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	NSError* err;
	if([session acceptConnectionFromPeer:peerID error:&err])
	{
		NSValue* managerPtr;
		
		SessionManager* manager = [[SessionManager alloc] initWithId:peerID parentScope:applicationScope
													translationScope:translations delegate:self];
		
		NSValue* vPtr = [NSValue valueWithPointer:manager];

		[activePeerIdsToSessionManagers setObject:vPtr forKey:peerID];
	}
	else
	{
		NSLog(@"Failed to connect peer: %@ because: %@", peerID, [err description]);
	}
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	NSLog(@"Serious error occurred: %s", [error description]);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
	/* shouldn't be called because we're a server */
	NSLog(@"failed to connect to a peer but we're a server: %@", [error description]);
}

- (BOOL) reestablishSession:(NSString*) sessionToken withManager:(SessionManager*) manager
{
	NSValue* managerPtr;
	if(managerPtr = [allSessionTokensToSessionManagers objectForKey:sessionToken])
	{
		SessionManager* mngr = [managerPtr pointerValue];
		
		if(manager != mngr)
		{
			manager.sessionScope = mngr.sessionScope;
			managerPtr = [NSValue valueWithPointer:manager];
			[allSessionTokensToSessionManagers setObject:managerPtr forKey:sessionToken];
			
			[manager.sessionScope setObject:[NSValue valueWithPointer:manager] forKey:SESSION_MANAGER];
			[mngr release];
		}
		
		return YES;
	}
	else
	{
		return NO;
	}
}

- (void) establishSession:(NSString*) sessionToken withManager:(SessionManager*) manager
{
	NSValue* managerPtr = [NSValue valueWithPointer:manager];
	[allSessionTokensToSessionManagers setObject:managerPtr forKey:sessionToken];
}

- (void) disestablishSession:(SessionManager*) manager
{
	NSString* clientID = manager.clientID;
	NSLog(@"Shutting down session for peerID: %@", clientID);
	
	[activePeerIdsToSessionManagers removeObjectForKey:clientID];
	[allSessionTokensToSessionManagers removeObjectForKey:manager.sessionToken];
	
	[session disconnectPeerFromAllPeers:manager.clientID];
	
	[delegate sessionDisconnected:manager];
	
	[manager autorelease];
}

- (void)dealloc
{
	[session disconnectFromAllPeers];
	session.available = NO;
	[session release];
	
	[activePeerIdsToSessionManagers release];
	activePeerIdsToSessionManagers = nil;
	
	[allSessionTokensToSessionManagers release];
	allSessionTokensToSessionManagers = nil;
	
	[translations release];
	translations = nil;
	
	self.delegate = nil;
	
	[super dealloc];
}
@end
