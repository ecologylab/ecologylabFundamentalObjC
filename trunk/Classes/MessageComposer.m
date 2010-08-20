//
//  MessageComposer.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/26/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "MessageComposer.h"


@implementation MessageComposer

-(id) init
{
	if(self = [super init])
	{
		headerConstructionString = [[NSMutableString alloc] initWithCapacity:100];
		messageConstructionString = [[NSMutableString alloc] initWithCapacity:(1024*4)];
		outgoingMessageBuffer = [[NSMutableData alloc] initWithCapacity:(1024 *4)];	
	}
	return self;
}

-(NSData*) composeMessage:(ServiceMessage*) request withUID:(int) uid
{
	//clear message construction buffer
	NSRange rangeToDelete;
	rangeToDelete.location = 0;
	rangeToDelete.length = [messageConstructionString length];
	[messageConstructionString deleteCharactersInRange:rangeToDelete];
	
	//translate message
	[request translateToXML:messageConstructionString];
	//get message length before encoding
	int messageLengthWhenEncoded = [messageConstructionString lengthOfBytesUsingEncoding:NSISOLatin1StringEncoding];
	
	// construct header
	rangeToDelete.length = [headerConstructionString length];
	[headerConstructionString deleteCharactersInRange:rangeToDelete];
	[headerConstructionString appendFormat:@"%@:%d%@" , CONTENT_LENGTH_STRING, messageLengthWhenEncoded, HTTP_HEADER_LINE_DELIMETER];
	[headerConstructionString appendFormat:@"%@:%d%@" , UNIQUE_IDENTIFIER_STRING, uid, HTTP_HEADER_TERMINATOR];
	
	//get header length before encoding
	int headerLengthWhenEncoded = [headerConstructionString lengthOfBytesUsingEncoding:NSISOLatin1StringEncoding];
	
	//prep the buffer for filling with the message
	[outgoingMessageBuffer setLength:(messageLengthWhenEncoded + headerLengthWhenEncoded)];
	void* bufferPointer = [outgoingMessageBuffer mutableBytes];
	
	//copy over the header into the buffer
	NSUInteger usedBytes;
	NSRange rangeToCopy = NSMakeRange(0, [headerConstructionString length]);
	[headerConstructionString getBytes:bufferPointer maxLength:headerLengthWhenEncoded
                            usedLength:(&usedBytes) encoding:NSISOLatin1StringEncoding
							   options:NSStringEncodingConversionAllowLossy range:rangeToCopy remainingRange:NULL];
	
	
	//copy over the serializedMessage into the buffer
	rangeToCopy = NSMakeRange(0, [messageConstructionString length]);
	[messageConstructionString getBytes:(bufferPointer + headerLengthWhenEncoded) maxLength:messageLengthWhenEncoded
							 usedLength:(&usedBytes) encoding:NSISOLatin1StringEncoding
								options:NSStringEncodingConversionAllowLossy range:rangeToCopy remainingRange:NULL];
	
	return outgoingMessageBuffer;
}

-(void) dealloc
{
	[headerConstructionString release];
	headerConstructionString = nil;
	
	[messageConstructionString release];
	messageConstructionString = nil;
	
	[outgoingMessageBuffer release];
	outgoingMessageBuffer = nil;
	
	[super dealloc];
	
}

@end
