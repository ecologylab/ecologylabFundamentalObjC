//
//  ExplanationResponse.m
//  ecologylabXML
//
//  Created by William Hamilton on 1/22/10.
//  Copyright 2010 Texas A&M University. All rights reserved.
//


#import "ExplanationResponse.h"

@implementation ExplanationResponse

@synthesize explanation;

+ (void) initialize {
	[ExplanationResponse class];
}

-(void) dealloc
{
	self.explanation = nil;
	
	[super dealloc];
}

@end

