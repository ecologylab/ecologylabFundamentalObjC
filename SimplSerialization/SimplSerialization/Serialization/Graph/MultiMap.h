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
- (id) init;

@property(nonatomic, readonly, retain) NSMutableDictionary *map;
        

@end
