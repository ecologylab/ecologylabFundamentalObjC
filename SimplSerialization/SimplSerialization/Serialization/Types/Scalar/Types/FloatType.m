//
//  FloatType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "FloatType.h"

@implementation FloatType

+ (id) floatType
{
    return [[[FloatType alloc] init] autorelease];
}

- (id) init
{
    if((self = [super initWithSimpleName:@"float"]))
    {
        
    }
    return self;
}

- (bool) isDefaultValue : (id) valueObject
{
    return [valueObject floatValue] == 0;
}

@end
