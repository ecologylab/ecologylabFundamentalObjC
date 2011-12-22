//
//  SimplEnum.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "SimplEnum.h"

@implementation SimplEnum

@synthesize enumDictionary;

+ (id) simplEnumWithKeys : (NSArray *) keys andValues : (NSArray *) values
{
    return [[[SimplEnum alloc] initWithKeys : keys andValues : values] autorelease];
}

- (id) initWithKeys : (NSArray *) keys andValues : (NSArray *) values
{
    if ((self = [super init]))
    {
        self.enumDictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (int) valueFromString : (NSString *) enumString
{
    return [[self.enumDictionary objectForKey:enumString] intValue];
}

- (NSString *) stringFromValue : (int) value
{
    return  [[self.enumDictionary allKeys] objectAtIndex:value];
}

@end
