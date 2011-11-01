//
//  XmlPullDeserializer.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "XmlPullDeserializer.h"
#import "ClassDescriptor.h"
#import "FieldDescriptor.h"

@interface XmlPullDeserializer() 

@property (nonatomic, readonly, assign) bool nextEvent;
@property (nonatomic, readonly, retain) NSString* currentTag;
@property (nonatomic, readonly, retain) NSString* simplReference;


- (NSObject *) parse;

- (void) createObjectModel : (NSObject *) root andClassDesciptor : (ClassDescriptor *) rootClassDescriptor andTag : (NSString *) rootTag; 
- (NSObject *) getSubRoot : (FieldDescriptor *) currentFieldDescriptor  andCurrentTag : (NSString *) currentTag andRootObject : (NSObject *) root;

- (void) skipTag : (NSString *) tagName;
- (void) deserializeCompositeMapElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeCompositeCollectionElement : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeScalarCollectionElement : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeCompositeCollection : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeCompositeMap : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeScalarCollection : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeComposite : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeScalar : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd;
- (void) deserializeAttributes : (NSObject *) object andClassDesciptor : (ClassDescriptor *) classDescriptor; 


@end

@implementation XmlPullDeserializer

@dynamic nextEvent;
@dynamic currentTag;
@dynamic simplReference;

- (NSObject *) parseString : (NSString *) inputString
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSObject *) parse
{
    NSObject *root; 
    
    bool isEof = self.nextEvent;
    if(isEof && xmlReader.nodeType != XML_ELEMENT_NODE)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"start of an element expected"]
                                     userInfo:nil];
    }

    NSString* rootTag = self.currentTag;
    
    ClassDescriptor* rootClassDescriptor = [simplTypesScope getClassDescriptorByTag : rootTag];
    
    if(rootClassDescriptor == nil)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"cannot find the class descriptor for root element <%@>; make sure if simplTypesScope is correct.", rootTag]
                                     userInfo:nil];
    }
    
    
    root = [rootClassDescriptor getInstance];
    
    [self deserializationPreHook:root andContext:translationContext];
    if(deserializationHookStrategy != nil)
    {
        [deserializationHookStrategy deserializationPreHook:root andFieldDescriptor:nil];
    }
    
    [self deserializeAttributes:root andClassDesciptor:rootClassDescriptor];
    [self createObjectModel:root andClassDesciptor:rootClassDescriptor andTag:rootTag];
    
    
    return root;
}


- (void) createObjectModel : (NSObject *) root andClassDesciptor : (ClassDescriptor *) rootClassDescriptor andTag : (NSString *) rootTag
{
    while(self.nextEvent && (xmlReader.nodeType != XML_ELEMENT_NODE || ![self.currentTag isEqualToString:rootTag]))
    {
        if(xmlReader.nodeType != XML_ELEMENT_NODE)
            continue;
        
        FieldDescriptor* currentFieldDescriptor = [rootClassDescriptor getFieldDescriptorByTag:self.currentTag scope:nil elementState:nil];
        
        if(currentFieldDescriptor == nil)
        {
            NSLog(@"ignoring tag %@", self.currentTag);
            
            if(!xmlReader.isEmptyElement)
            {
                [self skipTag:self.currentTag];
                continue;
            }            
        }
        
        switch (currentFieldDescriptor.type) 
        {
            case SCALAR:
                [self deserializeScalar:root andFieldDescriptor :currentFieldDescriptor];
                break;
            case COMPOSITE_ELEMENT:
                [self deserializeComposite:root andFieldDescriptor:currentFieldDescriptor];
                break;
            case COLLECTION_SCALAR:
                [self deserializeScalarCollectionElement:root andFieldDescriptor:currentFieldDescriptor];
                break;
            case COLLECTION_ELEMENT:
                [self deserializeCompositeCollectionElement:root andFieldDescriptor:currentFieldDescriptor];
                break;
            case MAP_ELEMENT:
                [self deserializeCompositeMapElement:root andFieldDescriptor:currentFieldDescriptor];
                break;
            case WRAPPER:
            {
                currentFieldDescriptor = currentFieldDescriptor.wrapperFD;
                switch (currentFieldDescriptor.type)
                {
                    case COLLECTION_SCALAR:
                        [self deserializeScalarCollection:root andFieldDescriptor:currentFieldDescriptor];
                        break;
                    case COLLECTION_ELEMENT:
                        [self deserializeCompositeCollection:root andFieldDescriptor:currentFieldDescriptor];
                        break;
                    case MAP_ELEMENT:
                        [self deserializeCompositeMap:root andFieldDescriptor:currentFieldDescriptor];
                        break;
                    case COMPOSITE_ELEMENT:
                        [self deserializeComposite:root andFieldDescriptor:currentFieldDescriptor];
                        break;                        
                    default:
                        break;
                }
            }
                break;                
            default:
                self.nextEvent;
                break;
        }
    }
}

- (NSObject *) getSubRoot : (FieldDescriptor *) currentFieldDescriptor  andCurrentTag : (NSString *) currentTag andRootObject : (NSObject *) root
{
    NSObject* subRoot = nil;
    ClassDescriptor* subRootClassDescriptor = [currentFieldDescriptor getChildClassDescriptor : currentTag];
    
    NSString* simplReference = self.simplReference;
    if ((simplReference != nil))
    {
        subRoot = [translationContext getFromMap : simplReference];
        return subRoot;
    }
    
    if(subRootClassDescriptor == nil)
    {
        NSLog(@"ignoring element: %@", self.currentTag);
        [self skipTag:self.currentTag];
        return nil;
    }
    
    subRoot = [subRootClassDescriptor getInstance];
    [self deserializeAttributes : subRoot andClassDesciptor: subRootClassDescriptor];
    
    if (!xmlReader.isEmptyElement)
        [self createObjectModel : subRoot andClassDesciptor:subRootClassDescriptor andTag:currentTag];
    
    return subRoot;
}

- (void) skipTag : (NSString *) tagName
{
    
}

- (void) deserializeCompositeMapElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeCompositeCollectionElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeScalarCollectionElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeCompositeCollection : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeCompositeMap : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeScalarCollection : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeComposite : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeScalar : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    
}

- (void) deserializeAttributes : (NSObject *) object andClassDesciptor : (ClassDescriptor *) classDescriptor;
{
    
}


- (bool) nextEvent
{
    return false;
}

- (NSString *) currentTag
{
    return nil;
}

- (NSString *) simplReference
{
    return nil;
}

@end
