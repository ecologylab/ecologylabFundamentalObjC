//
//  EnumeratedType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/21/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "EnumeratedType.h"

@implementation EnumeratedType

@synthesize simplEnum;

//overriding the setField method from scalar type. 
- (void) setField : (NSObject *) object andFieldName : (NSString *) fieldName andValue : (NSString *) value
{
    int enumValue = [simplEnum valueFromString:value];
    [object setValue:value forKey:fieldName];
}

//overriding the appendValue method from scalar type.  
- (void) appendValue : (NSMutableString *) outputString andValue : (id) valueObject
{
    [simplEnum stringFromValue:[valueObject intValue]];
    [outputString appendString :[valueObject stringValue]];
}

@end
