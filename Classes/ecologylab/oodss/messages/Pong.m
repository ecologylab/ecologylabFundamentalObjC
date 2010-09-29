//
//  Pong.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 4/1/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "Pong.h"

static Pong* sharedInstance = nil;

@implementation Pong


+(Pong*) getSharedInstance
{
	if(sharedInstance == nil)
	{
		sharedInstance = [[Pong alloc] init];
	}
	return sharedInstance;
}

-(void) processResponse:(Scope*) scope
{
	//NSLog(@"Pong!");
}

@end
