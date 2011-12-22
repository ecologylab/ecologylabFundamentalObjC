//
//  VisibilityEnum.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "VisibilityEnum.h"

static NSDictionary *enumDict;

@implementation VisibilityEnum

+ (NSDictionary *) enumDict
{
    if(enumDict == nil)
	{
		NSArray *keyArray = [NSArray arrayWithObjects:	@"GLOBAL", 
                             @"PACKAGE", nil];
		
		NSArray *objectArray =   [NSArray arrayWithObjects:
                                 [NSNumber numberWithInt:GLOBAL],
                                 [NSNumber numberWithInt:PACKAGE],
                                 nil];
		
		enumDict = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
		
		[enumDict retain];
	}
	
	return enumDict;
}

- (int) valueFromString : (NSString *) enumString
{
    return [[[VisibilityEnum enumDict]  objectForKey:enumString] intValue];
}

- (NSString *) stringFromValue : (int) value
{
    return  [[[VisibilityEnum enumDict] allKeys] objectAtIndex:value];
}

@end
