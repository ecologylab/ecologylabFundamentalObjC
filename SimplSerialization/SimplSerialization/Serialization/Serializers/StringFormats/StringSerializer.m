//
//  StringSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "StringSerializer.h"

@implementation StringSerializer



- (void) serialize : (NSObject *) object andData : (NSData *) outputData andContext : (TranslationContext *) translationContext
{
    NSMutableString* outputDataString = [NSMutableString string];
    [self serialize:object andString:outputDataString andContext:translationContext];
    outputData = [outputDataString dataUsingEncoding:NSUTF8StringEncoding];    
}

- (NSString *) serialize : (NSObject *) object andContext : (TranslationContext *) translationContext
{
    NSMutableString* outputDataString = [NSMutableString string];
    [self serialize:object andString:outputDataString andContext:translationContext];
    return outputDataString;
}

- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext
{
    // abstract method must be overridden by a specific serializer. 
}

@end
