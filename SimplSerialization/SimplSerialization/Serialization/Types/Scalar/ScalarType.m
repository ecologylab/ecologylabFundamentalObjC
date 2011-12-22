//
//  NewScalarType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "ScalarType.h"
#import "FieldDescriptor.h"

@implementation ScalarType


- (id) initWithSimpleName:(NSString *)name
{
    if ((self = [super initWithSimpleName:name]))
    {
    
    }
    return self;
}

- (void) setField : (NSObject *) object andFieldName : (NSString *) fieldName andValue : (NSString *) value
{
    // default definition. do we have to implement an override or this works fine? 
    [object setValue:value forKey:fieldName];
}

- (void) appendValue : (NSMutableString *) outputString andFieldDescriptor : (FieldDescriptor *) fd andObject : (NSObject *) object
{
    id value = [object valueForKey:fd.name];
    [self appendValue:outputString andValue : value];
}

- (void) appendValue : (NSMutableString *) outputString andValue : (id) valueObject
{
    // default definition. do we have to implement an override or this works fine? 
    [outputString appendString :[valueObject stringValue]];
}

- (bool) isDefaultValue : (FieldDescriptor *) fd andObject : (NSObject *) object
{
    id valueObject = [object valueForKey:fd.name];
    return [self isDefaultValue:valueObject];
}

- (bool) isDefaultValue : (id) valueObject
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}



@end
