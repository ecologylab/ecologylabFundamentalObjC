//
//  SimplEnum.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimplEnum : NSObject
{    
    @private NSDictionary *enumDictionary;
}

@property(nonatomic, readwrite, retain) NSDictionary *enumDictionary;


+ (id) simplEnumWithKeys : (NSArray *) keys andValues : (NSArray *) values;
- (id) initWithKeys : (NSArray *) keys andValues : (NSArray *) values;
- (int) valueFromString : (NSString *) enumString;
- (NSString *) stringFromValue : (int) value;

@end
