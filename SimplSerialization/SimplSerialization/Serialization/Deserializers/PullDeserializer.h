//
//  PullDeserializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplDefs.h"
#import "TranslationContext.h"
#import "DeserializationHookStrategy.h"
#import "SimplTypesScope.h"


@class StringPullDeserializer;

@interface PullDeserializer : NSObject
{
    @protected SimplTypesScope* simplTypesScope;
    @protected TranslationContext *translationContext;
    @protected id<DeserializationHookStrategy> deserializationHookStrategy;
}

@property(nonatomic, readwrite, retain) SimplTypesScope* simplTypesScope;
@property(nonatomic, readwrite, retain) TranslationContext* translationContext;
@property(nonatomic, readwrite, retain) id<DeserializationHookStrategy>  deserializationHookStrategy;



+ (PullDeserializer*) formatDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat;
+ (StringPullDeserializer*) stringDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStringFormat : (StringFormat) inputFormat;
+ (PullDeserializer*) binaryDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andBinaryFormat : (BinaryFormat) inputFormat;


- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;

//abstact method
- (NSObject *) parse : (NSData *) inputData;

- (void) deserializationPreHook : (NSObject *) object andContext : (TranslationContext *) context;
- (void) deserializationPostHook : (NSObject *) object andContext : (TranslationContext *) context;



@end
