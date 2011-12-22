//
//  ParsedUrlType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "ParsedUrlType.h"

@implementation ParsedUrlType


+ (id) parsedUrlType
{
    return [[[ParsedUrlType alloc] init] autorelease];
}

- (id) init
{
    if((self = [super initWithSimpleName:@"ParsedURL"]))
    {
        
    }
    return self;
}

@end
