//
//  FacultyTest.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/15/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TestingUtils.h"
#import "Faculty.h"
#import "SimplTypesScope.h"
#import "facultyTScope.h"


@interface FacultyTest : GHTestCase { }
@end

@implementation FacultyTest

- (void) test
{    
    // get simpl types scope
    SimplTypesScope* facultyScope = [facultyTScope simplTypesScope];    
    
    // create object to serialize
    NSObject* faculty = [Faculty getPopulatedObject];    
    
    //test de/serialization of the object
    NSMutableString* serializedData = [NSMutableString string];
    NSString* consoleData;
    
    GHTestLog(@"serialized data");
    consoleData = [TestingUtils testSerialization:faculty andOutputString:serializedData andStringFormat:kSFXml];
    GHTestLog(@"%@", serializedData);
    
    GHTestLog(@"\n");
    GHTestLog(@"deserialized data");
    consoleData = [TestingUtils testDeserialization:facultyScope andInputData:serializedData andStringFormat:kSFXml];
    GHTestLog(@"%@", serializedData);    
}

@end
