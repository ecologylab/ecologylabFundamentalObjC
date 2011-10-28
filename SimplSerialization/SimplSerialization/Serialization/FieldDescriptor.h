/*!
	 @header	 FieldDescriptor.h
	 @abstract   This header file contains the definition of the field descriptor 
	 @discussion FieldDescriptor are the objects which describe each field. They are mapped with field names and 
				 XML tag names which helps in the serialization and deserialiazation and binds the objects to their XML representation. 
				 Field descriptors also holds the arrays and mappings of the field descriptors to their tag names which binds run-time objects
				 to their XML representation
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/

#import <stdio.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "Type.h"
#import "FieldTypes.h"

#define START_CDATA "<![CDATA["
#define END_CDATA	"]]>"

@class ClassDescriptor;
@class ElementState;

typedef enum hints
{
	XML_ATTRIBUTE = 0, 
	XML_LEAF = 1, 
	XML_LEAF_CDATA = 2, 
	XML_TEXT = 3, 
	XML_TEXT_CDATA = 4, 
	UNDEFINED = 5
} XMLHint;





/*!
	 @class		 FieldDescriptor	
	 @abstract   Class to hold relevant data structures and relevant 
				 functinality for a serializable field
	 @discussion FieldDescriptors defines the data strucutres and relevant functionality 
				 to perform serialization of a field. They also hold information about the field and its
				 declaring class descriptor.
*/
@interface FieldDescriptor : NSObject
{
	int					type;
	id <Type>			scalarType;
	bool				isCDATA;
	bool				needsEscaping;
	bool				isWrapped;	
	XMLHint				xmlHint;
	Ivar				*field;
	Class				*elementClass;	
	NSString			*tagName;
	NSMutableArray		*otherTags;	
	NSString			*collectionOrMapTagName;
	NSMutableDictionary *tagClassDescriptors;
	NSMutableDictionary *tagClasses;
	ClassDescriptor		*declaringClassDescriptor;
	FieldDescriptor		*wrapperFD; 
}

@property (nonatomic, readwrite)		 Ivar *field;
@property (nonatomic, readwrite)		 Class *elementClass;
@property (nonatomic, readwrite)		 int type;
@property (nonatomic, readwrite)		 bool isCDATA;
@property (nonatomic, readwrite)		 bool needsEscaping;
@property (nonatomic, readwrite)		 bool isWrapped;
@property (nonatomic, readwrite)		 XMLHint xmlHint;
@property (nonatomic, readwrite, retain) NSString *tagName;
@property (nonatomic, readwrite, retain) NSString *collectionOrMapTagName;
@property (nonatomic, readwrite, retain) NSMutableArray *otherTags;
@property (nonatomic, readwrite, retain) NSMutableDictionary *tagClasses;
@property (nonatomic, readwrite, retain) ClassDescriptor *declaringClassDescriptor;
@property (nonatomic, readwrite, retain) id <Type> scalarType;
@property (nonatomic, readwrite, retain) FieldDescriptor *wrapperFD;
@property (nonatomic, readwrite, retain) NSMutableDictionary *tagClassDescriptors;

#pragma mark FieldDescriptor - static accessors

+ (NSDictionary *) hintTypes;

/*!
	 @method     fieldDescriptor
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized FieldDescriptor
*/
+ (id) fieldDescriptor;

/*!
	 @method     fieldDescritorWithClassDescriptor
	 @abstract   A class level static method to initialize a FieldDescritpor.
	 @discussion Simple mehtod to initialize the Field descriptor from a declaring class descriptor
	 @param		 ClassDescriptor declaring class descriptor.
	 @result     initilized FieldDescriptor
*/
+ (id) fieldDescritorWithClassDescriptor: (ClassDescriptor *) classDescriptor;

/*!
	 @method     ignoredElementFieldDescriptor
	 @discussion initializes the fied descriptor for the ignored element.
	 @result     initilized FieldDescriptor
 */
+ (id) ignoredElementFieldDescriptor;

/*!
	 @method     fieldDescriptorWithTagName
	 @discussion static method to initialize the field descriptor with the tag name.
	 @result     initilized FieldDescriptor
 */
+ (id) fieldDescriptorWithTagName: (NSString *) elementName;

/*!
	 @method     fieldDescriptorWrapped
	 @discussion a field descriptor which holds the tag name for wrapped collections or maps 
	 @result     initilized FieldDescriptor
 */
+ (id) fieldDescriptorWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag;

#pragma mark FieldDescriptor - instance initializers 

/*!
	 @method     initWithClassDescriptor
	 @discussion An instance method to initialize the field descriptor from declaring class descriptor 
	 @result     initilized self FieldDescriptor
 */
- (id) initWithClassDescriptor: (ClassDescriptor *) classDescriptor;

/*!
	 @method     initWithTagName
	 @discussion Initializes the field descriptor from the tag name.  
	 @result     initilized self FieldDescriptor
 */
- (id) initWithTagName: (NSString *) elementName;

/*!
	 @method     initWrapped
	 @discussion Simple mehtod to initialize the class data structures. 
	 @param		 ClassDescriptor - declaring class descriptor
	 @param		 FieldDescriptor - wrapping field descriptor 
	 @param		 NSString wrapper tag name 
	 @result     initilized self FieldDescriptor
 */
- (id) initWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag;

/*!
	 @method     init
	 @discussion Initializes a FieldDescriptor with default values 
	 @result     initilized self FieldDescriptor
 */
- (id) init;

#pragma mark FieldDescriptor - instance methods

/*!
	 @method     getWrappedFieldDescriptor
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
*/
- (id) getWrappedFieldDescriptor;

/*!
	 @method     setTypeWithReference
	 @discussion Set the type of the field descriptor 
 	 @param		 - 
*/
- (void) setTypeWithReference: (int *) t;

/*!
	 @method     setIsCDATAWithReference
	 @discussion set the flag if the field descriptor is a CData
 	 @param		 - 
*/
- (void) setIsCDATAWithReference: (bool *) isCData;

/*!
	 @method     setNeedsEscapingWithReference
	 @discussion Set the flag if the serialized field descriptor needs escaping.
 	 @param		 - 
*/
- (void) setNeedsEscapingWithReference: (bool *) nEscaping;

/*!
	 @method     setIsWrappedWithReference
	 @discussion set the flag if the field is wrapped.
 	 @param		 - 
*/
- (void) setIsWrappedWithReference: (bool *) wrapped;

/*!
 @method     setIsWrappedWithReference
 @discussion set the flag if the field is wrapped.
 @param		 - 
 */
- (void) setXmlHintWithReference: (XMLHint *) p_xmlHint;

/*!
	 @method     writeElementStart
	 @discussion Write the start tag of the element to the output string. 
 	 @param		 - 
*/
- (void) writeElementStart: (NSMutableString *) output;

/*!
	 @method     appendValueAsAttribute
	 @discussion append the value of the field to the output string as an XML attribute.
 	 @param		 NSMutableString
 	 @param		 ElementSTate
*/
- (void) appendValueAsAttribute: (NSMutableString *) output elementState: (ElementState *) elementState;

/*!
	 @method     setFieldToNestedObject
	 @discussion -
 	 @param		 ElementState* 
 	 @param		 ElementSTate* 
*/
- (void) setFieldToNestedObject: (ElementState *) elementState childES: (ElementState *) childElementState;

/*!
	 @method     setField
	 @discussion -
 	 @param		 id 
 	 @param		 id
*/
- (void) setField: (id) object value: (id) value;

/*!
	 @method     constructChildElementState
	 @discussion -
	 @param		 ElementState
 	 @param		 NSString
	 @result	 ElementState
 */
- (ElementState *) constructChildElementState: (ElementState *) elementState tagName: (NSString *) elementName;

/*!
	 @method     appendLeaf
	 @discussion Simple mehtod to initialize the class data structures. 
	 @param		 NSMutableString 
 	 @param		 ElementState
*/
- (void) appendLeaf: (NSMutableString *) output elementState: (ElementState *) elementState;

/*!
	 @method     writeWrap
	 @discussion -
	 @param		 NSMutableString
 	 @param		 BOOL
*/
- (void) writeWrap: (NSMutableString *) output close: (BOOL) close;

/*!
	 @method     appendCollectionLeaf
	 @discussion -
	 @param		 NSMutableString
 	 @param		 NSObject
*/
- (void) appendCollectionLeaf: (NSMutableString *) output elementState: (NSObject *) instance;

/*!
	 @method     isTagNameFromClassName
	 @discussion To check if the tag name is derived from the class name. 
	 @result     BOOL
 */
- (BOOL) isTagNameFromClassName;

/*!
	 @method     elementStart
	 @discussion returns the tag of the element start 
	 @result     NSString 
 */
- (NSString *) elementStart;

/*!
	 @method     writeOpenTag
	 @discussion Appends the open tag of the field to the output
	 @param		 NSMutableString output
*/
- (void) writeOpenTag: (NSMutableString *) output;

/*!
	 @method     writeCloseTag
	 @discussion Simple mehtod to initialize the class data structures. 
	 @param		 NSMutableString
*/
- (void) writeCloseTag: (NSMutableString *) output;

/*!
	 @method     isCollection
	 @discussion Simple mehtod to initialize the class data structures
	 @result     BOOL
*/
- (BOOL) isCollection;

/*!
	 @method     isPolymorphic
	 @discussion Method to check if the described field is a 
	 @result     BOOL
*/
- (BOOL) isPolymorphic;

/*!
	 @method     addLeafNodeToCollection
	 @discussion -
	 @param		 ElementState
 	 @param		 NSString
*/
- (void) addLeafNodeToCollection: (ElementState *) elementState leafNodeValue: (NSString *) leafNodeValue;

/*!
	 @method     automaticLazyGetCollectionOrMap
	 @discussion -
 	 @param		 ElementState
	 @result     id
*/
- (id) automaticLazyGetCollectionOrMap: (ElementState *) elementState;

/*!
	 @method     getMap
	 @discussion -
 	 @param		 ElementState
	 @result     id
*/
- (id) getMap: (ElementState *) elementState;

/*!
	 @method     addTagClass
	 @discussion -
	 @param		 NSString
 	 @param		 Class*
*/
- (void) addTagClass : (NSString*) name tagClass :  (Class *) tagClass;

/*!
	 @method     addTagClassDescriptor
	 @discussion - 
	 @param		 NSString name
	 @param		 ClassDescriptor tagClassDescriptor
*/
- (void) addTagClassDescriptor : (NSString*) name tagClass :  (ClassDescriptor *) tagClassDescriptor; 

/*!
	 @method     getField
	 @discussion - 
	 @result     Ivar
*/
- (Ivar) getField;

/*!
	 @method     init
	 @discussion -
	 @result     NSString
*/
- (NSString *) getFieldName;



@end