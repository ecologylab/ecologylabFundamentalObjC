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

@interface RssTest : GHTestCase { }
@end

@implementation RssTest

- (void)testDeserialization
{    
    SimplTypesScope* rssScope = [RssSimplTypes simplTypeScope];
    
    Rss* rss = [[[Rss alloc] init] autorelease];
    Channel* channel = [[[Channel alloc] init] autorelease];
    Item* item1 = [[[Item alloc] init] autorelease];
    Item* item2 = [[[Item alloc] init] autorelease];
    
    NSMutableArray* categorySet = [NSMutableArray array];
    
    rss.version = 1.0;
    
    channel.title = @"testTitle";
    channel.description = @"testDescription";
    
    [categorySet addObject:@"category1"];
    [categorySet addObject:@"category2"];

    
    item1.title = @"testItem1";
    item1.description = @"testItem1Description";
//    item1.categorySet = categorySet;
    
    item2.title = @"testItem2";
    item2.description = @"testItem2Description";
    
    NSMutableArray* items = [NSMutableArray array];
    
    [items addObject:item1];
    [items addObject:item2];
    
    channel.items = items;
    rss.channel = channel;
    
    NSString* serializedData = [SimplTypesScope serialize:rss andStringFormat:kSFXml];
    NSLog(@"Serialized Data: \n %@", serializedData);
    
    Rss *deserializedRss = (Rss *) [rssScope deserialize:serializedData andStringFormat:kSFXml];

    NSString* deSerializedData = [SimplTypesScope serialize:deserializedRss andStringFormat:kSFXml];
    NSLog(@"Deerialized Data: \n %@", deSerializedData);
    
}

@end
