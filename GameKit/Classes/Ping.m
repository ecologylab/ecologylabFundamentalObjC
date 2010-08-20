//
//  Ping.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 4/1/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "Ping.h"


@implementation Ping
-(ResponseMessage*) PerformService:(Scope*) scope
{
	return [Pong getSharedInstance];
}
@end
