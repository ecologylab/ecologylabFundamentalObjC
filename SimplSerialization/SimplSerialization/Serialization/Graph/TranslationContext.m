//
//  TranslationContext.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "TranslationContext.h"
#import "ClassDescriptor.h"

@interface TranslationContext () 

@property(nonatomic, readwrite, retain) MultiMap* marshalledObjects;
@property(nonatomic, readwrite, retain) MultiMap* visitedElements;
@property(nonatomic, readwrite, retain) MultiMap* needsAttributeHashCode;
@property(nonatomic, readwrite, retain) MultiMap* unmarshalledObjects;

@property(nonatomic, readwrite, retain) ParsedURL* baseDirPurl;
@property(nonatomic, readwrite, retain) NSFileHandle* baseDirFile;
@property(nonatomic, readwrite, retain) NSString* delimeter;

- (id) init;
- (id) initWithFile : (NSFileHandle *) fileDirContext;
- (id) initWithParsedUrl : (ParsedURL *) purlContext;
- (void) resolveGraphRecursive : (NSObject *) object;

@end


@implementation TranslationContext

@synthesize marshalledObjects;
@synthesize visitedElements;
@synthesize needsAttributeHashCode;
@synthesize unmarshalledObjects;    
@synthesize baseDirPurl;
@synthesize delimeter;    
@synthesize baseDirFile;

// public static accessors 
+ (id) translationContext
{
    return [[[TranslationContext alloc] init] autorelease];
}

+ (id) translationContextWithFile : (NSFileHandle *) fileDirContext
{
    return [[[TranslationContext alloc] initWithFile:fileDirContext] autorelease];    
}

+ (id) translationContextWithParsedUrl : (ParsedURL *) purlContext
{
    return [[[TranslationContext alloc] initWithParsedUrl:purlContext] autorelease];
}


// private methods 
- (id) init
{
    if ((self = [super init]))
    {
        [self initMaps];
    }
    return self;
}

- (id) initWithFile : (NSFileHandle *) fileDirContext
{
    if ((self = [self init]))
    {
        if(fileDirContext != nil)
        {
            baseDirFile = fileDirContext;
        }
    }
    return self;
}

- (id) initWithParsedUrl : (ParsedURL *) purlContext
{
    if ((self = [self init]))
    {
        if(purlContext != nil)
        {
            baseDirPurl = purlContext;
        }
    }
    return self;
    
}

- (NSNumber *) objectHash : (NSObject *) object
{
    return [NSNumber numberWithInt:[object hash]];
}

- (void) resolveGraphRecursive : (NSObject *) object
{
//    [visitedElements put:[self objectHash:object] andValue:object];
//    NSMutableArray* elementFieldDescriptor = [ClassDescriptor classDescriptor : [object class]]; 
//    
//    for(NSObject* object in elementFieldDescriptor)
//    {
//        // TODO: recursive graph resolve logic here. 
//    }
    
    
}

// public methods 
- (void) setBaseDirFile : (NSFileHandle *) fileDirContext
{
    baseDirFile = fileDirContext;
    baseDirPurl = [ParsedURL parsedURLWithFile:fileDirContext];
}

- (void) initMaps
{
    marshalledObjects = [MultiMap multiMap]; 
    visitedElements = [MultiMap multiMap];
    needsAttributeHashCode = [MultiMap multiMap];
    unmarshalledObjects = [MultiMap multiMap];    
}

- (void) markAsUmarshalled : (NSString *) key andObject : (NSObject *) object
{
    [unmarshalledObjects put:key andValue:object];
}

- (void) resolveGraph : (NSObject *) object
{
    [self resolveGraphRecursive:object];    
}

- (bool) alreadyVisited : (NSObject *) object
{
    return [visitedElements contains:[NSNumber numberWithInt:[object hash]] andValue:object] != -1;
}

- (bool) alreadyMarshalled: (NSObject *) object
{
    return [marshalledObjects contains:[NSNumber numberWithInt:[object hash]] andValue:object] != -1;
}

- (void) mapObject : (NSObject *) object
{
    if(object != nil)
    {
        [marshalledObjects put:[NSNumber numberWithInt:[object hash]] andValue:object];
    }
}

- (bool) needsHashCode : (NSObject *) object
{
    return [needsAttributeHashCode contains:[NSNumber numberWithInt:[object hash]] andValue:object] != -1;
}

- (bool) isGraph
{
    return [needsAttributeHashCode size] > 0;
}

- (NSObject *) getFromMap : (NSString *) key
{
    return [unmarshalledObjects get:key];
}

- (NSString *) getSimplId : (NSObject *) object
{
    int objectHash = [object hash];
    int orderedIndex = [marshalledObjects contains:[NSNumber numberWithInt:[object hash]] andValue:object];
    
    if(orderedIndex > 0)
        return  [NSString stringWithFormat:@"%d,%d", objectHash, orderedIndex];
    else
        return [NSString stringWithFormat:@"%d", objectHash];
}

- (NSString *) getDelimiter;
{
    return delimeter;
}

- (ParsedURL *) purlContext
{    
    return nil;
}

- (NSFileHandle *) fileContext
{
    return nil;
}


@end
