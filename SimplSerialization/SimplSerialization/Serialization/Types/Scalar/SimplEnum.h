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
    @private NSDictionary *stringToInteger;
    @private NSDictionary *integerToString;
}

@property(nonatomic, readwrite, retain) NSDictionary *stringToInteger;
@property(nonatomic, readwrite, retain) NSDictionary *integerToString;


+ (id) simplEnumWithStrings : (NSArray *) keys andIntegers : (NSArray *) values;
- (id) initWithStrings : (NSArray *) keys andIntegers : (NSArray *) values;
- (int) valueFromString : (NSString *) enumString;
- (NSString *) stringFromValue : (int) value;

@end
