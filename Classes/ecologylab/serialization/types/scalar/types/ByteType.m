//
//  ByteType.m
//  ecologylabFundamentalObjC
//
//  Created by Nabeel Shahzad on 10/19/10.
//  Copyright 2010 Texas A&M University. All rights reserved.
//

#import "ByteType.h"


@implementation ByteType

+ (id) byteTypeWithString : (NSString *) value 
{
	return [[[ByteType alloc] initWithString: value] autorelease];
}

- (void) setDefaultValue 
{
	DEFAULT_VALUE_STRING = @"0";
}

- (void) setInstance: (NSString *) value 
{
	char *iValue = malloc( sizeof(char) );
	*iValue = (char) [value intValue];
	m_value = (id)iValue;
}

@end
