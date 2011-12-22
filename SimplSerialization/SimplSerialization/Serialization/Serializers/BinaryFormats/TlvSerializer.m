//
//  TlvSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "TlvSerializer.h"

#import "FieldDescriptor.h"
#import "ClassDescriptor.h"

@implementation TlvSerializer


+ (id) tlvSerializer
{
    return [[[TlvSerializer alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (void) serialize : (NSObject *) object andString : (NSData *) outputString andContext : (TranslationContext *) translationContext
{
    //TODO: implement tlv serialization logic here. 
}

@end
