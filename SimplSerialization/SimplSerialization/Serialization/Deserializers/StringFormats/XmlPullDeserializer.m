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
#import "Mappable.h"

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
- (void) deserializeAttributes : (NSObject *) root andClassDesciptor : (ClassDescriptor *) classDescriptor; 

@end

@implementation XmlPullDeserializer

@dynamic nextEvent;
@dynamic currentTag;
@dynamic simplReference;

- (void) dealloc
{
    [xmlReader dealloc];
    [super dealloc];
}

+ (id) xmlPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context
{
    return [[[XmlPullDeserializer alloc] initWithSimplTypesScope:scope andContext:context andStrategy:nil] autorelease];
}

+ (id) xmlPullDeserializer : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy
{
    return [[[XmlPullDeserializer alloc] initWithSimplTypesScope:scope andContext:context andStrategy:strategy] autorelease];
}

- (id) initWithSimplTypesScope : (SimplTypesScope *) scope andContext : (TranslationContext *) context andStrategy : (id<DeserializationHookStrategy>) strategy
{
    if(( self = [super initWithSimplTypesScope:scope andContext:context andStrategy:strategy]))
    {
        
    }
    return self;
}

- (NSObject *) parseString : (NSString *) inputString
{
    xmlReader = [XmlStreamReader xmlStreamReaderWithString: inputString];
    return [self parse];
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
    while(self.nextEvent && !(xmlReader.nodeType == XML_READER_TYPE_END_ELEMENT && [self.currentTag isEqualToString:rootTag]))
    {
        if(xmlReader.nodeType != XML_READER_TYPE_ELEMENT)
            continue;
        
        FieldDescriptor* currentFieldDescriptor = [rootClassDescriptor getFieldDescriptorByTag:self.currentTag];
        
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
                [self nextEvent];
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

- (void) deserializeCompositeMapElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    NSString* compositeTagName = self.currentTag;
    NSObject* subRoot = [self getSubRoot:fd andCurrentTag:compositeTagName andRootObject:root];
    if(subRoot != nil)
    {
        if([subRoot conformsToProtocol : @protocol(Mappable)])
        {
            id key = [(id<Mappable>) subRoot key];
            NSMutableDictionary *dictionary = [fd getMap : root];
            [dictionary setObject : subRoot forKey : key];
        }        
    }
}

- (void) deserializeCompositeCollectionElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    NSString* compositeTagName = self.currentTag;
    NSObject* subRoot = [self getSubRoot:fd andCurrentTag:compositeTagName andRootObject:root];
    if(subRoot != nil)
    {
        id collection = [fd automaticLazyGetCollectionOrMap:root];
        [collection addObject: subRoot];
    }
}

- (void) deserializeScalarCollectionElement : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    if (self.nextEvent && xmlReader.nodeType == XML_READER_TYPE_TEXT && xmlReader.nodeType != XML_READER_TYPE_END_ELEMENT)
    {
        NSString* value = xmlReader.readElementContentAsString;
        [fd addLeafNodeToCollection:root leafNodeValue:value];
    }
}

- (void) deserializeCompositeCollection : (NSObject *) root  andFieldDescriptor : (FieldDescriptor *) fd
{
    NSString* currentTag = self.currentTag;
    while (self.nextEvent && !(xmlReader.nodeType == XML_READER_TYPE_END_ELEMENT && [currentTag isEqualToString:currentTag]))
    {
        [self deserializeCompositeCollection:root andFieldDescriptor:fd];
    } 
}

- (void) deserializeCompositeMap : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    NSString* currentTag = self.currentTag;
    while (self.nextEvent && !(xmlReader.nodeType == XML_READER_TYPE_END_ELEMENT && [currentTag isEqualToString:currentTag]))
    {
        [self deserializeCompositeMap:root andFieldDescriptor:fd];
    } 
}

- (void) deserializeScalarCollection : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    NSString* currentTag = self.currentTag;
    while (self.nextEvent && !(xmlReader.nodeType == XML_READER_TYPE_END_ELEMENT && [currentTag isEqualToString:currentTag]))
    {
        [self deserializeScalarCollection:root andFieldDescriptor:fd];
    } 
}

- (void) deserializeComposite : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{
    NSObject* subRoot = [self getSubRoot:fd andCurrentTag:self.currentTag andRootObject:root];
    if(subRoot != nil)
        [fd setFieldToNestedObject:root andChildObject:subRoot];
}

- (void) deserializeScalar : (NSObject *) root andFieldDescriptor : (FieldDescriptor *) fd
{   
    NSString* value = [xmlReader readElementContentAsString];
    [fd setFieldToScalar:root andValue:value];
}

- (void) deserializeAttributes : (NSObject *) root andClassDesciptor : (ClassDescriptor *) classDescriptor;
{
    while (xmlReader.moveToNextAttribute)
    {
        NSString* tag = xmlReader.name;
        NSString* value = xmlReader.value;
        
        //silently ignore simpl namespace. 
        if ([tag isEqualToString:@SIMPL_NAMESPACE])continue;    
        
        if([tag isEqualToString:@SIMPL_ID])
        {
            [self.translationContext markAsUmarshalled:value andObject:root];
        }
        else
        {
            FieldDescriptor* attributeFieldDescriptor = [classDescriptor getFieldDescriptorByTag:tag];
            if (attributeFieldDescriptor != nil)
            {
                [attributeFieldDescriptor setFieldToScalar:root andValue:value];
            }
            else
            {
                NSLog(@"ignoring attribute: %@", tag);
            }   
        }
    }
    
    [xmlReader moveToElement];
}


- (bool) nextEvent
{
    bool returnValue;
    while ((returnValue = xmlReader.read) && (xmlReader.nodeType != XML_READER_TYPE_ELEMENT
                                          && xmlReader.nodeType != XML_READER_TYPE_END_ELEMENT
                                          && xmlReader.nodeType != XML_READER_TYPE_CDATA
                                          && xmlReader.nodeType != XML_READER_TYPE_TEXT));
    
    return returnValue;
    
}

- (NSString *) currentTag
{
    // what if namespace tag?
    return xmlReader.localName;
}

- (NSString *) simplReference
{
    NSString* simplReference = nil;
    while (xmlReader.moveToNextAttribute)
    {
        NSString* tag = xmlReader.name;
        NSString* value = xmlReader.value;
        
        if([@SIMPL_REF isEqualToString:tag])
        {
            simplReference = value;
        }
    }
    [xmlReader moveToElement];
    return simplReference;
}

- (void) skipTag : (NSString *) tagName
{
    NSMutableArray* startElement = [NSMutableArray array];
    [startElement addObject:tagName];
    while(self.nextEvent)
    {
        switch (xmlReader.nodeType) 
        {
            case XML_READER_TYPE_ELEMENT:
                if([self.currentTag isEqualToString:tagName])
                    [startElement addObject:tagName];
                break;
            case XML_READER_TYPE_END_ELEMENT:
                if([self.currentTag isEqualToString:tagName])
                    [startElement removeLastObject];                    
                break;       
            default:
                break;                
        }
        
        if(startElement.count <= 0)
            break;
    }
}

@end
