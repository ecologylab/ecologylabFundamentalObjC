//
//  ClassDescriptor.m
//  ecologylabXML
//
//  Generated by CocoaTranslator on 12/14/11.
//  Copyright 2011 Interface Ecology Lab. 
//

#import "Person.h"

@implementation Person

@synthesize name;

- (void) dealloc 
{
	[name release];
	[super dealloc];
}

+ (NSObject *) getPopulatedObject
{
    Person* person = [[[Person alloc] init] autorelease];
    person.name = @"nabeel";
    return person;
}

@end

