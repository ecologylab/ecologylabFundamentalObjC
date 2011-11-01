//
//  StringPullDeserializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "StringPullDeserializer.h"

@implementation StringPullDeserializer

- (NSObject *) parse : (NSData *) inputData
{
    NSString* inputDataString = [[NSString alloc] initWithData:inputData
                                             encoding:NSUTF8StringEncoding];
    return [self parseString:inputDataString];
}

- (NSObject *) parseString : (NSString *) inputString
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


@end
