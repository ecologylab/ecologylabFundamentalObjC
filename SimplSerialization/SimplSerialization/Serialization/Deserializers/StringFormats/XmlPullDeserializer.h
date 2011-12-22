//
//  XmlPullDeserializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringPullDeserializer.h"
#import "XmlStreamReader.h"

@interface XmlPullDeserializer : StringPullDeserializer
{
    @private XmlStreamReader* xmlReader;    
}

+ (id) xmlPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context;
+ (id) xmlPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;
- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy;

- (NSObject *) parseString : (NSString *) inputString;

@end
