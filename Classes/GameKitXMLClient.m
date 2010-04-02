//
//  GameKitXMLClient.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/26/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "GameKitXMLClient.h"


@interface GameKitXMLClient ()

@property(retain, readwrite) Scope* scope;
@property(retain, readwrite) GKSession* session;
@property(assign, readwrite) BOOL connected;

-(void) connect;
-(void) reconnect;
- (void) sendMessageImpl:(ServiceMessage*) message;

@end


@implementation GameKitXMLClient

@synthesize delegate, scope = applicationScope, session, connected;

-(id)initWithSessionID:(NSString*) sId displayName:(NSString*) name 
	  translationScope:(TranslationScope*) trans 
			   delgate:(id<XMLClientDelegate>) del 
			  appScope:(Scope*) scp
{
	if( self = [super init] )
	{
		sessionId = [sId copy];
		sessionToken = nil;
		displayName = [name copy];
		
		beater = [[HeartBeater alloc] initWithClient:self andDelay:5.0];
		
		self.delegate = del;
		
		ServerPicker* picker = [[ServerPicker alloc] initWithSessionId:sessionId displayName:displayName];
		
		translations = trans;
		[translations retain];
		
		composer = [[MessageComposer alloc] init];
		processor = [[IncomingMessageProcessor alloc] init];
		
		currentUID = 0;
		
		self.scope = scp;
		
		[self.scope setObject:[NSValue valueWithPointer:self] forKey:OODSS_CLIENT];
		
		disconnectUID = 0;
		self.connected = NO;
		userDisconnected = NO;
		
		picker.delegate = self;
		[picker show];	
	}
	return self;
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	[self performSelector:@selector(processData:) withObject: data];
}

- (void) processData:(NSData *) data
{
	/*NSString* messageString = [[NSString alloc] initWithBytes:[data bytes] 
                                                       length:[data length]
													 encoding:NSISOLatin1StringEncoding];*/
	
	[processor receivedNetworkData:data];
	
	NSData* message = nil;
	while ( message = [processor getNextMessage])
	{
		/*messageString = [[NSString alloc] initWithBytes:[message bytes] 
												 length:[message length]
											   encoding:NSISOLatin1StringEncoding];*/
		
		ElementState* incomingMessage = [ElementState translateFromXMLData:message translationScope:translations];
		
		if([incomingMessage isKindOfClass:[ResponseMessage class]])
		{
			if([incomingMessage isKindOfClass:[InitConnectionResponse class]])
			{
				InitConnectionResponse* initResp = incomingMessage;
				
				if(sessionToken == nil)
				{
					NSLog(@"Established Session: %@", initResp.sessionId);
					sessionToken = initResp.sessionId;
					self.connected = YES;
					[delegate connectionSuccessful:self withSessionId:sessionToken];
				}
				else if([sessionToken isEqualToString:initResp.sessionId])
				{
					NSLog(@"Restablished session!");
					sessionToken = initResp.sessionId;
					self.connected = YES;
					[delegate reconnectSuccessful:self];
				}
				else
				{
					NSLog(@"Failed to reestablish session!");
					sessionToken = initResp.sessionId;
					self.connected = YES;
					[delegate restablishSessionFailed:self withSessionId:sessionToken];
				}
			}
			
			ResponseMessage* responseMessage = (ResponseMessage*) incomingMessage;
			
			[responseMessage performSelector:@selector(processResponse:) withObject:self.scope];
		}
		else if ([incomingMessage isKindOfClass: [UpdateMessage class]])
		{
			UpdateMessage* updateMessage = (UpdateMessage*) incomingMessage;
			
			[updateMessage performSelector:@selector(processUpdate:) withObject:self.scope];
		}
		
		[incomingMessage release];
	}
}

-(void) disconnect
{
	if(serverId != nil && connected)
	{
		userDisconnected = YES;
		disconnectUID = currentUID;
		[self sendMessageImpl:[[[DisconnectRequest alloc] init] autorelease]];
		
		[session disconnectFromAllPeers];
		session.available = NO;
		self.connected = NO;
	}
}

- (void) sendMessageImpl:(ServiceMessage*) message
{
	if(connected || [message isKindOfClass:[InitConnectionRequest class]])
	{
		NSData* msgBfr = [composer composeMessage:message withUID: currentUID++];
		NSArray* peerArray = [NSArray arrayWithObject:serverId];
		
		NSError* err;
		
		if(![session sendData:msgBfr toPeers:peerArray withDataMode:GKSendDataReliable error:&err])
		{
			NSLog(@"Failed to send message to server because: %@", [err description]);
		}
	}
}

/* ServerDelegate methods */
- (void) sendMessage:(ServiceMessage*) message
{
	[self performSelector:@selector(sendMessageImpl:) withObject: message];
}

/* GKSessionDelegate methods */
- (void)session:(GKSession *)s peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	if(state == GKPeerStateDisconnected && [peerID isEqualToString:serverId] )
	{
		[delegate connectionTerminated:self];
		if(!userDisconnected)
		{
			[session disconnectFromAllPeers];
			[self reconnect];
		}
	}
	if(state == GKPeerStateConnected && [peerID isEqualToString:serverId])
	{
		InitConnectionRequest* req = [[InitConnectionRequest alloc] init];
		req.sessionId = sessionToken;
		
		NSLog(@"Sending InitConnectionRequest");
		
		[self sendMessage:req];
		
		[req release];
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	/* Shouldn't recieve any of these */
	NSLog(@"Why am I, a client, recieving a connection request?");
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	NSLog(@"Serious error occurred: %s", [error description]);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
	if([peerID isEqualToString:serverId])
	{
		NSLog(@"failed to connect to server: %@", [error description]);
		[delegate connectionAttemptFailed:self];
		[self reconnect];
	}
}

-(void) reconnect
{
	NSLog(@"Attempting to reconnect!");
	session.available = YES;

	[self performSelector:@selector(connect) withObject:nil afterDelay:5.0];
}

-(void) connect
{
	NSLog(@"Connecting");
	[session connectToPeer:serverId withTimeout:20.0];
}

-(void) cancelSelected;
{
	[delegate connectionTerminated:self];
}

-(void) pickedServer:(NSString*) srvrId onSession:(GKSession*) s
{
	session = s;
	[session retain];
	
	session.delegate = self;
	[session setDataReceiveHandler:self withContext:NULL];
	
	session.disconnectTimeout = 100.0;
	
	serverId = [srvrId copy];
	
	[self connect];
}

-(void) setConnected:(BOOL) b
{
	connected = b;
	
	if(b)
	{
		[beater start];
	}
	else
	{
		[beater stop];
	}
}

-(void) dealloc
{
	[session disconnectFromAllPeers];
	session.available = NO;
	[session release];
	
	[sessionId release];
	sessionId = nil;
	
	[sessionToken release];
	sessionToken = nil;
	
	[displayName release];
	displayName = nil;
	
	self.delegate = nil;
	
	[processor release];
	processor = nil;
	[composer release];
	composer = nil;
	
	[translations release];
	translations = nil;
	
	[super dealloc];
}

@end
