//
//  ClassDescriptor.m
//  ecologylabXML
//
//  Generated by CocoaTranslator on 12/14/11.
//  Copyright 2011 Interface Ecology Lab. 
//

#import "ClassB.h"

@implementation ClassB

@synthesize x;
@synthesize y;
@synthesize classC;
@synthesize classX;

- (void) dealloc 
{
	[classC release];
	[classX release];
	[super dealloc];
}

- (void) setXWithReference: (int *) p_x {
	x = *p_x;
}

- (void) setYWithReference: (int *) p_y {
	y = *p_y;
}



@end

