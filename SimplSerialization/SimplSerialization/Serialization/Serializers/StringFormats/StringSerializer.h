//
//  StringSerializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormatSerializer.h"



@interface StringSerializer : FormatSerializer


- (void) serialize : (NSObject *) object andData : (NSData *) outputData andContext : (TranslationContext *) translationContext;
- (NSString *) serialize : (NSObject *) object andContext : (TranslationContext *) translationContext;

// abstract method
- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext;

@end
