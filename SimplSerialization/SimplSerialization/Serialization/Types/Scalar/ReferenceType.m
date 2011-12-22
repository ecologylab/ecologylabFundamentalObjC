//
//  ReferenceType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "ReferenceType.h"

@implementation ReferenceType


- (bool) isDefaultValue : (id) valueObject
{
    return valueObject == nil;
}


@end
