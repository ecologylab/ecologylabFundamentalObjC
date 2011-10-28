//
//  TranslationContext.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "TranslationContext.h"

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

- (void) resolveGraphRecursive : (NSObject *) object
{
    
}

// public methods 
- (void) setBAseDirFile : (NSFileHandle *) fileDirContext
{
    baseDirFile = fileDirContext;
    baseDirPurl = [ParsedURL parsedURLWithFile:fileDirContext];
}

- (void) initMaps
{
    
}

- (void) markAsUmarshalled : (NSString *) key andObject : (NSObject *) object
{
    
}
- (void) resolveGraph : (NSObject *) object
{
    
}
- (bool) alreadyVisited : (NSObject *) object
{
    
}

- (void) mapObject : (NSObject *) object
{
    
}

- (bool) needsHashCode : (NSObject *) object
{
    
}

- (bool) isGraph
{
    
}

- (NSObject *) getFromMap : (NSString *) key
{
    
}

- (NSString *) getSimplId : (NSObject *) object
{
    
}

- (NSString *) getDelimiter;
{
    
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
