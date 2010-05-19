//
//  XMLDatagramClient.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/7/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "DefaultServicesTranslations.h"
#import "XMLClientDelegate.h"

@interface MessageWithMetadata : NSObject {
	RequestMessage* message;
	long uid;
	NSDate* enqueueDate;
	int transmissionCount;
}

@property (readonly, retain) RequestMessage* message;
@property (readonly, assign) long uid;
@property (readwrite, assign) int transmissionCount;
@property (readonly, retain) NSDate* enqueueDate;

-(id) initWithMessage:(RequestMessage*) req uid:(long) u;
-(void) resetDate;
@end


@interface XMLDatagramClient : NSObject<Client> {
	long currentUIDIndex;
	id<XMLClientDelegate> delegate;
	BOOL doCompress;
	NSString* sessionId;
	
	
	TranslationScope* translationScope;
	Scope* scope;
	
	AsyncUdpSocket* socket;	
	NSMutableArray* recieveQueue;
	NSMutableDictionary* uidToMessage;
	MessageWithMetadata* receivePending;
	NSMutableString* messageConstructionString;
	NSTimeInterval timeout;
}

@property(nonatomic, readwrite, retain) id<XMLClientDelegate> delegate;
@property(nonatomic, readonly, copy) NSString* sessionId;
@property(nonatomic, readonly, retain) Scope* scope;
@property(nonatomic, readonly, retain) TranslationScope* translationScope;

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope 
			doCompression:(BOOL) compress;
- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope;

- (void) sendMessage:(RequestMessage*) request;
- (void) sendMessage:(RequestMessage*) request withTransmissions:(int) t;

/* AysncUdpSocket Delegate Methods */
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag;

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error;

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port;

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error;

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock;

@end
