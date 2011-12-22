//
//  DeserializationHookStrategy.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldDescriptor.h"

@protocol DeserializationHookStrategy <NSObject>

- (void) deserializationPreHook : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd;
- (void) deserializationPostHook : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd;

@end
