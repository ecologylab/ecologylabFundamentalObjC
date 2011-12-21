//
//  XmlSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "XmlSerializer.h"
#import "ClassDescriptor.h"
#import "FieldDescriptor.h"
#import "SimplTypesScope.h"
#import "FieldTypes.h"
#import "SimplTools.h"

//private methods and properties 
@interface XmlSerializer()


@property(nonatomic, readwrite) bool isRoot;


- (void) serialize : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) rootClassDescriptor andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) serializeAttributes : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext andClassDescriptor: (ClassDescriptor *) rootClassDescriptor;
- (void) serializeFields : (NSObject *) object andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext andElementFieldDescriptors : (NSMutableArray *) elementFieldDescriptors;

- (void) writeSimplRef : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) writeObjectStart : (FieldDescriptor *) fd andString: (NSMutableString *) outputString;
- (void) writeObjectClose : (FieldDescriptor *) fd andString: (NSMutableString *) outputString;
- (void) writeCompleteClose : (NSMutableString *) outputString;
- (void) writeWrap : (FieldDescriptor *) fd andString: (NSMutableString *) outputString andClose : (bool) close;
- (void) writeValueAsLeaf : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext;
- (void) writeScalarCollectionLeaf : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext;
- (void) writeValueAsText : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString;
- (void) writeClose : (NSMutableString *) outputString;
- (void) writeValueAsAtrribute : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) writeSimplNameSpace : (NSMutableString *) outputString;
- (void) writeSimplRefAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) writeSimplIdAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;

@end


//implementation of XmlSerializer public & private
@implementation XmlSerializer

@synthesize isRoot;

+ (id) xmlSerializer
{
    return [[[XmlSerializer alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init]))
    {
        isRoot = true;
    }
    return self;
}

// public serialize method
- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext
{
    [translationContext resolveGraph:object];    
    ClassDescriptor *rootClassDescriptor = [ClassDescriptor classDescriptorWithObject: object];    
    [self serialize:object andFieldDescriptor : [rootClassDescriptor pseudoFieldDescriptor] andString: outputString andContext: translationContext];   
}


//private methods 
- (void) serialize : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) rootFieldDescriptor andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    if (object == nil)
        return;
    
    if ([self alreadySerialized : object andContext: translationContext])
    {
        [self writeSimplRef : object andFieldDescriptor: rootFieldDescriptor andString: outputString andContext: translationContext];
        return;
    }
    
    [translationContext mapObject:object];
    
    [self serializationPreHook : object andContext : translationContext];
    
    [self writeObjectStart:rootFieldDescriptor andString:outputString];
    
    ClassDescriptor* rootClassDescriptor = [ClassDescriptor classDescriptorWithObject:object];
    
    [self serializeAttributes:object andString:outputString andContext:translationContext andClassDescriptor:rootClassDescriptor];
    
    NSMutableArray* elementFieldDescriptors = [rootClassDescriptor elementFieldDescriptors];
    
    bool hasXmlText = rootClassDescriptor.hasScalarTextFd;
    bool hasElements = elementFieldDescriptors.count;
    
    if(!hasElements && !hasXmlText)
    {
        [self writeCompleteClose:outputString];
    }
    else
    {
        [self writeClose:outputString];
        
        if(hasXmlText)
        {
            [self writeValueAsText:object andFieldDescriptor:rootClassDescriptor.scalarTextFd andString:outputString];
        }
        
        [self serializeFields:object andString:outputString andContext:translationContext andElementFieldDescriptors:elementFieldDescriptors];
        [self writeObjectClose:rootFieldDescriptor andString:outputString];
    }    
}


- (void) serializeAttributes : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext andClassDescriptor: (ClassDescriptor *) rootClassDescriptor
{
    NSArray* attributeFieldDescriptor = [rootClassDescriptor attributeFieldDescriptors];
    for (FieldDescriptor *fd in attributeFieldDescriptor)        
    {
        [self writeValueAsAtrribute:object andFieldDescriptor:fd andString:outputString andContext:translationContext];
    }
    
    if([SimplTypesScope isGraphHandlingEnabled])
    {
        if ([translationContext needsHashCode:object])
        {
            [self writeSimplIdAttribute:object andString:outputString andContext:translationContext];
        }
        
        if (isRoot && [translationContext isGraph])
        {
            [self writeSimplNameSpace:outputString];
            isRoot = false;
        }
    }
}


- (void) serializeFields : (NSObject *) object andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext andElementFieldDescriptors : (NSMutableArray *) elementFieldDescriptors
{
    for(FieldDescriptor* childFd in elementFieldDescriptors)
    {
        switch (childFd.type)
        {
            case SCALAR:
                [self writeValueAsLeaf:object andFieldDescriptor:childFd andString:outputString andContext : translationContext];
                break;
            case COMPOSITE_ELEMENT:
            {
                NSObject *compositeObject = [childFd getObject:object];
                if(compositeObject != nil)
                {
                    FieldDescriptor* compositeObjectFieldDescriptor = [childFd isPolymorphic] ? 
                                                                        [[ClassDescriptor classDescriptorWithObject:compositeObject] pseudoFieldDescriptor] 
                                                                        : childFd;
                    
                    [self writeWrap:childFd andString:outputString andClose:false];
                    [self serialize:compositeObject andFieldDescriptor:compositeObjectFieldDescriptor andString:outputString andContext:translationContext];
                    [self writeWrap:childFd andString:outputString andClose:true];
                }
                
            }   
                break;
            case COLLECTION_SCALAR:
            case MAP_SCALAR:
            {
                NSObject* scalarCollectionObject = [childFd getObject:object];
                NSArray* scalarCollection = [SimplTools getCollection : scalarCollectionObject];
                if(scalarCollection != nil && [scalarCollection count] > 0)
                {
                    [self writeWrap:childFd andString:outputString andClose:false];
                    for(NSObject* collectionScalar in scalarCollection)
                    {
                        [self writeScalarCollectionLeaf:collectionScalar andFieldDescriptor:childFd andString:outputString andContext: translationContext];
                    }
                    [self writeWrap:childFd andString:outputString andClose:true];
                }
            }
                break;
            case COLLECTION_ELEMENT:
            case MAP_ELEMENT:
            {
                NSObject* compositeCollectionObject = [childFd getObject:object];
                NSArray* compositeCollection = [SimplTools getCollection : compositeCollectionObject];
                if(compositeCollection != nil && [compositeCollection count] > 0)
                {
                    [self writeWrap:childFd andString:outputString andClose:false];
                    for(NSObject* collectionComposite in compositeCollection)
                    {
                        FieldDescriptor* compositeObjectFieldDescriptor = [childFd isPolymorphic] ? 
                        [[ClassDescriptor classDescriptorWithObject:collectionComposite] pseudoFieldDescriptor] 
                        : childFd;
                        [self serialize:collectionComposite andFieldDescriptor:compositeObjectFieldDescriptor andString:outputString andContext:translationContext];
                        
                        
                    }
                    [self writeWrap:childFd andString:outputString andClose:true];
                }
            }
                break;
            default:
                break;
        }
    }
    
}

- (void) writeSimplRef : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    [self writeObjectStart:fd andString:outputString];
    [self writeSimplRefAttribute:object andString:outputString andContext:translationContext];
    [self writeCompleteClose:outputString];
}

- (void) writeObjectStart : (FieldDescriptor *) fd andString: (NSMutableString *) outputString
{
    [outputString appendString: @"<"];
    [outputString appendString: [fd elementStart]];
}

- (void) writeObjectClose : (FieldDescriptor *) fd andString: (NSMutableString *) outputString
{
    [outputString appendString: @"<"];
    [outputString appendString: @"/"];
    [outputString appendString: [fd elementStart]];
    [outputString appendString: @">"];
}

- (void) writeCompleteClose : (NSMutableString *) outputString
{
    [outputString appendString: @"/"];
    [outputString appendString: @">"];
}

- (void) writeWrap : (FieldDescriptor *) fd andString: (NSMutableString *) outputString andClose : (bool) close
{
    if([fd isWrapped])
    {
        [outputString appendString: @"<"];
        if(close)
            [outputString appendString: @"/"];
        
        [outputString appendString: [fd tagName]];
        [outputString appendString: @">"];
    }
    
}

- (void) writeValueAsLeaf : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext
{
    if(![fd isDefaultValueFromContext: object])
    {
        
        [outputString appendString: @"<"];
        [outputString appendString: [fd elementStart]];
        [outputString appendString: @">"];
        
        [fd appendValue:outputString andObject:object];
        
        [outputString appendString: @"<"];
        [outputString appendString: @"/"];
        [outputString appendString: [fd elementStart]];
        [outputString appendString: @">"];
    }
}

- (void) writeScalarCollectionLeaf : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext
{
    if([fd isDefaultValue: [object description]])
    {        
        [outputString appendString: @"<"];
        [outputString appendString: [fd elementStart]];
        [outputString appendString: @">"];
        
        [fd appendCollectionScalarValue:outputString andObject:object];
        
        [outputString appendString: @"<"];
        [outputString appendString: @"/"];
        [outputString appendString: [fd elementStart]];
        [outputString appendString: @">"];
    }
}

- (void) writeValueAsText : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString
{
    if([fd isDefaultValueFromContext: object])
    {
        if([fd isCDATA])
            [outputString appendString: @ START_CDATA];
        [fd appendValue:outputString andObject:object];
        if([fd isCDATA])
            [outputString appendString: @END_CDATA];
    }
}

- (void) writeClose : (NSMutableString *) outputString
{
    [outputString appendString: @">"];
}

- (void) writeValueAsAtrribute : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    if (object != nil)
    {
        if(![fd isDefaultValueFromContext: object])
        {
            [outputString appendString: @" "];
            [outputString appendString: [fd tagName]];
            [outputString appendString: @"="];
            [outputString appendString: @"\""];
            [fd appendValue:outputString andObject:object];
            [outputString appendString: @"\""];
        }
    }    
}


- (void) writeSimplNameSpace : (NSMutableString *) outputString
{
    [outputString appendString: @SIMPL_NAMESPACE];
}

- (void) writeSimplRefAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    [outputString appendString: @" "];
    [outputString appendString: @SIMPL_REF];
    [outputString appendString: @"="];
    [outputString appendString: @"\""];
    [outputString appendString: [translationContext getSimplId:object]];
    [outputString appendString: @"\""];
}


- (void) writeSimplIdAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    [outputString appendString: @" "];
    [outputString appendString: @SIMPL_ID];
    [outputString appendString: @"="];
    [outputString appendString: @"\""];
    [outputString appendString: [translationContext getSimplId:object]];
    [outputString appendString: @"\""];
}


@end
