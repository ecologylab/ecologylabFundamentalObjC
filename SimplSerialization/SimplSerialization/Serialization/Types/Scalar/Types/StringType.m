//
//  StringType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "StringType.h"

@implementation StringType


+ (id) stringType
{
    return [[[StringType alloc] init] autorelease];
}

- (id) init
{
    if((self = [super initWithSimpleName:@"String"]))
    {
        
    }
    return self;
}

- (void) appendValue : (NSMutableString *) outputString andValue : (id) valueObject
{
    [outputString appendString :valueObject];
}

- (bool) isDefaultValue : (id) valueObject
{
    return valueObject == nil || [valueObject isEqualToString:@""];
}

@end
