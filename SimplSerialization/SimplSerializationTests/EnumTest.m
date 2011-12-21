//
//  EnumTest.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "VisibilityEnum.h"
#import "AnotherEnum.h"

@interface EnumTest : GHTestCase { }
@end

@implementation EnumTest

- (void) testWithOne
{    
    VisibilityEnum* vE = [[[VisibilityEnum alloc] init] autorelease];
    AnotherEnum* aE = [[[AnotherEnum alloc] init] autorelease];
    
    GHTestLog(@"%@", [vE stringFromValue : 0]); 
    GHTestLog(@"%@", [aE stringFromValue : 0]); 
}

- (void) testWithTwo
{    
    VisibilityEnum* vE = [[[VisibilityEnum alloc] init] autorelease];
    AnotherEnum* aE = [[[AnotherEnum alloc] init] autorelease];
    
    GHTestLog(@"%@", [vE stringFromValue : 1]); 
    GHTestLog(@"%@", [aE stringFromValue : 1]); 
}

@end