//
//  JsonPullDeserializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/2/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringPullDeserializer.h"
#import "JsonReader.h"

@interface JsonPullDeserializer : StringPullDeserializer
{
    @private JsonReader* jsonReader;
}

+ (id) jsonPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context;
+ (id) jsonPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;
- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;

- (NSObject *) parseString : (NSString *) inputString;

@end
