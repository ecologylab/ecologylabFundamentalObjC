//
//  JsonSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "JsonSerializer.h"

@interface JsonSerializer()
{
    
}
@end

@implementation JsonSerializer


+ (id) jsonSerializer
{
    return [[[JsonSerializer alloc] init] autorelease];
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
    //TODO: implement json serialization logic here. 
}

@end
