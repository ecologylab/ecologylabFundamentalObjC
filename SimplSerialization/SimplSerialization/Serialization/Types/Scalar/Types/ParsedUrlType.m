//
//  ParsedUrlType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/7/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "ParsedUrlType.h"

#import "ParsedURL.h"

@implementation ParsedUrlType


+ (id) parsedUrlType
{
    return [[[ParsedUrlType alloc] init] autorelease];
}

- (id) init
{
    if((self = [super initWithSimpleName:@"ParsedURL"]))
    {
        
    }
    return self;
}

- (void) setField : (NSObject *) object andFieldName : (NSString *) fieldName andValue : (NSString *) value
{
    ParsedURL *parsedUrlObject = [ParsedURL parsedURLWithAbsoluteAddress:value];
    [object setValue:parsedUrlObject forKey:fieldName];
}

- (void) appendValue : (NSMutableString *) outputString andValue : (id) valueObject
{
    ParsedURL *parsedUrlObject = (ParsedURL *) valueObject; 
    [outputString appendString : [parsedUrlObject toString]];
}

@end
