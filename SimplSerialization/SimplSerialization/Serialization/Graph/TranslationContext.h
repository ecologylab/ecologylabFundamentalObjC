//
//  TranslationContext.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScalarUnmarshallingContext.h"
#import "MultiMap.h"

@interface TranslationContext : NSObject<ScalarUnmarshallingContext>
{
    
    @private MultiMap* marshalledObjects;
    @private MultiMap* visitedElements;
    @private MultiMap* needsAttributeHashCode;
    @private MultiMap* unmarshalledObjects;    
    
    @protected ParsedURL* baseDirPurl;
    @protected NSString* delimeter;    
    
    @protected NSFileHandle* baseDirFile;
}

+ (id) translationContext;
+ (id) translationContextWithFile : (NSFileHandle *) fileDirContext;
+ (id) translationContextWithParsedUrl : (ParsedURL *) purlContext;

- (void) setBAseDirFile : (NSFileHandle *) fileDirContext;
- (void) initMaps; 
- (void) markAsUmarshalled : (NSString *) key andObject : (NSObject *) object;
- (void) resolveGraph : (NSObject *) object;
- (bool) alreadyVisited : (NSObject *) object;
- (bool) alreadyMarshalled: (NSObject *) object;
- (void) mapObject : (NSObject *) object;
- (bool) needsHashCode : (NSObject *) object;
- (bool) isGraph;
- (NSObject *) getFromMap : (NSString *) key;
- (ParsedURL *) purlContext;
- (NSString *) getSimplId : (NSObject *) object;
- (NSFileHandle *) fileContext;
- (NSString *) getDelimiter; 

@end
