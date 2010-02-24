//
//  ParsedURLType.h
//  ecologylabXML
//
//  Created by Nabeel Shahzad on 1/8/10.
//  Copyright 2010 Interface Ecology Lab. All rights reserved.
//

#import <stdio.h>
#import <objc/objc-runtime.h>
#import <Foundation/Foundation.h>
#import "ReferenceType.h"

@interface ParsedURLType : ReferenceType {
}

+ (id) parsedURLTypeWithString: (NSString *) value;

@end