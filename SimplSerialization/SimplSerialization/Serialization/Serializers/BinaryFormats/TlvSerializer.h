//
//  TlvSerializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinarySerializer.h"
#import "TranslationContext.h"

@interface TlvSerializer : BinarySerializer

+ (id) tlvSerializer;
- (void) serialize : (NSObject *) object andString : (NSData *) outputString andContext : (TranslationContext *) translationContext;

@end
