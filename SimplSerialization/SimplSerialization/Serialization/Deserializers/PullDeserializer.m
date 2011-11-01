//
//  PullDeserializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "PullDeserializer.h"
#import "SimplDeserializationPre.h"
#import "SimplDeserializationPost.h"

@interface PullDeserializer()



+ (id) pullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context;
+ (id) pullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;

- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;

@end

@implementation PullDeserializer

@synthesize simplTypesScope;
@synthesize translationContext;
@synthesize deserializationHookStrategy;


+ (id) pullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context
{
    return [[[PullDeserializer alloc] initWithSimplTypesScope:scope andContext:context andStrategy:nil] autorelease];
}

+ (id) pullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy
{
    return [[[PullDeserializer alloc] initWithSimplTypesScope:scope andContext:context andStrategy:strategy] autorelease];
}

- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy
{
    if(( self = [super init]))
    {
        simplTypesScope = scope;
        translationContext = context;
        deserializationHookStrategy = strategy;
    }
    return self;
}


+ (id) formatDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat
{
    switch (inputFormat) {
        case kFXml:
            
            break;
            
        default:
            break;
    }
    return nil;
}

+ (id) stringDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat
{
    switch (inputFormat) {
        case kSFXml:
            
            break;
            
        default:
            break;
    }
    return nil;
}

+ (id) binaryDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat
{
    switch (inputFormat) 
    {
        case kBFTlv:
            
            break;
            
        default:
            break;
    }
    return nil;
}

// abstract method
- (NSObject *) parse : (NSData *) inputData
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void) deserializationPreHook : (NSObject *) object andContext : (TranslationContext *) context
{
    if([object conformsToProtocol:@protocol(SimplDeserializationPre)])
    {
        [(id <SimplDeserializationPre>)object deserializationPreHook:context andObject:object];
    }
}


- (void) deserializationPostHook : (NSObject *) object andContext : (TranslationContext *) context
{
    if([object conformsToProtocol:@protocol(SimplDeserializationPost)])
    {
        [(id <SimplDeserializationPost>)object deserializationPostHook:context andObject:object];
    }
}





@end
