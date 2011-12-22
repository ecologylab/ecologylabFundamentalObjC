//
//  StringPullDeserializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullDeserializer.h"

@interface StringPullDeserializer : PullDeserializer


- (NSObject *) parse : (NSData *) inputData;

// absract method
- (NSObject *) parseString : (NSString *) inputString;

@end
