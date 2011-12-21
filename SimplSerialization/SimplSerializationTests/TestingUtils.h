//
//  TestingUtils.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/15/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplDefs.h"
#import "SimplTypesScope.h"

@interface TestingUtils : NSObject


+ (NSString *) testSerialization : (NSObject *) object andOutputString : (NSMutableString *) outputString andStringFormat : (StringFormat) format;
+ (NSString *) testDeserialization : (SimplTypesScope *) typeScope andInputData : (NSMutableString *) inputString andStringFormat : (StringFormat) format;
//+ (void) test : (NSObject *) inputObject andTypeScope : (SimplTypesScope *) typeScope andStringFormat : (StringFormat) format;

@end
