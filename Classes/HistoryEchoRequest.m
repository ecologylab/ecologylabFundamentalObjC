//
//  HistoryEchoRequest.m
//  ecologylabXML
//
//  Created by ecologylab on 1/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HistoryEchoRequest.h"
#import "HistoryEchoResponse.h"

@implementation HistoryEchoRequest

@synthesize newEcho;

-(ResponseMessage*) PerformService:(Scope*) scope
{
	HistoryEchoResponse* resp = [[HistoryEchoResponse alloc] init];
	resp.echo = [self.newEcho copy];
	resp.prevEcho = [self.newEcho copy];
	
	NSLog(@"HistoryEchoRequest: %@", self.newEcho);
	
	return [resp autorelease];
}


@end
