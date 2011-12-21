//
//  RssTest.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/2/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "Rss.h"
#import "RssSimplTypes.h"
#import "TestingUtils.h"

@interface RssTest : GHTestCase { }
@end

@implementation RssTest

- (void) test
{    
    // get simpl types scope
    SimplTypesScope* rssScope = [RssSimplTypes simplTypeScope];    
    
    // create object to serialize
    NSObject* rss = [Rss getPopulatedObject];    
    
    //test de/serialization of the object
    NSMutableString* serializedData = [NSMutableString string];
    NSString* consoleData;
    
    GHTestLog(@"serialized data");
    consoleData = [TestingUtils testSerialization:rss andOutputString:serializedData andStringFormat:kSFXml];
    GHTestLog(@"%@", serializedData);
    
    GHTestLog(@"\n");
    GHTestLog(@"deserialized data");
    consoleData = [TestingUtils testDeserialization:rssScope andInputData:serializedData andStringFormat:kSFXml];
    GHTestLog(@"%@", serializedData);   
}

@end
