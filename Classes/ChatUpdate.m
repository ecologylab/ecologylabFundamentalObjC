//
//  ChatUpdate.m
//  ecologylabXML
//
//  Generated by CocoaTranslator on 06/03/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import "ChatUpdate.h"

@implementation ChatUpdate

@synthesize message;
@synthesize host;
@synthesize port;

+ (void) initialize {
	[ChatUpdate class];
}

- (void) dealloc {
	[message release];
	[host release];
}

- (void) setPortWithReference: (int *) p_port {
	port = *p_port;
}

@end
