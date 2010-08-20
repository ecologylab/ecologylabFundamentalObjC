//
//  IncomingMessageProcessor.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/25/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "IncomingMessageProcessor.h"

@interface IncomingMessageProcessor ()

- (int) parseHeaderAtIndex:(int) startIndex andBuffer:(NSData*) buffer;
- (void) clean;
@end

@implementation IncomingMessageProcessor

@synthesize currentUID;

-(id) init
{
	if( self = [super init])
	{
		headerMap = [[NSMutableDictionary alloc] init];
		incomingMessageBuffer = [[NSMutableData alloc] init];
		currentKeyHeaderSequence = [[NSMutableData alloc] initWithCapacity:200];
		currentHeaderSequence = [[NSMutableData alloc] initWithCapacity: 200];
		firstMessageBuffer = [[NSMutableData alloc] initWithCapacity:(1024 * 4)];
		[self clean];
	}
	return self;
}
- (void) receivedNetworkData:(NSData*) incomingData
{
	[incomingMessageBuffer appendBytes:[incomingData bytes] length:[incomingData length]];
}

- (NSData*) getNextMessage
{
	if(endOfFirstHeader == -1)
    {
		endOfFirstHeader = [self parseHeaderAtIndex:startReadIndex andBuffer: incomingMessageBuffer];
    }
    if(endOfFirstHeader == -1)
    {
		/* no header yet, might check for too large at some point */
		startReadIndex = [incomingMessageBuffer length];
		return nil;
    }
    else
    {
		/*
		 we've read all of the header and have it loaded into the
		 dictionary; now we can use it
		 */
		if(contentLengthRemaining == -1)
		{
			contentLengthRemaining = [((NSString*) [headerMap objectForKey:CONTENT_LENGTH_STRING]) integerValue];
			if(contentLengthRemaining == 0)
			{
				/* This is really bad not sure how to do error handling just yet.*/
			}
			
			currentUID = [((NSString*) [headerMap objectForKey:UNIQUE_IDENTIFIER_STRING]) integerValue];
			if(contentLengthRemaining == 0)
			{
				/* This is really bad not sure how to do error handling just yet.*/
			}
			
			[contentCoding release];
			contentCoding = ((NSString*) [headerMap objectForKey:HTTP_CONTENT_CODING]);
			NSRange rangeToDelete;
			rangeToDelete.location = 0;
			rangeToDelete.length = endOfFirstHeader;
			
			[incomingMessageBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];
			[headerMap removeAllObjects];
			startReadIndex = 0;
		}
    }
    
    /*
     *We have the end of the first header (otherwise we would have
     *broken out earlier). If we don't have the content length,
     *something bad happended, because it should have been read.
     */
    if(contentLengthRemaining == -1)
    {
		/*
		 * if we still don't have the remaining length, then there was a prob
		 */
		return nil;
    }
	
    // see if buffer has enough characters to
    // include the specified content length
    if([incomingMessageBuffer length] >= contentLengthRemaining)
    {
		[firstMessageBuffer appendBytes:[incomingMessageBuffer mutableBytes] length:contentLengthRemaining];
		
		NSRange rangeToDelete;
		rangeToDelete.location = 0;
		rangeToDelete.length = contentLengthRemaining;
		[incomingMessageBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];
		
		contentLengthRemaining = -1;
		endOfFirstHeader = -1;
    }
    else
    {
		[firstMessageBuffer appendBytes:[incomingMessageBuffer mutableBytes] length:[incomingMessageBuffer length]];
		//need to get more from buffer in next itteration
		contentLengthRemaining -= [incomingMessageBuffer length];
		[incomingMessageBuffer setLength:0];
    }
    
    if([firstMessageBuffer length] > 0 && contentLengthRemaining == -1)
    {
		//we've got an incoming message (Response)
		NSData* messageCopy = [[firstMessageBuffer copyWithZone:NULL] autorelease];
		[firstMessageBuffer setLength:0];
		return messageCopy;
    }
	return nil;
}

- (int) parseHeaderAtIndex:(int) startIndex andBuffer:(NSData*) buffer
{
	char currentChar = 0;
	const char* bytes = [buffer bytes];
	bool maybeEndSequence = FALSE;
    
	for(int i = 0; i < [buffer length]; i++)
	{
		currentChar = bytes[i];
		switch(currentChar)
		{
			case ':':
				[currentKeyHeaderSequence appendBytes:[currentHeaderSequence mutableBytes] length:[currentHeaderSequence length]];
				[currentHeaderSequence setLength:0];
				break;
			case '\r':
				if(bytes[i+1] == '\n')
				{
					if(!maybeEndSequence)
					{
						/*encode key and value into NSStrings and put them in the headerMap*/
						NSString* currentSequenceString = [[NSString alloc] initWithBytes:[currentHeaderSequence mutableBytes] 
																				   length:[currentHeaderSequence length] encoding: NSISOLatin1StringEncoding];
						NSString* currentKeySequenceString = [[NSString alloc] initWithBytes:[currentKeyHeaderSequence mutableBytes]
																					  length:[currentKeyHeaderSequence length] encoding: NSISOLatin1StringEncoding];
						[headerMap setObject: currentSequenceString forKey:currentKeySequenceString];
						
						[currentHeaderSequence setLength:0];
						[currentKeyHeaderSequence setLength:0];
						
						[currentKeySequenceString release];
						[currentSequenceString release];
						i++;
					}
					else
					{
						return i + 2;
					}
					maybeEndSequence = true;
				}
				break;
			default:
				[currentHeaderSequence appendBytes:(bytes + i) length:1];
				maybeEndSequence = false;
				break;
		}
	}
	return -1;
}

- (void) clean
{
	endOfFirstHeader = -1;
	startReadIndex = 0;
	contentLengthRemaining = -1;
	currentUID = 1;
	
	[headerMap removeAllObjects];
	[incomingMessageBuffer setLength:0];
	[currentKeyHeaderSequence setLength:0];
	[currentHeaderSequence setLength:0];
	[firstMessageBuffer setLength:0];
}

- (void) dealloc
{
	[headerMap release];
	headerMap = nil;
	
	[incomingMessageBuffer release];
	incomingMessageBuffer = nil;
	
	[currentKeyHeaderSequence release];
	currentKeyHeaderSequence = nil;
	
	[currentHeaderSequence release];
	currentHeaderSequence = nil;
	
	[firstMessageBuffer release];
	firstMessageBuffer = nil;
	
	[contentCoding release];
	contentCoding = nil;
	
	[super dealloc];
}
@end
