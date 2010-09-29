//
//  XMLDatagramClient.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/7/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "XMLDatagramClient.h"
#import "NSDataAdditions.h"
#import "NetworkConstants.h"

@implementation MessageWithMetadata

@synthesize message, uid, enqueueDate, transmissionCount;

-(id) initWithMessage:(RequestMessage *)req uid:(long)u
{
	message = [req retain];
	uid = u;
	transmissionCount = -1;
}

-(void) resetDate
{
	[enqueueDate release];
	enqueueDate = [[NSDate alloc] init];
}

-(void) dealloc
{
	[enqueueDate release];
	enqueueDate = nil;
	
	[message release];
	message = nil;
	
	[super dealloc];
}

@end


@interface XMLDatagramClient ()

@property(nonatomic, readwrite, copy) NSString* sessionId;
@property(nonatomic, readwrite, retain) Scope* scope;
@property(nonatomic, readwrite, retain) TranslationScope* translationScope;
@property(nonatomic, readwrite, assign) BOOL doCompress;
@property(nonatomic, readwrite, retain) AsyncUdpSocket* socket;
@property(nonatomic, readwrite, retain) MessageWithMetadata* receivePending;

- (BOOL) processIncomingMessage:(NSData*) message withUID:(long) uid;

- (void) dequeueRecieve;
@end


@implementation XMLDatagramClient

@synthesize sessionId, scope, translationScope, doCompress, socket, receivePending, delegate, timeout;

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope 
			doCompression:(BOOL) compress
{
	if((self = [super init]))
	{
		self.translationScope = transScope;
		scope = [[Scope alloc] init];
		self.doCompress = compress;
		
		NSValue* selfPointerWrapper = [NSValue valueWithPointer: self];
		[scope setObject:selfPointerWrapper forKey:OODSS_CLIENT];
		
		currentUIDIndex = 0;
		uidToMessage = [[NSMutableDictionary alloc] initWithCapacity:10];
		recieveQueue = [[NSMutableArray alloc] initWithCapacity:10];
		receivePending = NO;
		timeout = 5.0;
		
		messageConstructionString = [[NSMutableString alloc] initWithCapacity:(1024*4)];
		
		NSError* err;
		socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
		if(!(socket))
		{
			NSLog(@"Failed to connect to %@ on port: %d", host, port);
			[self autorelease];
			return nil;
		}
		
		if(![socket connectToHost:host onPort:port error:&err])
		{
			NSLog(@"Failed to connect to %@ on port: %d because: %@", host, port, [err localizedDescription]);
			[self autorelease];
			return nil;
		}
		
		InitConnectionRequest* req = [[InitConnectionRequest alloc] init];
		
		[self sendMessage:req];
		
		[req release];
		
	}
	return self;
}

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
{
	return [self initWithHostAddress:host andPort:port andTranslationScope:transScope doCompression:YES];
}

-(void) expectRecieve:(MessageWithMetadata*) msg
{
	[msg resetDate];
	[recieveQueue addObject: msg];
	if(!receivePending)
	{
		[self dequeueRecieve];
	}
}

-(void) dequeueRecieve
{
	if([recieveQueue count] > 0)
	{
		self.receivePending = [recieveQueue objectAtIndex:0];
		[recieveQueue removeObjectAtIndex:0];
		
		[socket receiveWithTimeout:MAX([receivePending.enqueueDate timeIntervalSinceNow] + timeout, 0.0) tag:receivePending.uid];
	}
	else 
	{
		self.receivePending = nil;
	}
}

-(void) transmitMessage:(MessageWithMetadata*) msg
{
	[self expectRecieve:msg];
		
	NSRange rangeToDelete;
	rangeToDelete.location = 0;
	rangeToDelete.length = [messageConstructionString length];
	[messageConstructionString deleteCharactersInRange:rangeToDelete];
	
	//translate message
	[msg.message serialize:messageConstructionString];
	//get message length before encoding
	int messageLengthWhenEncoded = [messageConstructionString lengthOfBytesUsingEncoding:NSISOLatin1StringEncoding];
	
	int totalDatagramLength = messageLengthWhenEncoded + sizeof(signed long long);
	
	NSMutableData* datagramBuffer = [NSMutableData dataWithCapacity:totalDatagramLength + 200];
	[datagramBuffer setLength: totalDatagramLength];
	
	*((signed long long *)[datagramBuffer mutableBytes]) = msg.uid;
	
	void* bufferPointer = [datagramBuffer mutableBytes] + sizeof(signed long long);
	NSUInteger usedBytes;
	NSRange rangeToCopy = NSMakeRange(0, [messageConstructionString length]);
	[messageConstructionString getBytes:(bufferPointer) maxLength:messageLengthWhenEncoded
							 usedLength:(&usedBytes) encoding:NSISOLatin1StringEncoding
								options:NSStringEncodingConversionAllowLossy range:rangeToCopy remainingRange:NULL];
	
	[socket sendData:[datagramBuffer zlibDeflate] withTimeout:5.0 tag:msg.uid];
}

- (void) sendMessage:(RequestMessage*) request
{
	[self sendMessage:request withTransmissions:-1];
}

- (void) sendMessage:(RequestMessage*) request withTransmissions:(int) t
{
	MessageWithMetadata* msg = [[MessageWithMetadata alloc] initWithMessage:request uid:currentUIDIndex++];
	msg.transmissionCount = t-1;
	[uidToMessage setObject:[NSValue valueWithPointer:msg] forKey:[NSNumber numberWithLong:msg.uid]];
	[self transmitMessage:msg];
}

/* AysncUdpSocket Delegate Methods */
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"Failed to send message: %@", [error localizedDescription]);
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
	const void* buf = [data bytes];
		
	NSData* payload;
	
	if(doCompress)
	{
		data = [data zlibInflate];
	}
	
	long uid = *((const signed long long*)[data bytes]);
	
	/* Wrapping subrange into Data, getting warning because bytes is const. Is known and is ok. */
	return [self processIncomingMessage:[NSData dataWithBytesNoCopy:([data bytes] + sizeof(signed long long)) 
															 length:([data length] - sizeof(signed long long)) 
													   freeWhenDone:NO] 
								withUID:uid];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"Failing to read from the socket: %@", [error localizedDescription]);
	if([receivePending transmissionCount] != 0)
	{
		receivePending.transmissionCount--;
		[self performSelector:@selector(transmitMessage:) withObject:receivePending afterDelay:(([error code] == 61)? 5.0: 0)];
		[self dequeueRecieve];
	}
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
	[delegate connectionTerminated:self];
}

- (BOOL) processIncomingMessage:(NSData*) message withUID:(long) uid
{
	/*NSString* messageString = [[NSString alloc] initWithBytes:[message bytes] 
														 length:[message length]
													   encoding:NSISOLatin1StringEncoding];*/
	
	/*NSLog(messageString);*/
	
	ElementState* incomingMessage = [translationScope deserializeData:message];
	[incomingMessage autorelease];
	
	if([incomingMessage isKindOfClass:[ResponseMessage class]])
	{
		ResponseMessage* responseMessage = (ResponseMessage*) incomingMessage;
		
		if([responseMessage isKindOfClass:[InitConnectionResponse class]])
		{
			InitConnectionResponse* initConnResp = (InitConnectionResponse*) incomingMessage;
			
			if(sessionId != nil)
			{
				self.sessionId = initConnResp.sessionId;
				[delegate reconnectSuccessful:self];
			}
			else 
			{
				self.sessionId = initConnResp.sessionId;
				[delegate connectionSuccessful:self withSessionId:self.sessionId];
			}
		}
		
		[responseMessage processResponse: self.scope];
		
		/* setup next recieve */
		
		MessageWithMetadata* msg ;
		
		if((msg = [((NSValue*)[uidToMessage objectForKey:[NSNumber numberWithLong:uid]]) pointerValue]))
		{
			[uidToMessage removeObjectForKey:[NSNumber numberWithLong:uid]];
			[recieveQueue removeObject:msg];
			if(msg == receivePending)
			{
				[self dequeueRecieve];
				[msg release];
				return YES;
			}
			else
			{
				[msg release];
				return NO;
			}

		}
	}
	else if ([incomingMessage isKindOfClass: [UpdateMessage class]])
	{
		UpdateMessage* updateMessage = (UpdateMessage*) incomingMessage;
		
		[updateMessage processUpdate: self.scope];
	}
	else if ([incomingMessage isKindOfClass:[InitConnectionRequest class]])
	{
		InitConnectionRequest* req = [[[InitConnectionRequest alloc] init] autorelease];
		req.sessionId = sessionId;
		[self performSelector:@selector(sendMessage:) withObject:req afterDelay:0];
		
		/* setup next recieve */
		
		MessageWithMetadata* msg ;
		
		if((msg = [((NSValue*)[uidToMessage objectForKey:[NSNumber numberWithLong:uid]]) pointerValue]))
		{
			[recieveQueue removeObject:msg];
						
			if(msg == receivePending)
			{
				[self dequeueRecieve];
				[self performSelector:@selector(transmitMessage:) withObject:msg afterDelay:0];
				return YES;
			}
			else
			{
				[self transmitMessage:msg];
				return NO;
			}
			
		}
	}
}

-(void) dealloc
{
	self.socket = nil;
	self.scope = nil;
	self.translationScope = nil;
	self.sessionId = nil;
	[super dealloc];
}

@end
