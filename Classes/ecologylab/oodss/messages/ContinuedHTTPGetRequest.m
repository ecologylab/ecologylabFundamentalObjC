//
//  ContinuedHTTPGetRequest.m
//  ecologylabXML
//
//  Generated by CocoaTranslator on 10/18/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import "ContinuedHTTPGetRequest.h"

@implementation ContinuedHTTPGetRequest

@synthesize messageFragment;
@synthesize isLast;
- (void) dealloc {
	[messageFragment release];
	[super dealloc];
}

- (void) setIsLastWithReference: (bool *) p_isLast {
	isLast = *p_isLast;
}



@end

