//
//  BibtexSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "BibtexSerializer.h"


@interface BibtexSerializer()
{
    
}
@end

@implementation BibtexSerializer


+ (id) bibtexSerializer
{
    return [[[BibtexSerializer alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext
{
    //TODO: implement bibtex serialization logic here. 
}

@end