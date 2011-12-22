//
//  JsonSerializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TranslationContext.h"
#import "StringSerializer.h"


@interface JsonSerializer : StringSerializer


+ (id) jsonSerializer;
- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext;

@end
