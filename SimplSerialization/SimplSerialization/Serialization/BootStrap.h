//
//  BootStrap.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/2/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplTypesScope.h"
#import "ClassDescriptor.h"
#import "FieldDescriptor.h"

@interface BootStrap : NSObject

// creates an instance of simpl types scope from file, used for data binding
+ (SimplTypesScope *) deserializeSimplTypesFromFile: (NSString *) filePath;

@end
