//
//  JsonPullDeserializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/2/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "JsonPullDeserializer.h"

@implementation JsonPullDeserializer



+ (id) jsonPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context
{
   return [[[JsonPullDeserializer alloc] initWithSimplTypesScope:scope andContext:context andStrategy:nil] autorelease];
}

+ (id) jsonPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy
{
    return [[[JsonPullDeserializer alloc] initWithSimplTypesScope:scope andContext:context andStrategy:strategy] autorelease];
}

- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy
{
    if(( self = [super initWithSimplTypesScope:scope andContext:context andStrategy:strategy]))
    {
        
    }
    return self;
}

- (NSObject *) parseString : (NSString *) inputString
{
    // TODO: implement this
    return nil;
}

@end
