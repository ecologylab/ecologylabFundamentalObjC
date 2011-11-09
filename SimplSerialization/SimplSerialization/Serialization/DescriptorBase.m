//
//  DescriptorBase.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "DescriptorBase.h"

@implementation DescriptorBase


@synthesize tagName;
@synthesize comment;
@synthesize otherTags;

- (id) init 
{
	if ( (self = [super init]) ) 
	{
        
	}
	return self;
}

@end
