//
//  FormatSerializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslationContext.h"
#import "SimplEnums.h"

//abstract class
@interface FormatSerializer : NSObject


+ (id) serializerWithFormat : (Format) inputFormat;
+ (id) serializerWithStringFormat : (StringFormat) inputFormat;
+ (id) serializerWithBinaryFormat : (BinaryFormat) inputFormat;
                           
- (void) serialize : (NSObject *) object andData : (NSData *) outputData;
- (void) serialize : (NSObject *) object andData : (NSData *) outputData andContext : (TranslationContext *) translationContext;

- (bool) alreadySerialized: (NSObject *) object andContext : (TranslationContext *) translationContext;
                                                        


@end
