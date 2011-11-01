//
//  PullDeserializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplEnums.h"
#import "TranslationContext.h"
#import "DeserializationHookStrategy.h"
#import "SimplTypesScope.h"

@interface PullDeserializer : NSObject
{
    @protected SimplTypesScope* simplTypesScope;
    @protected TranslationContext *translationContext;
    @protected id<DeserializationHookStrategy> deserializationHookStrategy;
}

@property(nonatomic, readwrite, retain) SimplTypesScope* simplTypesScope;
@property(nonatomic, readwrite, retain) TranslationContext* translationContext;
@property(nonatomic, readwrite, retain) id<DeserializationHookStrategy>  deserializationHookStrategy;

+ (id) formatDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat;
+ (id) stringDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat;
+ (id) binaryDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andFormat : (Format) inputFormat;

//abstact method
- (NSObject *) parse : (NSData *) inputData;

- (void) deserializationPreHook : (NSObject *) object andContext : (TranslationContext *) context;
- (void) deserializationPostHook : (NSObject *) object andContext : (TranslationContext *) context;



@end
