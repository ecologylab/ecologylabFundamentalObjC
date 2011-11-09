//
//  TypeRegistry.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "TypeRegistry.h"
#import "IntType.h"
#import "FloatType.h"
#import "StringType.h"
#import "ParsedUrlType.h"
#import "ScalarType.h"

@implementation TypeRegistry

static NSMutableDictionary* scalarTypes;
static NSMutableDictionary* collectionTypes;

static ScalarType* intType;
static ScalarType* floatType;
static ScalarType* stringType;
static ScalarType* parsedUrlType;


+ (void) initialize
{
    scalarTypes = [NSMutableDictionary dictionary];
    collectionTypes = [NSMutableDictionary dictionary];
    
    intType = [IntType intType];
    floatType = [FloatType floatType];
    stringType = [StringType stringType];
    parsedUrlType = [ParsedUrlType parsedUrlType];    
}

+ (ScalarType*) scalarTypeFromName : (NSString *) typeName
{
    return [scalarTypes objectForKey:typeName];
}

+ (SimplType*) collectionTypeFromName : (NSString *) typeName
{
    return [collectionTypes objectForKey:typeName];
}

+ (void) registerScalarType : (SimplType *) simplType
{
    [scalarTypes setObject:simplType forKey:simplType.simpleName];
}

+ (void) registerCollectionType : (SimplType *) simplType
{
    [collectionTypes setObject:simplType forKey:simplType.simpleName];    
}

@end
