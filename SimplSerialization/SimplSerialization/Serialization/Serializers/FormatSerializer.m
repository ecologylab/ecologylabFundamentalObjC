//
//  FormatSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "FormatSerializer.h"
#import "XmlSerializer.h"
#import "JsonSerializer.h"
#import "TlvSerializer.h"


@implementation FormatSerializer

+ (id) serializerWithFormat : (Format) inputFormat
{
    switch (inputFormat) {
        case kFXml:
            return [XmlSerializer xmlSerializer];
            break;
            // add json, tlv, bibtex
        default:
            break;
    }
    return nil;
}

+ (id) serializerWithStringFormat : (StringFormat) inputFormat
{
    switch (inputFormat) {
        case kSFXml:            
            return [XmlSerializer xmlSerializer];
            break;
            //add json bibtex
            
        default:
            break;
    }
    return nil;
}

+ (id) serializerWithBinaryFormat : (BinaryFormat) inputFormat
{
    switch (inputFormat) {
        case kBFTlv:
            // add tlv serializer initializer
            break;
            
        default:
            break;
    }
    return nil;
    
}


- (void) serialize : (NSObject *) object andData : (NSData *) outputData
{
    [self serialize:object andData:outputData andContext:[TranslationContext translationContext]];
}

- (void) serialize : (NSObject *) object andData : (NSData *) outputData andContext : (TranslationContext *) translationContext
{
    // abstract method must be overloaded by derived serializers. 
}

- (bool) alreadySerialized: (NSObject *) object andContext : (TranslationContext *) translationContext
{
    return [translationContext alreadyMarshalled : object];
}

@end
