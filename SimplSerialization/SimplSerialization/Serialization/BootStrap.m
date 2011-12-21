//
//  BootStrap.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/2/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "BootStrap.h"
#import "XmlStreamReader.h"
#import "TranslationContext.h"
#import "BootstrapConstants.h"
#import "TypeRegistry.h"

static XmlStreamReader* xmlStreamReader;

@interface BootStrap()

//state machine methods
+ (SimplTypesScope *) deserializeSimplTypesScope;
+ (ClassDescriptor *) deserializeClassDescriptor : (NSString *) classDescriptorTag andContext: (TranslationContext *) translationContext;
+ (FieldDescriptor *) deserializeFieldDescriptor : (NSString *) fieldDescriptorTag andContext: (TranslationContext *) translationContext;

//convineince methods
+ (void)deserializeClassDescriptorAttribute:(NSString *)value classDescriptor:(ClassDescriptor *)classDescriptor tag:(NSString *)tag translationContext:(TranslationContext *)translationContext;
+ (void)deserializeFieldDescriptorAttribute:(NSString *)value fieldDescriptor:(FieldDescriptor *)fieldDescriptor tag:(NSString *)tag translationContext: (TranslationContext *) translationContext;

@end

@implementation BootStrap


+ (SimplTypesScope *) deserializeSimplTypesFromFile: (NSString *) filePath
{
    xmlStreamReader = [XmlStreamReader xmlStreamReaderWithFilePath:filePath];
    SimplTypesScope* simplScope = [BootStrap deserializeSimplTypesScope];
    [xmlStreamReader close];
    [xmlStreamReader release];    
    return simplScope;
}


+ (SimplTypesScope *) deserializeSimplTypesScope
{
    SimplTypesScope *scope = [[[SimplTypesScope alloc]init] autorelease];
    TranslationContext *translationContext = [TranslationContext translationContext];
    
    while(xmlStreamReader.read)
    {
        if(xmlStreamReader.nodeType == XML_READER_TYPE_ELEMENT)
        {            
            NSString* tagName = xmlStreamReader.name;            

            if([tagName isEqualToString:SIMPL_TYPES_SCOPE])
            {
                while(xmlStreamReader.moveToNextAttribute)
                {
                    NSString* tag   = xmlStreamReader.name;
                    NSString* value = xmlStreamReader.value;
                    
                    if([tag isEqualToString:SIMPL_TYPES_SCOPE_NAME])
                    {
                        scope.name = value;
                    }
                }
                continue;
            }
            
            if([tagName isEqualToString:CLASS_DESCRIPTOR])
            {
                ClassDescriptor* entry = [BootStrap deserializeClassDescriptor:tagName andContext:translationContext];
                [scope mapTagToClassDescriptor:entry.tagName andClassDescriptor:entry];
            }            
        }        
    }
    
    return scope;
}

+ (ClassDescriptor *) deserializeClassDescriptor: (NSString *) classDescriptorTag andContext: (TranslationContext *) translationContext
{
    ClassDescriptor* classDescriptor = [[[ClassDescriptor alloc] init] autorelease];
    
    // deserialize attributes
    while(xmlStreamReader.moveToNextAttribute)
    {
        NSString* tag   = xmlStreamReader.name;
        NSString* value = xmlStreamReader.value;
        
        // if already deserialized, return the instance from translation context
        if([tag isEqualToString:@SIMPL_REF])
        {
            classDescriptor =  (ClassDescriptor *) [translationContext getFromMap:value];
            return classDescriptor;
        }
        
        [self deserializeClassDescriptorAttribute:value classDescriptor:classDescriptor tag:tag translationContext:translationContext];                
    }
    
    // deserialize elements
    do 
    {
        if(xmlStreamReader.nodeType == XML_READER_TYPE_ELEMENT)
        {            
            NSString* tagName = xmlStreamReader.name;            
            
            if([tagName isEqualToString:FIELD_DESCRIPTOR])
            {
                FieldDescriptor* entry = [self deserializeFieldDescriptor:tagName andContext:translationContext];                  
                [classDescriptor addFieldDescriptor:entry];
            }
        }    
    }
    while(xmlStreamReader.read && !(xmlStreamReader.nodeType == XML_READER_TYPE_END_ELEMENT && [xmlStreamReader.name isEqualToString:classDescriptorTag]));
    
    [[ClassDescriptor globalClassDescriptorsMap] setObject:classDescriptor forKey:[SimplTools getClassSimpleName: classDescriptor.name]];
    return classDescriptor;
}


+ (FieldDescriptor *) deserializeFieldDescriptor: (NSString *) fieldDescriptorTag andContext: (TranslationContext *) translationContext
{       
    FieldDescriptor* fieldDescriptor = [[[FieldDescriptor alloc] init] autorelease];
    
    // deserialize attributes
    while(xmlStreamReader.moveToNextAttribute)
    {
        NSString* tag   = xmlStreamReader.name;
        NSString* value = xmlStreamReader.value;
        
        // if already deserialized, return the instance from translation context
        if([tag isEqualToString:@SIMPL_REF])
        {
            fieldDescriptor =  (FieldDescriptor *) [translationContext getFromMap:value];
            return fieldDescriptor;
        }

        
        [self deserializeFieldDescriptorAttribute:value fieldDescriptor:fieldDescriptor tag:tag translationContext:translationContext];  
    }    
    
    // deserialize elements
    do
    {
        if(xmlStreamReader.nodeType == XML_READER_TYPE_ELEMENT)
        {            
            NSString* tagName = xmlStreamReader.name;            
            
            
            // nested types in FieldDescriptor
            if([tagName isEqualToString:ELEMENT_CLASSDESCRIPTOR])
            {
                ClassDescriptor* elementClassDescriptor = [BootStrap deserializeClassDescriptor:tagName andContext:translationContext];
                fieldDescriptor.elementClassDescriptor = elementClassDescriptor;        
                continue;
            }
            
            if([tagName isEqualToString:DECLARING_CLASSDESCRIPTOR])
            {
                ClassDescriptor* declaringClassDescriptor = [BootStrap deserializeClassDescriptor:tagName andContext:translationContext];
                fieldDescriptor.declaringClassDescriptor = declaringClassDescriptor;
                continue;
            }
            
            if([tagName isEqualToString:COLLECTION_TYPE])
            {
                [xmlStreamReader skipCurrentTag];
                continue;
            }            
        }    
    }
    while(xmlStreamReader.read && !(xmlStreamReader.nodeType == XML_READER_TYPE_END_ELEMENT && [xmlStreamReader.name isEqualToString:fieldDescriptorTag]));
    
    return fieldDescriptor;
}

// convinience method for creating the correct field related to an attribute
+ (void)deserializeClassDescriptorAttribute:(NSString *)value classDescriptor:(ClassDescriptor *)classDescriptor tag:(NSString *)tag translationContext:(TranslationContext *)translationContext
{
    if([tag isEqualToString:CLASS_DESCRIPTOR_NAME])
    {
        classDescriptor.name = value;
    }
    else
    if([tag isEqualToString:CLASS_DESCRIPTOR_TAG_NAME])
    {
        classDescriptor.tagName = value;    }
    else
    if([tag isEqualToString:CLASS_DESCRIPTOR_DESCRIBED_SIMPLE_NAME])
    {
        classDescriptor.decribedClassSimpleName = value;    }
    else
    if([tag isEqualToString:CLASS_DESCRIPTOR_DESCRIBED_PACKAGE_NAME])
    {
        classDescriptor.describedClassPackageName = value;    }
    else
    if([tag isEqualToString:@SIMPL_ID])
    {
        [translationContext markAsUmarshalled:value andObject:classDescriptor];
    }
}

// convinience method for creating the correct field related to an attribute
+ (void)deserializeFieldDescriptorAttribute:(NSString *)value fieldDescriptor:(FieldDescriptor *)fieldDescriptor tag:(NSString *)tag translationContext: (TranslationContext *) translationContext
{
    if([tag isEqualToString:@"name"])
    {
        fieldDescriptor.name = value;
    }   
    else
    if([tag isEqualToString:@"tag_name"])
    {
        fieldDescriptor.tagName = value;
    }  
    else
    if([tag isEqualToString:@"field"])
    {
       // we don't need this
    }  
    else
    if([tag isEqualToString:@"scalar_type"])
    {
        fieldDescriptor.scalarType = [TypeRegistry scalarTypeFromName:value];        
    } 
    else
    if([tag isEqualToString:@"collection_type"])
    {
        //fieldDescriptor.collectionType = [TypeRegistry collectionTypeFromName:value];        
    } 
    else
    if([tag isEqualToString:@"type"])
    {
        fieldDescriptor.type = [value intValue];    } 
    else
    if([tag isEqualToString:@"xml_hint"])
    {
        fieldDescriptor.xmlHint = [FieldDescriptor hintFromValue : value];        
    } 
    else
    if([tag isEqualToString:@"needs_escaping"])
    {
        fieldDescriptor.needsEscaping = [value boolValue];
    } 
    else
    if([tag isEqualToString:@"field_type"])
    {
        // we don't need this either. 
    } 
    else
    if([tag isEqualToString:@"composite_tag_name"])
    {
        fieldDescriptor.compositeTagName = value;    } 
    else
    if([tag isEqualToString:@"collection_or_map_tag_name"])
    {
        fieldDescriptor.collectionOrMapTagName = value;
    }
    if([tag isEqualToString:@SIMPL_ID])
    {
        [translationContext markAsUmarshalled:value andObject:fieldDescriptor];
    }
}

@end
