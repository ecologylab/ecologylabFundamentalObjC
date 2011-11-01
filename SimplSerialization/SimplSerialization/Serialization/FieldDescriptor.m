//
//  FieldDescriptor.m
//  ecologylabXML
//
//  Created by Nabeel Shahzad on 1/5/10.
//  Copyright 2010 Interface Ecology Lab. All rights reserved.
//

#import "FieldDescriptor.h"
#import "ClassDescriptor.h"
#import "ElementState.h"

@implementation FieldDescriptor

@synthesize field;
@synthesize elementClass;
@synthesize tagName;
@synthesize collectionOrMapTagName;
@synthesize otherTags;
@synthesize tagClasses;
@synthesize declaringClassDescriptor;
@synthesize type;
@synthesize scalarType;
@synthesize isCDATA;
@synthesize needsEscaping;
@synthesize isWrapped;
@synthesize xmlHint;
@synthesize wrapperFD;
@synthesize tagClassDescriptors;
@synthesize compositeTagName;

static NSDictionary *hints;

+ (NSDictionary *) hintTypes
{
	if(hints == nil)
	{
		NSArray *keyArray = [NSArray arrayWithObjects:	@"XML_ATTRIBUTE", 
														@"XML_LEAF", 
														@"XML_LEAF_CDATA", 
														@"XML_TEXT", 
														@"XML_TEXT_CDATA", 
														@"UNDEFINED", nil];
		
		NSArray *objectArray = [NSArray arrayWithObjects:
														[NSNumber numberWithInt:XML_ATTRIBUTE],
														[NSNumber numberWithInt:XML_LEAF],
														[NSNumber numberWithInt:XML_LEAF_CDATA],
														[NSNumber numberWithInt:XML_TEXT],
														[NSNumber numberWithInt:XML_TEXT_CDATA],
														[NSNumber numberWithInt:UNDEFINED],
														nil];
		
		hints = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
		
		[hints retain];
	}
	
	return hints;
}

+ (id) fieldDescriptor 
{
	return [[[FieldDescriptor alloc] init] autorelease];
}

+ (id) fieldDescritorWithClassDescriptor: (ClassDescriptor *) classDescriptor 
{
	return [[[FieldDescriptor alloc] initWithClassDescriptor: classDescriptor] autorelease];
}

- (id) init 
{
	if ( (self = [super init]) ) 
	{
		self.isWrapped = NO;
		self.tagClasses = nil; 
	}
	return self;
}

+ (id) fieldDescriptorWithTagName: (NSString *) elementName 
{
	return [[[FieldDescriptor alloc] initWithTagName: elementName] autorelease];
}

+ (id) fieldDescriptorWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag
{
	return [[[FieldDescriptor alloc] initWrapped: classDescriptor fieldDescriptor: fieldDescriptor wrapperTag: wrapperTag] autorelease];
}

+ (id) ignoredElementFieldDescriptor 
{
	return nil;
}

- (id) initWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag
{
	if ( (self = [super init]) ) 
	{
		self.declaringClassDescriptor = classDescriptor;
		self.wrapperFD = fieldDescriptor;
		self.type = WRAPPER;
		self.tagName = wrapperTag;
	}
	return self;
}

- (id) initWithTagName: (NSString *) elementName 
{
	if ( (self = [super init]) ) 
	{
		self.tagName = [NSString stringWithString: elementName];
		self.type = IGNORED_ELEMENT;
		self.field = nil;
		self.scalarType = nil;
		self.declaringClassDescriptor = nil;
		self.isWrapped = NO;
	}
	return self;
}

- (id) initWithClassDescriptor: (ClassDescriptor *) classDescriptor 
{
	if ( (self = [super init]) )
	{
		self.declaringClassDescriptor = classDescriptor;
		self.tagName = [NSString stringWithString:[classDescriptor tagName]];
		self.type = PSEUDO_FIELD_DESCRIPTOR;
		self.field = nil;
		self.scalarType = nil;
		self.isWrapped = NO;
	}
	return self;
}

- (id) getWrappedFieldDescriptor 
{
	return wrapperFD;
}

- (void) setTypeWithReference: (int *) t 
{
	self.type = *t;
}

- (void) setIsCDATAWithReference: (bool *) isCData
{
	self.isCDATA = *isCData;
}

- (void) setNeedsEscapingWithReference: (bool *) nEscaping 
{
	self.needsEscaping = *nEscaping;
}

- (void) setIsWrappedWithReference: (bool *) wrapped 
{
	self.isWrapped = *wrapped;
}

- (void) setXmlHintWithReference: (XMLHint *) p_xmlHint 
{
	self.xmlHint = *p_xmlHint;
}

- (void) writeElementStart: (NSMutableString *) output
{
	[output appendFormat: @"<%@", [self elementStart]];
}

- (void) appendValueAsAttribute: (NSMutableString *) output elementState: (ElementState *) elementState 
{
	if (elementState != nil) 
	{
		if (![scalarType isDefaultValue: self context: elementState]) 
		{
			[output appendFormat: @" %@=\"%", tagName];
			[scalarType appendValue: output fieldDescriptor: self context: elementState];
			[output appendString: @"\""];
		}
	}
}

- (bool) isDefaultValueFromContext : (NSObject *) object
{
    if(object != nil)
    {
        return [scalarType isDefaultValue: self context: object];
    }
    return false;
}

- (bool) isDefaultValue : (NSString *) value
{
    if(value != nil)
    {
        return [scalarType isDefaultValue: value];
    }
    return false;
}

- (void) appendLeaf: (NSMutableString *) output elementState: (ElementState *) elementState 
{
	if (elementState != nil)
	{
		if (![scalarType isDefaultValue: self context: elementState]) 
		{
			[self writeOpenTag: output];

			if (isCDATA)
				[output appendFormat: @"%@", START_CDATA];

			[scalarType appendValue: output fieldDescriptor: self context: elementState];

			if (isCDATA)
				[output appendFormat: @"%@", END_CDATA];

			[self writeCloseTag: output];
		}
	}
}

- (void) writeWrap: (NSMutableString *) output close: (BOOL) close 
{
	[output appendString: @"<"];
	if (close)
		[output appendString: @"/"];
	[output appendFormat: @"%@>", tagName];
}

- (void) appendCollectionLeaf: (NSMutableString *) output elementState: (NSObject *) instance 
{
	if (instance != nil) 
	{
		[self writeOpenTag: output];

		if (isCDATA)
			[output appendFormat: @"%@", START_CDATA];

		[scalarType appendValue: output context: instance];

		if (isCDATA)
			[output appendFormat: @"%@", END_CDATA];

		[self writeCloseTag: output];
	}
}

- (void) appendValue: (NSMutableString *) outputString andObject: (NSObject *) object
{
    [scalarType appendValue: outputString fieldDescriptor: self context: object];
}



- (BOOL) isTagNameFromClassName 
{
	return tagClasses != nil;
}

- (void) writeOpenTag: (NSMutableString *) output 
{
	[output appendFormat: @"<%@>", [self elementStart]];
}

- (void) writeCloseTag: (NSMutableString *) output 
{
	[output appendFormat: @"</%@>", [self elementStart]];
}

- (NSString *) elementStart
{
	return [self isCollection] ? collectionOrMapTagName : [self isNested] ? compositeTagName : tagName;
}

- (bool) isNested
{
    return type == COMPOSITE_ELEMENT;
}

- (BOOL) isCollection 
{
	switch (type)
	{
		case MAP_ELEMENT:
		case MAP_SCALAR:
		case COLLECTION_ELEMENT:
		case COLLECTION_SCALAR:
			return true;
		default:
			return false;
	}
}

- (Ivar) getField 
{
	return *field;
}

- (NSString *) getFieldName
{
	if (field == nil) 
		return nil;
	else
		return [NSString stringWithUTF8String : ivar_getName(*field)];
}

- (NSObject *) getObject : (NSObject *) object
{
    return [object valueForKey:[self getFieldName]];
}



- (ElementState *) constructChildElementState: (ElementState *) elementState tagName: (NSString *) elementName 
{
	
	ClassDescriptor *elementClassDescriptor = ![self isPolymorphic] ? [ClassDescriptor classDescriptor: *elementClass] : [tagClassDescriptors objectForKey:elementName];

	id result = [elementClassDescriptor getInstance];
	
	if (result != nil) 
	{
		[elementState setupChildElementState: result];
	}	
	
	return result;
}
		
- (BOOL) isPolymorphic 
{
	return tagClassDescriptors != nil;
}

- (id) automaticLazyGetCollectionOrMap: (ElementState *) elementState
{
	NSObject *collection = nil;

	collection = object_getIvar(elementState, *field);
	
	if (collection == nil)
	{
		collection = [[NSMutableArray array] retain];
		object_setIvar(elementState, *field, collection);
	}
	
	return collection;
}

- (id) getMap: (ElementState *) elementState 
{
	NSObject *collection = nil;
	
	collection = object_getIvar(elementState, *field);
	
	if (collection == nil)
	{
		collection = [[NSMutableDictionary dictionary] retain];
		object_setIvar(elementState, *field, collection);
	}
	
	return collection;
}

- (void) addLeafNodeToCollection: (ElementState *) elementState leafNodeValue: (NSString *) leafNodeValue
{
	if (leafNodeValue == nil)
	{
		//silently ignore leaf node values
	}
	else if (scalarType != nil)
	{
		id typeConvertedValue = [scalarType getValueFromString: leafNodeValue];
		if (typeConvertedValue != nil)
		{
			NSMutableArray *collection = [self automaticLazyGetCollectionOrMap: elementState];
			[collection addObject: typeConvertedValue];
		}
	}
}

- (void) addTagClass : (NSString*) name tagClass :  (Class *) tagClass 
{
	if(tagClasses == nil)
	{
		self.tagClasses = [NSMutableDictionary dictionary];
	}
	
	[tagClasses setObject:*tagClass forKey:name];
}

- (void) addTagClassDescriptor : (NSString*) name tagClass :  (ClassDescriptor *) tagClassDescriptor 
{
	if(tagClassDescriptors == nil)
	{
		self.tagClassDescriptors = [NSMutableDictionary dictionary];
	}
	
	[tagClassDescriptors setObject:tagClassDescriptor forKey:name];	
}

- (void) setFieldToNestedObject: (ElementState *) elementState childES: (ElementState *) childElementState 
{
	object_setIvar(elementState, *field, childElementState);
}

- (void) setField: (id) object value: (id) value 
{
	[scalarType setField: object fieldName:[self getFieldName] value: value];    
}

- (void) appendCollectionScalarValue : (NSMutableString *) outputString andObject : (NSObject *) object
{
    [scalarType appendValue:outputString context:object];
}


@end