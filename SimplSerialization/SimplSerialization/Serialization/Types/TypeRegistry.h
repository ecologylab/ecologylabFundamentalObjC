//
//  TypeRegistry.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplType.h"
#import "ScalarType.h"

@interface TypeRegistry : NSObject


+ (ScalarType*) scalarTypeFromName : (NSString *) typeName;
+ (SimplType*) collectionTypeFromName : (NSString *) typeName;

+ (void) registerScalarType : (SimplType *) simplType;
+ (void) registerCollectionType : (SimplType *) simplType;

@end
