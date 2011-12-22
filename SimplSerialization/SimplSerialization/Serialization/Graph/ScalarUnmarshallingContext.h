//
//  ScalarUnMarshallingContext.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParsedURL.h"

@protocol ScalarUnmarshallingContext <NSObject>

- (ParsedURL *) purlContext;
- (NSFileHandle *) fileContext;

@end
