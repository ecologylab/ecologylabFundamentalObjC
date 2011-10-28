//
//  NSNumberType.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 8/26/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "ReferenceIntegerType.h"


@implementation ReferenceIntegerType

+ (id) referenceIntegerTypeWithString : (NSString *) value 
{
	return [[[ReferenceIntegerType alloc] initWithString: value] autorelease];
}

- (void) setDefaultValue 
{
	DEFAULT_VALUE_STRING = nil;
}

- (void) setInstance: (NSString *) value 
{
	m_value = [[NSNumber alloc] initWithInteger:[value integerValue]];
}

@end
