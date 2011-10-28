//
//  ScalarType.m
//  ecologylabXML
//
//  Created by ecologylab on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScalarType.h"
#import "FieldDescriptor.h"
#import "DoubleType.h"
#import "FloatType.h"
#import "IntType.h"
#import "ByteType.h"
#import "LongType.h"
#import "BooleanType.h"


@implementation ScalarType

+ (void) initialize 
{
	[DoubleType class];	
	[FloatType class];
	[LongType class];
	[IntType class];
	[ByteType class];
	[BooleanType class];
}


#pragma mark AbstractScalarType - Default constructor cannot be called.

- (id) init 
{
	[self doesNotRecognizeSelector: _cmd];
	[self release];
	return nil;
}

#pragma mark AbstractScalarType - construction for the abstract class
- (id) initWithString: (NSString *) value 
{
	if ( (self = [super init]) ) 
	{		
		[self setInstance: value];
		[self setDefaultValue];
	}
	return self;
}

- (void) setField: (id) object fieldName: (const char *) fn 
{
	objc_msgSend(object, sel_getUid([XmlTools getSetterFunction: fn]), m_value);
}

- (void) setField: (id) object fieldName: (NSString *) fn value: (id) value 
{
	[self setInstance:[value description]];	
	objc_msgSend(object, sel_getUid([XmlTools getSetterFunction:[fn cStringUsingEncoding: NSASCIIStringEncoding]]), m_value);
}

- (void) appendValue: (NSMutableString *) buffy fieldDescriptor: (FieldDescriptor *) fd context: (id) context 
{
	id instance = [context valueForKey:[fd getFieldName]];
	[self appendValue: buffy context: instance];
}

- (void) appendValue: (NSMutableString *) buffy context: (id) instance 
{
	[buffy appendFormat:[instance description]];
}

- (BOOL) isDefaultValue: (FieldDescriptor *) fieldDescriptor context: (ElementState *) elementState 
{
	id instance = [elementState valueForKey:[fieldDescriptor getFieldName]];
	return instance == nil ||[[instance description] isEqualToString: DEFAULT_VALUE_STRING];
}

- (id) getValueFromString: (NSString *) value 
{
	[self setInstance: value];
	return m_value;
}

- (id) getInstance 
{
	return m_value;
}

#pragma mark AbstractScalarType - Abstract Functions (Inherting class must overload these functions)

- (void) setDefaultValue 
{
	[self doesNotRecognizeSelector: _cmd];
}

- (void) setInstance: (NSString *) value 
{
	[self doesNotRecognizeSelector: _cmd];
}

-(void) dealloc
{
	free(m_value);
	[DEFAULT_VALUE_STRING release];
	
	[super dealloc];
}

@end