//
//  SimplDeserializationPost.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SimplDeserializationPost <NSObject>

- (void) deserializationPostHook : (TranslationContext *) translationContext andObject : (NSObject *) object;

@end
