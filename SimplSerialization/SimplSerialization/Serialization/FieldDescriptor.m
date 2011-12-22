//
//  FieldDescriptor.m
//  ecologylabXML
//
//  Created by Nabeel Shahzad on 1/5/10.
//  Copyright 2010 Interface Ecology Lab. All rights reserved.
//

#import "FieldDescriptor.h"
#import "ClassDescriptor.h"
#import "SimplDefs.h"

@implementation FieldDescriptor


@synthesize collectionOrMapTagName;
@synthesize tagClasses;
@synthesize declaringClassDescriptor;
@synthesize elementClassDescriptor;
@synthesize type;
@synthesize scalarType;
@synthesize enumeratedType;
@synthesize isCDATA;
@synthesize needsEscaping;
@synthesize isWrapped;
@synthesize xmlHint;
@synthesize wrapperFD;
@synthesize polymorphClassDescriptors;
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
														[NSNumber numberWithInt:XmlAttribute],
														[NSNumber numberWithInt:XmlLeaf],
														[NSNumber numberWithInt:XmlLeafCdata],
														[NSNumber numberWithInt:XmlText],
														[NSNumber numberWithInt:XmlTextCdata],
														[NSNumber numberWithInt:Undefined],
														nil];
		
		hints = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
		
		[hints retain];
	}
	
	return hints;
}

+ (int) hintFromValue : (NSString *) hintValue
{
    return [[[FieldDescriptor hintTypes] objectForKey:hintValue] intValue];
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
		self.scalarType = nil;
		self.isWrapped = NO;
	}
	return self;
}

- (id) getWrappedFieldDescriptor 
{
	return wrapperFD;
}

- (id) getChildClassDescriptor: (NSString *) tag
{
    ClassDescriptor* childClassDescriptor = ![self isPolymorphic] ? elementClassDescriptor : [polymorphClassDescriptors objectForKey: tag];    
    return childClassDescriptor;
}


- (bool) isDefaultValueFromContext : (NSObject *) object
{
    if(object != nil)
    {
        return [scalarType isDefaultValue:self andObject:object];
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


- (void) appendValue: (NSMutableString *) outputString andObject: (NSObject *) object
{
    [scalarType appendValue:outputString andFieldDescriptor:self andObject:object];
}

- (BOOL) isTagNameFromClassName 
{
	return tagClasses != nil;
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

- (NSObject *) getObject : (NSObject *) object
{
    return [object valueForKey:self.name];
}

- (BOOL) isPolymorphic 
{
	return polymorphClassDescriptors != nil;
}

- (id) automaticLazyGetCollectionOrMap: (NSObject *) object
{
	NSObject *collection = nil;

	collection = [object valueForKey:self.name];
	
	if (collection == nil)
	{
		collection = [[NSMutableArray array] retain];
		[object setValue:collection forKey:self.name];
	}
	
	return collection;
}

- (id) getMap: (NSObject *) object 
{
    NSObject *collection = nil;
    
	collection = [object valueForKey:self.name];
	
	if (collection == nil)
	{
		collection = [[NSMutableDictionary dictionary] retain];
		[object setValue:collection forKey:self.name];
	}
	
	return collection;
}

- (void) addLeafNodeToCollection: (NSObject *) object leafNodeValue: (NSString *) leafNodeValue
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
			NSMutableArray *collection = [self automaticLazyGetCollectionOrMap: object];
			[collection addObject: typeConvertedValue];
		}
	}
}

- (void) addTagClassDescriptor : (NSString*) tag tagClass :  (ClassDescriptor *) tagClassDescriptor 
{
	if(polymorphClassDescriptors == nil)
	{
		self.polymorphClassDescriptors = [NSMutableDictionary dictionary];
	}
	
	[polymorphClassDescriptors setObject:tagClassDescriptor forKey:tag];	
}

- (void) setFieldToNestedObject: (NSObject *) object andChildObject: (NSObject *) childObject 
{
    [object setValue:childObject forKey:self.name];
}

- (void) setFieldToScalar: (NSObject *) object andValue : (NSString *) value;
{
    [scalarType setField:object andFieldName:self.name andValue:value];
}

- (void) setField: (id) object value: (id) value 
{
    [scalarType setField:object andFieldName:self.name andValue:value];
}

- (void) appendCollectionScalarValue : (NSMutableString *) outputString andObject : (NSObject *) object
{
    [scalarType appendValue:outputString andValue:object];
}


@end