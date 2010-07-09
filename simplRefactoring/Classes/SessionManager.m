//
//  SessionManager.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/25/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "SessionManager.h"

NSString * const SESSION_ID = @"SESSION_ID";
NSString * const SESSION_MANAGER = @"SESSION_MANAGER";

@interface SessionManager ()

@property(retain, readwrite) NSString* clientID;
@property(retain, readwrite) TranslationScope* translations;
@property(retain, readwrite) IncomingMessageProcessor* messageProcessor;
@property(copy, readwrite) NSString* sessionToken;

-(NSString*) generateSessionTokenFromPeerId:(NSString*) peerId;

@end

@implementation SessionManager

@synthesize clientID, sessionScope, translations, messageProcessor, serverDelegate, disconnected, sessionToken;

-(id) initWithId:(NSString*) sessionId parentScope:(Scope*) scope translationScope: (TranslationScope*) trans 
		delegate:(id<ServerDelegate>) delegate
{
	if(self = [super init])
	{
		self.clientID = sessionId;
		sessionScope = [[Scope alloc] initWithParent:scope];
		[sessionScope setObject:sessionId forKey: SESSION_ID];
		[sessionScope setObject:[NSValue valueWithPointer:self] forKey: SESSION_MANAGER];		
		
		messageProcessor = [[IncomingMessageProcessor alloc] init];
		
		disconnected = NO;
		
		self.translations = trans;
		
		self.serverDelegate = delegate; 
	}
	return self;
}

- (void) processMessage:(NSData*) message withUID:(int) uid
{
	/*NSString* messageString = [[NSString alloc] initWithBytes:[message bytes] 
                                                       length:[message length]
													 encoding:NSISOLatin1StringEncoding];*/
	
	ElementState* incomingMessage = [ElementState translateFromXMLData:message translationScope:translations];
	if([incomingMessage isKindOfClass:[RequestMessage class]])
	{
		if([incomingMessage isKindOfClass:[InitConnectionRequest class]])
		{
			InitConnectionRequest* initReq = incomingMessage;
			InitConnectionResponse* resp = [[[InitConnectionResponse alloc] init] autorelease];
			
			if(initReq.sessionId != nil && [initReq.sessionId length] > 0)
			{
				
				/* Sent me a sessionId try to reestablish */
				if([serverDelegate reestablishSession:(initReq.sessionId) withManager:self])
				{
					resp.sessionId = initReq.sessionId;
					self.sessionToken = resp.sessionId;
				}
				else if (sessionToken == nil)
				{
					self.sessionToken = [self generateSessionTokenFromPeerId:clientID];
					resp.sessionId = sessionToken;
					[serverDelegate establishSession:resp.sessionId withManager:self];
				}
				else
				{
					resp.sessionId = sessionToken;
				}
				
				
			}
			else
			{
				if (sessionToken == nil)
				{
					self.sessionToken = [self generateSessionTokenFromPeerId:clientID];
					resp.sessionId = sessionToken;
					[serverDelegate establishSession:resp.sessionId withManager:self];
				}
				else
				{
					resp.sessionId = sessionToken;
				}
				
			}
			
			[self sendMessage:resp withUID:uid];
		}
		else if([incomingMessage isKindOfClass:[DisconnectRequest class]])
		{
			OkResponse* resp = [[[OkResponse alloc] init] autorelease];
			[self sendMessage:resp withUID:uid];
			[serverDelegate disestablishSession:self];
		}
		else
		{
			ResponseMessage* resp = [((RequestMessage*)incomingMessage) PerformService:sessionScope];
			[self sendMessage:resp withUID:uid];
		}
	}
}

-(NSString*) generateSessionTokenFromPeerId:(NSString*) peerId
{
	NSString* sessionConstruction = [NSString stringWithFormat:@"%a-%f", peerId, [NSDate timeIntervalSinceReferenceDate]];
	
	unsigned char hashedChars[33];
	CC_SHA256([sessionConstruction UTF8String],
			  [sessionConstruction lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
			  hashedChars);
	
	hashedChars[32] = 0;
	
	NSString * token = [[NSData dataWithBytes:hashedChars length:32] base64Encoding];
	return token;
}

- (void) receivedNetworkData:(NSData*) incomingData;
{
	/*NSString* messageString = [[NSString alloc] initWithBytes:[incomingData bytes] 
                                                       length:[incomingData length]
													 encoding:NSISOLatin1StringEncoding];
	NSLog(messageString);*/
	
	[messageProcessor receivedNetworkData:incomingData];
	NSData* messageData;
	while (messageData = [messageProcessor getNextMessage])
	{
		[self processMessage:messageData withUID:(messageProcessor.currentUID)];
	}
}

-(void) sendMessageImpl:(ServiceMessage*) message withUID:(NSNumber*) uidValue
{
	int uid = [uidValue intValue];
	[serverDelegate sendMessage:message withUid:uid toClient:clientID];
}

-(void) sendMessage:(ServiceMessage*) message withUID:(int) uid
{
	[self performSelector:@selector(sendMessageImpl:withUID:) withObject:message withObject:[NSNumber numberWithInt:uid]];
}

-(void) dealloc
{
	self.sessionToken = nil;
	
	self.clientID = nil;
	self.sessionScope = nil;
	self.translations = nil;
	self.messageProcessor = nil;
	self.serverDelegate = nil;
	[super dealloc];
}

@end
