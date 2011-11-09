//
//  JsonSerializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/28/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "JsonSerializer.h"
#import "ClassDescriptor.h"
#import "FieldDescriptor.h"
#import "SimplTypesScope.h"
#import "FieldTypes.h"
#import "SimplTools.h"

//private methods and properties 
@interface JsonSerializer()


@property(nonatomic, readwrite) bool isRoot;


- (void) serialize : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) rootClassDescriptor andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext andWithTag: (bool) withTag;

- (void) serializeFields : (NSObject *) object andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext andFieldDescriptors : (NSMutableArray *) allFieldDescriptors;

- (void) serializeScalar : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) serializeComposite : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) serializeScalarCollection : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) serializePolymorphicCollection : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) serializeCompositeCollection : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;

- (void) writeSimplRef : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) writeObjectStart : (FieldDescriptor *) fd andString: (NSMutableString *) outputString;
- (void) writeObjectClose : (FieldDescriptor *) fd andString: (NSMutableString *) outputString;
- (void) writeCompleteClose : (NSMutableString *) outputString;
- (void) writeWrap : (FieldDescriptor *) fd andString: (NSMutableString *) outputString andClose : (bool) close;

- (void) writeScalarCollectionLeaf : (NSObject *) object andFieldDescriptor: (FieldDescriptor *) fd andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext;
- (void) writeStart : (NSMutableString *) outputString;
- (void) writeClose : (NSMutableString *) outputString;
- (void) writeCollectionEnd : (NSMutableString *) outputString;
- (void) writeCollectionStart : (FieldDescriptor *) fd andString : (NSMutableString *) outputString;
- (void) writeSimplRefAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;
- (void) writeSimplIdAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext;

+ (bool) isSerializable : (NSObject *) object andFieldDescriptor : (FieldDescriptor*) fd;

@end


//implementation of XmlSerializer public & private
@implementation JsonSerializer

@synthesize isRoot;

+ (id) jsonSerializer
{
    return [[[JsonSerializer alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

// public serialize method
- (void) serialize : (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext
{
    [translationContext resolveGraph:object];    
    ClassDescriptor *rootClassDescriptor = [ClassDescriptor classDescriptorWithObject: object];    
    
    [self writeStart : outputString];
    [self serialize:object andFieldDescriptor : [rootClassDescriptor pseudoFieldDescriptor] andString: outputString andContext: translationContext andWithTag:true];   
    [self writeClose: outputString];
}


//private methods 
- (void) serialize : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) rootFieldDescriptor andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext andWithTag: (bool) withTag
{
    if (object == nil)
        return;
    
    if ([self alreadySerialized : object andContext: translationContext])
    {
        [self writeSimplRef : object andFieldDescriptor: rootFieldDescriptor andString: outputString andContext: translationContext];
        return;
    }
    
    [translationContext mapObject:object];
    [self serializationPreHook : object andContext: translationContext];
    
    [self writeObjectStart:rootFieldDescriptor andString:outputString];
    
    ClassDescriptor* rootClassDescriptor = [ClassDescriptor classDescriptorWithObject:object];
    NSMutableArray* allFieldDescriptors = rootClassDescriptor.allFieldDescriptors;        
    [self serializeFields:object andString:outputString andContext:translationContext andFieldDescriptors:allFieldDescriptors];
    
    [self writeClose:outputString];
    
    [self serializationPostHook : object andContext: translationContext];   
}

- (void) serializeFields : (NSObject *) object andString: (NSMutableString *) outputString andContext : (TranslationContext *) translationContext andFieldDescriptors : (NSMutableArray *) allFieldDescriptors
{
    int numOfFields = 0;
    
    if([SimplTypesScope isGraphHandlingEnabled])
    {
        if ([translationContext needsHashCode:object])
        {
            [self writeSimplIdAttribute:object andString:outputString andContext:translationContext];
        }
    }
    
    for(FieldDescriptor* childFd in allFieldDescriptors)
    {        
        if([JsonSerializer isSerializable:object andFieldDescriptor:childFd])
        {
            if(numOfFields++ > 0)
                [outputString appendString:@","];
            
            switch (childFd.type)
            {
                case SCALAR:
                    [self serializeScalar : object andFieldDescriptor: childFd andString: outputString andContext: translationContext];
                    break;
                case COMPOSITE_ELEMENT:
                    [self serializeComposite : object andFieldDescriptor: childFd andString: outputString andContext: translationContext];
                    break;
                case COLLECTION_SCALAR:
                case MAP_SCALAR:
                    [self serializeScalarCollection : object andFieldDescriptor: childFd andString: outputString andContext: translationContext];         
                    break;
                case COLLECTION_ELEMENT:
                case MAP_ELEMENT:
                    if(childFd.isPolymorphic)
                        [self serializePolymorphicCollection : object andFieldDescriptor: childFd andString: outputString andContext: translationContext];
                    else
                        [self serializeCompositeCollection : object andFieldDescriptor: childFd andString: outputString andContext: translationContext];
                    break;
                default:
                    break;
            }

        }
    }    
}

- (void) serializeScalar : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    [outputString appendString: @"\""];
    [outputString appendString: [fd tagName]];
    [outputString appendString: @"\""];
    [outputString appendString: @":"];
    [outputString appendString: @"\""];

    [fd appendValue:outputString andObject:object];
    
    [outputString appendString: @"\""];

}

- (void) serializeComposite : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext 
{
    NSObject *compositeObject = [fd getObject:object];
    if(compositeObject != nil)
    {
        FieldDescriptor* compositeObjectFieldDescriptor = [fd isPolymorphic] ? 
        [[ClassDescriptor classDescriptorWithObject:compositeObject] pseudoFieldDescriptor] 
        : fd;
        
        [self serialize:compositeObject andFieldDescriptor:compositeObjectFieldDescriptor andString:outputString andContext:translationContext andWithTag:true];
    }

}

- (void) serializeScalarCollection : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext 
{
    //TODO: impelement this
}

- (void) serializePolymorphicCollection : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext 
{
    //TODO: impelement this
}

- (void) serializeCompositeCollection : (NSObject *) object andFieldDescriptor : (FieldDescriptor *) fd andString : (NSMutableString *) outputString andContext: (TranslationContext *) translationContext 
{
    NSObject* compositeCollectionObject = [fd getObject:object];
    NSArray* compositeCollection = [SimplTools getCollection : compositeCollectionObject];
    
    int numberOfItems = 0;
    
    [self writeWrap:fd andString:outputString andClose:false];
    [self writeCollectionStart: fd andString: outputString];   

    for(NSObject* collectionComposite in compositeCollection)
    {
        FieldDescriptor* compositeObjectFieldDescriptor = [fd isPolymorphic] ? 
            [[ClassDescriptor classDescriptorWithObject:collectionComposite] pseudoFieldDescriptor] 
            : fd;
        [self serialize:collectionComposite andFieldDescriptor:compositeObjectFieldDescriptor andString:outputString andContext:translationContext andWithTag:false];
        
        if (++numberOfItems < compositeCollection.count)
            [outputString appendString: @","];
            
            
    }
    [self writeCollectionEnd: outputString];
    [self writeWrap:fd andString:outputString andClose:false];
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

- (void) writeCollectionEnd : (NSMutableString *) outputString
{
    //TODO: implement this
}

- (void) writeCollectionStart : (FieldDescriptor *) fd andString : (NSMutableString *) outputString
{
    //TODO: impelement this
}

//TODO: fix me
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

//TODO: fix me
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

- (void) writeStart : (NSMutableString *) outputString
{
    [outputString appendString: @"{"];
}

- (void) writeClose : (NSMutableString *) outputString
{
    [outputString appendString: @"}"];
}


//TODO: fix me
- (void) writeSimplRefAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    [outputString appendString: @" "];
    [outputString appendString: @SIMPL_REF];
    [outputString appendString: @"="];
    [outputString appendString: @"\""];
    [outputString appendString: [translationContext getSimplId:object]];
    [outputString appendString: @"\""];
}

//TODO: fix me
- (void) writeSimplIdAttribute : (NSObject *) object andString: (NSMutableString *) outputString andContext: (TranslationContext *) translationContext
{
    [outputString appendString: @" "];
    [outputString appendString: @SIMPL_ID];
    [outputString appendString: @"="];
    [outputString appendString: @"\""];
    [outputString appendString: [translationContext getSimplId:object]];
    [outputString appendString: @"\""];
}

+ (bool) isSerializable : (NSObject *) object andFieldDescriptor : (FieldDescriptor*) fd
{
    //TODO: impelment logic
    return true;
}


@end
