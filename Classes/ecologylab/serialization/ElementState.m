//
//  ElementState.m
//  ecologylabXML
//
//  Created by Nabeel Shahzad on 1/5/10.
//  Copyright 2010 Interface Ecology Lab. All rights reserved.
//

#import "ElementState.h"
#import "FieldDescriptor.h"
#import "ClassDescriptor.h"
#import "TranslationScope.h"
#import "ElementStateSAXHandler.h"

@implementation ElementState

@synthesize parent;
@synthesize elementById;
@synthesize classDescriptor;


- (ClassDescriptor *) classDescriptor
{
	if (classDescriptor == nil)
		return self.classDescriptor = [ClassDescriptor classDescriptor:[self class]];
	else
		return classDescriptor;
}

- (ElementState *) parent 
{
	return parent;
}

- (void) serialize: (NSMutableString *) output 
{
	[self serialize: output fieldDescriptor:[[self classDescriptor] pseudoFieldDescriptor]];
}

- (void) serialize: (NSMutableString *) output fieldDescriptor: (FieldDescriptor *) fieldDescriptor
{
	[fieldDescriptor writeElementStart: output];

	NSMutableArray *attributeFieldDescriptors = [[self classDescriptor] attributeFieldDescriptors];
	int numbAttributes = attributeFieldDescriptors.count;

	if (numbAttributes > 0) 
	{
		for (int i = 0; i < numbAttributes; i++) 
		{			
			FieldDescriptor *childFd = [attributeFieldDescriptors objectAtIndex: i];
			[childFd appendValueAsAttribute: output elementState: self];
		}
	}

	NSMutableArray *elementFieldDescriptors = [classDescriptor elementFieldDescriptors];
	int numElements = elementFieldDescriptors.count;

	if (numElements == 0) 
	{
		[output appendString: @"/>"];
	}
	else {
		[output appendString: @">"];

		//if(textNode != nil){
		//TODO : escape xml
		//[XMLTools escapeXML : output textNode : textNode];
		//}

		for (int i = 0; i < numElements; i++) 
		{
			FieldDescriptor *childFd = [elementFieldDescriptors objectAtIndex: i];

			if (childFd.type == SCALAR)
			{
				[childFd appendLeaf: output elementState: self];
			}
			else 
			{
				id thatReferenceObject = [self valueForKey:[childFd getFieldName]];
				if (thatReferenceObject == nil) continue;

				BOOL isScalar = (childFd.type == COLLECTION_SCALAR) || (childFd.type == MAP_SCALAR);
				id thatCollection = nil;

				switch (childFd.type)
				{
					case COLLECTION_ELEMENT:
					case COLLECTION_SCALAR:
					case MAP_ELEMENT:
					case MAP_SCALAR:
						thatCollection = thatReferenceObject;
						break;

					default:
						thatCollection = nil;
						break;
				}

				if (thatCollection != nil &&[thatCollection count] > 0) 
				{
					if ([childFd isWrapped])
					{
						[childFd writeWrap: output close: NO];
					}

					for (id next in thatCollection) 
					{
						if (isScalar) 
						{
							[childFd appendCollectionLeaf: output elementState: next];
						}
						else if ([next isKindOfClass:[ElementState class]])
						{
							FieldDescriptor *collectionElementFD = [childFd isPolymorphic] ? [[next classDescriptor] pseudoFieldDescriptor] : childFd;
							[next serialize: output fieldDescriptor: collectionElementFD];
						}
					}

					if ([childFd isWrapped]) 
					{
						[childFd writeWrap: output close: YES];
					}
				}
				else if ([thatReferenceObject isKindOfClass:[ElementState class]]) 
				{
					FieldDescriptor *nestedElementFD = [childFd isPolymorphic] ? [[thatReferenceObject classDescriptor] pseudoFieldDescriptor] : childFd;
					[thatReferenceObject serialize: output fieldDescriptor: nestedElementFD];
				}
			}
		}

		[fieldDescriptor writeCloseTag: output];
	}
}


- (void) setupRoot 
{
	elementById = [NSMutableDictionary dictionary];
}

- (void) setupChildElementState: (ElementState *) childElementState 
{
	[childElementState setElementById: elementById];
	[childElementState setParent: self];
	[childElementState setClassDescriptor:[ClassDescriptor classDescriptor:[childElementState class]]];
}

- (void) translateAttributes: (TranslationScope *) translationScope withAttrib: (NSDictionary *) attributes context: (ElementState *) context 
{
	int numAttributes = [attributes count];

	for (int i = 0; i < numAttributes; i++) 
	{
		id key = [[attributes allKeys] objectAtIndex: i];
		id value = [[attributes allValues] objectAtIndex: i];
		
		FieldDescriptor *fd = [[self classDescriptor] getFieldDescriptorByTag: key scope: translationScope elementState: context];

		switch (fd.type)
		{
			case SCALAR:
				[[fd scalarType] setField: self fieldName:[fd getFieldName] value: value];
				if ([[NSString stringWithString: @"id"] isEqualToString: fd.tagName]) 
				{
					[elementById setValue: value forKey: key];
				}
			break;
			default:
				break;
		}
	}
}

- (void) deserializationPostHook
{
	
}

@end