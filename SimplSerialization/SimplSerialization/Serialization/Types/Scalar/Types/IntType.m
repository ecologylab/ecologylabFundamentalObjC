//
//  IntType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "IntType.h"

@implementation IntType

+ (id) intType
{
    return [[[IntType alloc] init] autorelease];
}

- (id) init
{
    if((self = [super initWithSimpleName:@"Int"]))
    {
        
    }
    return self;
}

- (bool) isDefaultValue : (id) valueObject
{
    return [valueObject intValue] == 0;
}

@end
