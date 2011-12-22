//
//  TestingUtils.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/15/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "TestingUtils.h"

@implementation TestingUtils

+ (NSString *) testSerialization : (NSObject *) object andOutputString : (NSMutableString *) outputString andStringFormat : (StringFormat) format
{
    [SimplTypesScope serialize:object andString:outputString andStringFormat:format];
    return outputString;    
}

+ (NSString *) testDeserialization : (SimplTypesScope *) typeScope andInputData : (NSMutableString *) inputString andStringFormat : (StringFormat) format
{
    NSObject* deserializedObject = [typeScope deserialize:inputString andStringFormat:format];
    
    return [TestingUtils testSerialization:deserializedObject andOutputString:[NSMutableString string] andStringFormat:format];
}

+ (void) test : (NSObject *) inputObject andTypeScope : (SimplTypesScope *) typeScope andStringFormat : (StringFormat) format
{
    NSMutableString* serializedData = [NSMutableString string];
    
    NSLog(@"serialized data \n");
    [TestingUtils testSerialization:inputObject andOutputString:serializedData andStringFormat:format];
    NSLog(@"deserialized data \n");
    [TestingUtils testDeserialization:typeScope andInputData:serializedData andStringFormat:format];
}

@end
