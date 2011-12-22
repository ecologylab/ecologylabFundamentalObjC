//
//  SimplType.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "SimplType.h"
#import "TypeRegistry.h"

@implementation SimplType

@synthesize simpleName;


- (id) initWithSimpleName : (NSString *) name// andIsCollection : (bool) isCollection;
{
    if ((self = [super init]))
    {
        simpleName = name;
        [TypeRegistry registerScalarType:self];
    }
    
    return self;
}

@end
