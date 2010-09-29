//
//  HeartBeater.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 4/1/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "HeartBeater.h"


@implementation HeartBeater

@synthesize client;

-(id) initWithClient:(id<Client>) c andDelay:(double) d
{
	if( self = [super init])
	{
	self.client = c;
	started = FALSE;
	delay = d;
		cachedPing = [[Ping alloc] init];
	}
	return self;
}

-(void) start
{
	
		if(!started)
		{
			started = TRUE;
			[self performSelector:@selector(Beat) withObject:nil afterDelay:delay];
		}
	
}

-(void) stop
{
	if(started)
	{
		started = FALSE;
	}
}

-(void) Beat
{
	if(started)
	{
		[client sendMessage:cachedPing];
		[self performSelector:@selector(Beat) withObject:nil afterDelay:delay];
	}
}


-(void) dealloc
{
	self.client = nil;
	
	[cachedPing release];
	cachedPing = nil;
	
	[super dealloc];
}

@end
