//
//  HistoryEchoResponse.m
//  ecologylabXML
//
//  Created by ecologylab on 1/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HistoryEchoResponse.h"
#import "XMLClient.h"
#import "Client.h"

@implementation HistoryEchoResponse

@synthesize echo;
@synthesize prevEcho;

-(void) processResponse:(Scope*) scope
{
	NSLog(@"Echo %@", self.echo);
		  
	id<Client> client = (id<Client>)[((NSValue*) [scope objectForKey: @"OODSS_CLIENT"]) pointerValue];
	
	if(client != nil)
	{
		int nextEcho = [self.echo intValue];
		
		nextEcho++;
		
		HistoryEchoRequest* req = [[HistoryEchoRequest alloc] init];
		
		req.newEcho = [NSString stringWithFormat:@"%d", nextEcho];
		
		[client performSelector:@selector(sendMessage:) withObject:req afterDelay:5.0];
		
		[req release];
	}
}

@end
