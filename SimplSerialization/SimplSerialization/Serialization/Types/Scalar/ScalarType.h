//
//  NewScalarType.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplType.h"


@class FieldDescriptor;

@interface ScalarType : SimplType


- (void) setField : (NSObject *) object andFieldName : (NSString *) fieldName andValue : (NSString *) value;
- (void) appendValue : (NSMutableString *) outputString andFieldDescriptor : (FieldDescriptor *) fd andObject : (NSObject *) object;
- (void) appendValue : (NSMutableString *) outputString andValue : (id) valueObject;
- (bool) isDefaultValue : (FieldDescriptor *) fd andObject : (NSObject *) object;
- (bool) isDefaultValue : (id) valueObject;


@end
