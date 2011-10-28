//
//  MultiMap.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "MultiMap.h"

@interface MultiMap(Private) 

@property(nonatomic, readwrite, retain) NSMutableDictionary* map;
- (void) somePrivateMethod;

@end

@implementation MultiMap

@synthesize map;

//static method to create an auto released instance of multi-map
+ (id) multiMap
{
    return [[[MultiMap alloc] init] autorelease];
}

//constructor method to initailize map. 
- (id) init
{
    if(( self = [super init]))
    {
        map = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end
