//
//  AnotherEnum.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "AnotherEnum.h"


static NSDictionary *enumDict;

@implementation AnotherEnum

+ (NSDictionary *) enumDict
{
    if(enumDict == nil)
	{
		NSArray *keyArray = [NSArray arrayWithObjects:	@"MyOne", 
                             @"MyTwo", nil];
		
		NSArray *objectArray =   [NSArray arrayWithObjects:
                                  [NSNumber numberWithInt:MyOne],
                                  [NSNumber numberWithInt:MyTwo],
                                  nil];
		
		enumDict = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
		
		[enumDict retain];
	}
	
	return enumDict;
}

- (int) valueFromString : (NSString *) enumString
{
    return [[[AnotherEnum enumDict]  objectForKey:enumString] intValue];
}

- (NSString *) stringFromValue : (int) value
{
    return  [[[AnotherEnum enumDict] allKeys] objectAtIndex:value];
}

@end
