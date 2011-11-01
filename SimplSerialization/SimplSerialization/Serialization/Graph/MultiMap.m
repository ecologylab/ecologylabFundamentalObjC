//
//  MultiMap.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "MultiMap.h"

#import "ClassDescriptor.h"

// private members
@interface MultiMap() 

@property(nonatomic, readwrite, retain) NSMutableDictionary* map;

- (id) init;
- (int) containsValue : (NSMutableArray *) collection andValue : (NSObject *) value;

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


- (bool) put : (NSObject *) key andValue : (NSObject *) value
{
    if ([map objectForKey:key] != nil)
    {
        NSMutableArray *collection = [NSMutableArray arrayWithCapacity:1];
        [collection addObject:value];
        [map setObject:value forKey:key];
        return true;
    }
    else
    {
        NSMutableArray *collection = [map objectForKey:key];
        if([self containsValue:collection andValue:value] != -1)
        {
            [collection addObject:value];
            return true;
        }
    }
    return false;
}


- (int) contains : (NSObject *) key andValue : (NSObject *) value
{
    if ([map objectForKey:key] != nil)
    {
        NSMutableArray *collection = [map objectForKey:key];
        return [self containsValue:collection andValue:value];
    }
    else return -1;
}

- (int) containsValue : (NSMutableArray *) collection andValue : (NSObject *) value
{
    ClassDescriptor* classDescriptor = [ClassDescriptor classDescriptorWithObject:value];
    
    int index = 0;
    if ([classDescriptor isStrictObjectGraphRequired])
    {
        for (NSObject* item in collection)
        {
            if (item == value)
            {
                return index;
            }
            index ++;
        }
        return -1;
    }
    else
    {
        for (NSObject* item in collection)
        {
            if ([item isEqual:value])
            {
                return index;
            }
            index ++;
        }
        return -1;
    }
}

- (int) size 
{
    return [map count];
}

- (NSObject *) get : (NSObject *) key
{
    return [map objectForKey:key];
}

@end
