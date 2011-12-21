//
//  PersonTest.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/15/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//


#import <GHUnitIOS/GHUnit.h>

#import "TestingUtils.h"
#import "Person.h"
#import "SimplTypesScope.h"
#import "personTScope.h"


@interface PersonTest : GHTestCase { }
@end

@implementation PersonTest

- (void) test
{    
    // get simpl types scope
    SimplTypesScope* personScope = [personTScope simplTypesScope];    
    
    // create object to serialize
    NSObject* person = [Person getPopulatedObject];    
    
    //test de/serialization of the object    
    NSMutableString* serializedData = [NSMutableString string];
    NSString* consoleData;
    
    GHTestLog(@"serialized data");
    consoleData = [TestingUtils testSerialization:person andOutputString:serializedData andStringFormat:kSFXml];
    GHTestLog(@"%@", serializedData);
    
    GHTestLog(@"\n");
    GHTestLog(@"deserialized data");
    consoleData = [TestingUtils testDeserialization:personScope andInputData:serializedData andStringFormat:kSFXml];
    GHTestLog(@"%@", serializedData);
}

@end

