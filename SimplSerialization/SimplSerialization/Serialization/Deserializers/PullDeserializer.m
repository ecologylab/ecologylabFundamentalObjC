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
#import "XmlPullDeserializer.h"

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


+ (PullDeserializer*) formatDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat
{
    switch (inputFormat) {
        case kFXml:
            return [XmlPullDeserializer xmlPullDeserializer:scope andContext:context];
            break;
            
        default:
            break;
    }
    return nil;
}

+ (StringPullDeserializer *) stringDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStringFormat : (StringFormat) inputFormat
{
    switch (inputFormat) {
        case kSFXml:
            return [XmlPullDeserializer xmlPullDeserializer:scope andContext:context];
            break;
            
        default:
            break;
    }
    return nil;
}

+ (PullDeserializer*) binaryDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andBinaryFormat : (BinaryFormat) inputFormat
{
    switch (inputFormat) 
    {
        case kBFTlv:
            //TODO: define methods
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
