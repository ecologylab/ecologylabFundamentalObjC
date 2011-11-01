/*!
	 @header	 ElementStateSAXHandler
	 @abstract   SAX handler to perform translate from XML operation for unmarshalling XML files.
	 @discussion Uses an objective-c internal SAX handler 
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/

#import <stdio.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "FieldDescriptor.h"
#import "ClassDescriptor.h"
#import "SimplTypesScope.h"
#import "ElementState.h"
#import "SimplTools.h"
#import "types.h"

/*!
 @class		 ElementStateSAXHandler	
 @abstract   -
 @discussion -
*/

@interface ElementStateSAXHandler : NSObject
{
	SimplTypesScope	*translationScope;
	ElementState		*root;
	ElementState		*currentElementState;
	FieldDescriptor		*currentFieldDescriptor;
	NSMutableArray		*fdStack;
	NSMutableString		*currentTextValue;
	BOOL				success;
}

/*!
	 @method     handlerWithTranslationScope
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
+ (id) handlerWithTranslationScope: (SimplTypesScope *) scope;

/*!
	 @method     initWithTranslationScope
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (id) initWithTranslationScope: (SimplTypesScope *) scope;

/*!
	 @method     currentClassDescriptor
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (id) currentClassDescriptor;

/*!
	 @method     parserDidStartDocument
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) parserDidStartDocument: (NSXMLParser *) parser;

/*!
	 @method     parser
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict;

/*!
	 @method     parser
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName;

/*!
	 @method     parser
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string;

/*!
	 @method     parser
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError;

/*!
	 @method     setRoot
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) setRoot: (ElementState *) newRoot;

/*!
	 @method     processPendingScalar
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) processPendingScalar: (int) type elementState: (ElementState *) elementState;

/*!
	 @method     pushFieldDescriptor
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) pushFieldDescriptor: (FieldDescriptor *) fieldDescriptor;

/*!
	 @method     popAndPeekFieldDescriptor
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (void) popAndPeekFieldDescriptor;

/*!
	 @method     parse
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (ElementState *) parse: (NSString *) pathToFile;

/*!
	 @method     parseData
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
- (ElementState *) parseData: (NSData *) data;

@end