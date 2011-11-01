//
//  MultiMap.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiMap : NSObject
{
    @private NSMutableDictionary *map;    
}

+ (id) multiMap;
- (bool) put : (NSObject *) key andValue : (NSObject *) value;
- (int) contains : (NSObject *) key andValue : (NSObject *) value;
- (NSObject *) get : (NSObject *) key;
- (int) size;

@end
