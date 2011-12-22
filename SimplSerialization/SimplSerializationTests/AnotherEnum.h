//
//  AnotherEnum.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimplEnum.h"

typedef enum Another
{
	MyOne = 0,
    MyTwo = 1
} Another;

@interface AnotherEnum : SimplEnum

- (int) valueFromString : (NSString *) enumString;
- (NSString *) stringFromValue : (int) value;

@end