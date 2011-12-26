//
//  SimplEnum.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "SimplEnum.h"

@implementation SimplEnum

@synthesize stringToInteger;
@synthesize integerToString;

+ (id) simplEnumWithStrings : (NSArray *) strings andIntegers : (NSArray *) integers
{
    return [[[SimplEnum alloc] initWithStrings : strings andIntegers : integers] autorelease];
}

- (id) initWithStrings : (NSArray *) strings andIntegers : (NSArray *) integers
{
    if ((self = [super init]))
    {
        self.stringToInteger = [NSDictionary dictionaryWithObjects:integers forKeys:strings]; 
        self.integerToString = [NSDictionary dictionaryWithObjects:strings forKeys:integers]; 
    }
    return self;
}

- (int) valueFromString : (NSString *) enumString
{
    return [[self.stringToInteger objectForKey:enumString] intValue];
}

- (NSString *) stringFromValue : (int) value
{
    return [self.integerToString objectForKey:[NSNumber numberWithInt: value]];
}

@end
