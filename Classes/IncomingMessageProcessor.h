//
//  IncomingMessageProcessor.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/25/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstants.h"

@interface IncomingMessageProcessor : NSObject {
	NSMutableDictionary* headerMap;
	NSMutableData* incomingMessageBuffer;
	NSMutableData* currentKeyHeaderSequence;
	NSMutableData* currentHeaderSequence;
	NSMutableData* firstMessageBuffer;
	NSString* contentCoding;
	
	int endOfFirstHeader;
	int startReadIndex;
	int contentLengthRemaining;
	int currentUID;
}

@property(assign, readonly) int currentUID;

-(id) init;

- (void) receivedNetworkData:(NSData*) data;
- (NSData*) getNextMessage;

@end
