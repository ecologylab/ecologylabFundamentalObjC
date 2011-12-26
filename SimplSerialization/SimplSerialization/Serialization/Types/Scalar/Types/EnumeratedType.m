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

+ (id) enumeratedTypeWithSimplEnum : (SimplEnum *) pSimplEnum
{
    return [[EnumeratedType alloc] initWithSimplEnum:pSimplEnum];
}
- (id) initWithSimplEnum : (SimplEnum *) pSimplEnum
{
    if((self = [super init]))
    {
        self.simplEnum = pSimplEnum;
    }
    return self;
}

//overriding the setField method from scalar type. 
- (void) setField : (NSObject *) object andFieldName : (NSString *) fieldName andValue : (NSString *) value
{
    int enumValue = [simplEnum valueFromString:value];
    [object setValue:[NSNumber numberWithInt: enumValue] forKey:fieldName];
}

//overriding the appendValue method from scalar type.  
- (void) appendValue : (NSMutableString *) outputString andValue : (id) valueObject
{
    NSString* stringValue = [simplEnum stringFromValue:[valueObject intValue]];
    [outputString appendString :stringValue];
}

@end
