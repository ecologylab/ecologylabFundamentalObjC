//
//  BibtexSerializer.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TranslationContext.h"
#import "StringSerializer.h"


@interface BibtexSerializer  : StringSerializer


+ (id) bibtexSerializer;
- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext;

@end
