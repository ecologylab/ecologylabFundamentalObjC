//
//  VisibilityEnum.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplEnum.h"

typedef enum Visibility
{
	GLOBAL = 0,
    PACKAGE = 1
} Visibility;

@interface VisibilityEnum : SimplEnum

- (int) valueFromString : (NSString *) enumString;
- (NSString *) stringFromValue : (int) value;

@end
