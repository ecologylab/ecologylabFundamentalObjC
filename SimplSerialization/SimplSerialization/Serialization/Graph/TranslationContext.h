//
//  TranslationContext.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScalarUnmarshallingContext.h"
#import "XmlStreamReader.h"

@interface TranslationContext : NSObject<ScalarUnmarshallingContext>
{
    XmlStreamReader *reader;
}


@end
