//
//  ElementStateSAXHandler.m
//  ecologylabXML
//
//  Created by Nabeel Shahzad on 1/14/10.
//  Copyright 2010 Interface Ecology Lab. All rights reserved.
//

#import "ElementStateSAXHandler.h"
#import "Mappable.h"

@implementation ElementStateSAXHandler

+ (id) handlerWithTranslationScope : (TranslationScope *) scope 
{
	return [[[ElementStateSAXHandler alloc] initWithTranslationScope: scope] autorelease];
}

- (id) initWithTranslationScope: (TranslationScope *) scope 
{
	if ( (self = [super init]) ) 
	{
		translationScope = [scope retain];
		fdStack = [[NSMutableArray array] retain];
		currentTextValue = [[NSMutableString string] retain];
	}

	return self;
}

- (ElementState *) parse: (NSString *) pathToFile 
{
	NSURL *xmlURL = [NSURL fileURLWithPath: pathToFile];
	NSXMLParser *addressParser = [[NSXMLParser alloc] initWithContentsOfURL: xmlURL];

	[addressParser setDelegate: self];
	[addressParser setShouldResolveExternalEntities: YES];

	success = [addressParser parse];
	[addressParser release];

	return root;
}

- (ElementState *) parseData: (NSData *) data
{
	NSXMLParser *addressParser = [[NSXMLParser alloc] initWithData:data ];
  
	[addressParser setDelegate: self];
	[addressParser setShouldResolveExternalEntities: YES];
  
	success = [addressParser parse];
	[addressParser release];
  
	return root;
}

- (void) parserDidEndDocument: (NSXMLParser *) parser
{
	[root deserializationPostHook];
}

- (void) parserDidStartDocument: (NSXMLParser *) parser
{
	
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict
{
	FieldDescriptor *activeFieldDescriptor = nil;
	BOOL isRoot = (root == nil);

	if (isRoot)
	{
		ClassDescriptor *rootClassDescriptor = [translationScope getClassDescriptorByTag: elementName];
		if (rootClassDescriptor != nil) 
		{
			ElementState *temp = [rootClassDescriptor getInstance];
			if (temp != nil) 
			{
				[temp setupRoot];
				[self setRoot: temp];
				[temp translateAttributes: translationScope withAttrib: attributeDict context: root];
				activeFieldDescriptor = [rootClassDescriptor pseudoFieldDescriptor];
			}
		}
	}
	else 
	{
		int currentType = currentFieldDescriptor.type;

		[self processPendingScalar: currentType elementState: currentElementState];
		ClassDescriptor *currentClassDescriptor = [self currentClassDescriptor];
		
		activeFieldDescriptor = (currentFieldDescriptor != nil) &&
		                        (currentType == IGNORED_ELEMENT) ? [FieldDescriptor ignoredElementFieldDescriptor] :
		                        (currentType == WRAPPER) ? [currentFieldDescriptor getWrappedFieldDescriptor] :
		                        [currentClassDescriptor getFieldDescriptorByTag: elementName scope: translationScope elementState: currentElementState];
		
		if (activeFieldDescriptor == nil) 
		{
			activeFieldDescriptor = [FieldDescriptor fieldDescriptorWithTagName: elementName];
			//[currentClassDescriptor addFieldDescriptorMapping: activeFieldDescriptor];
		}
	}

	currentFieldDescriptor = activeFieldDescriptor;
	//[self registerXMLNS];
	[self pushFieldDescriptor: activeFieldDescriptor];

	if (isRoot) return;

	ElementState *childElementState = nil;
	NSMutableArray *collection  = nil;
	NSMutableDictionary *map = nil;

	switch (activeFieldDescriptor.type)
	{
		case COMPOSITE_ELEMENT:
			childElementState = [activeFieldDescriptor constructChildElementState: currentElementState tagName: elementName];
			[activeFieldDescriptor setFieldToNestedObject: currentElementState childES: childElementState];
		break;

		case SCALAR:
			break;

		case COLLECTION_ELEMENT:
			collection = [activeFieldDescriptor automaticLazyGetCollectionOrMap: currentElementState];
			if (collection != nil) 
			{
				childElementState = [activeFieldDescriptor constructChildElementState: currentElementState tagName: elementName];
				[collection addObject: childElementState];
			}
		break;

		case COLLECTION_SCALAR:
			break;

		case MAP_ELEMENT:
			map = [activeFieldDescriptor getMap: currentElementState];
			if (map != nil) 
			{
				childElementState = [activeFieldDescriptor constructChildElementState: currentElementState tagName: elementName];
			}
		break;
		case IGNORED_ELEMENT:
		case BAD_FIELD:
		case WRAPPER:
		default:
			break;
	}

	if (childElementState != nil) 
	{
		[childElementState translateAttributes: translationScope withAttrib: attributeDict context: currentElementState];
		currentElementState = childElementState;
		currentFieldDescriptor = activeFieldDescriptor;
	}
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName 
{
	int currentFdType = currentFieldDescriptor.type;
	[self processPendingScalar: currentFdType elementState: currentElementState];
	ElementState *parentElementState = [currentElementState parent];

	switch (currentFdType)
	{
		case MAP_ELEMENT:
			if([currentElementState conformsToProtocol : @protocol(Mappable)])
			{
				id key = [(id<Mappable>) currentElementState key];
				NSMutableDictionary *dictionary = [currentFieldDescriptor getMap : parentElementState];
				[dictionary setObject : currentElementState forKey : key];
			}
		case COMPOSITE_ELEMENT:
		case COLLECTION_ELEMENT:
			if (parentElementState != nil)
			{
				[parentElementState createChildHook:currentElementState];
			}
			[currentElementState deserializationPostHook];
			currentElementState     = parentElementState;
			break;

		default:
			break;
	}
	
	[self popAndPeekFieldDescriptor];
}

- (void) setRoot: (ElementState *) newRoot 
{
	root = newRoot;
	currentElementState = root;
}

- (void) processPendingScalar: (int) type elementState: (ElementState *) elementState
{
	int length = [currentTextValue length];
	NSString *value = nil;
	if (length > 0) 
	{
		switch (type)
		{
			//case NAME_SPACE_LEAF_NODE:
			case SCALAR:
				value = [NSString stringWithString:[currentTextValue substringWithRange: NSMakeRange(0, length)]];
				[currentFieldDescriptor setField: elementState value: value];
				break;

			case COLLECTION_SCALAR:
				value = [NSString stringWithString:[currentTextValue substringWithRange: NSMakeRange(0, length)]];
				[currentFieldDescriptor addLeafNodeToCollection: elementState leafNodeValue: value];
				break;
			case COMPOSITE_ELEMENT:
			case COLLECTION_ELEMENT:
				break;

			default:
				break;
		}
		[currentTextValue deleteCharactersInRange: NSMakeRange(0, [currentTextValue length])];
	}
}

- (id) currentClassDescriptor 
{
	return [currentElementState classDescriptor];
}

- (void) pushFieldDescriptor: (FieldDescriptor *) fieldDescriptor
{
	[fdStack addObject: fieldDescriptor];
}

- (void) popAndPeekFieldDescriptor
{
	int last = [fdStack count] - 1;
	if (last >= 0) 
	{
		FieldDescriptor *result = [fdStack objectAtIndex: last];
		[fdStack removeObjectAtIndex: last--];
		if (last >= 0)
		{
			result = [fdStack objectAtIndex: last];
		}
		currentFieldDescriptor = result;
	}
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string 
{
	if (currentFieldDescriptor != nil)
	{
		switch (currentFieldDescriptor.type)
		{
			case SCALAR:
			case COLLECTION_SCALAR:
				[currentTextValue appendString: string];
				break;
			default:
				break;
		}
	}
}

- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError 
{
	
}

-(void) dealloc
{
	[fdStack release];
	fdStack = nil;
	
	[translationScope release];
	translationScope = nil;
	
	[currentTextValue release];
	currentTextValue = nil;
	
	[super dealloc];
}

@end