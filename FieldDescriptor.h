/*!
	 @header	 FieldDescriptor
	 @abstract   This header file contains the definition of the field descriptor 
	 @discussion FieldDescriptor are the objects which are associated for each class. They are mapped with class names and 
				 XML tag names which helps in the serialization and deserialiazation and binds the objects to their XML represeantion. 
				 Class descriptors also holds the arrays and mappings of the field descriptors again completing the bindings of run-time
				 objects to their XML representation.
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */

#import <stdio.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "Type.h"
#import "fTypes.h"

#define START_CDATA "<![CDATA["
#define END_CDATA	"]]>"

@class ClassDescriptor;
@class ElementState;

/*!
	 @class		 FieldDescriptor	
	 @abstract   Class to hold relevant data structures and relevant 
				 functinality for a serializable class
	 @discussion ClassDescriptors defines the data strucutres and relevant functionality 
				 to perform serialization of a class. They also hold information about the class and its 
				 fields.
 */
@interface FieldDescriptor : NSObject
{
	int					type;
	id <Type>			scalarType;
	bool				isCDATA;
	bool				needsEscaping;
	bool				isWrapped;	
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
@property (nonatomic, readwrite, retain) NSString *tagName;
@property (nonatomic, readwrite, retain) NSString *collectionOrMapTagName;
@property (nonatomic, readwrite, retain) NSMutableArray *otherTags;
@property (nonatomic, readwrite, retain) NSMutableDictionary *tagClasses;
@property (nonatomic, readwrite, retain) ClassDescriptor *declaringClassDescriptor;
@property (nonatomic, readwrite, retain) id <Type> scalarType;
@property (nonatomic, readwrite, retain) FieldDescriptor *wrapperFD;
@property (nonatomic, readwrite, retain) NSMutableDictionary *tagClassDescriptors;

#pragma mark FieldDescriptor - static accessors

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
+ (id) fieldDescriptor;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
+ (id) fieldDescritorWithClassDescriptor: (ClassDescriptor *) classDescriptor;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
+ (id) ignoredElementFieldDescriptor;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
+ (id) fieldDescriptorWithTagName: (NSString *) elementName;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
+ (id) fieldDescriptorWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag;

#pragma mark FieldDescriptor - instance initializers 

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) initWithClassDescriptor: (ClassDescriptor *) classDescriptor;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) initWithTagName: (NSString *) elementName;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) initWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) init;

#pragma mark FieldDescriptor - instance methods

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) getWrappedFieldDescriptor;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) setTypeWithReference: (int *) t;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) setIsCDATAWithReference: (bool *) isCData;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) setNeedsEscapingWithReference: (bool *) nEscaping;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) setIsWrappedWithReference: (bool *) wrapped;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) writeElementStart: (NSMutableString *) output;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) appendValueAsAttribute: (NSMutableString *) output elementState: (ElementState *) elementState;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) setFieldToNestedObject: (ElementState *) elementState childES: (ElementState *) childElementState;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) setField: (id) object value: (id) value;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (ElementState *) constructChildElementState: (ElementState *) elementState tagName: (NSString *) elementName;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) appendLeaf: (NSMutableString *) output elementState: (ElementState *) elementState;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) writeWrap: (NSMutableString *) output close: (BOOL) close;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) appendCollectionLeaf: (NSMutableString *) output elementState: (NSObject *) instance;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (BOOL) isTagNameFromClassName;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (NSString *) elementStart;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) writeOpenTag: (NSMutableString *) output;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) writeCloseTag: (NSMutableString *) output;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (BOOL) isCollection;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (BOOL) isPolymorphic;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) addLeafNodeToCollection: (ElementState *) elementState leafNodeValue: (NSString *) leafNodeValue;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) automaticLazyGetCollectionOrMap: (ElementState *) elementState;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (id) getMap: (ElementState *) elementState;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) addTagClass : (NSString*) name tagClass :  (Class *) tagClass;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (void) addTagClassDescriptor : (NSString*) name tagClass :  (ClassDescriptor *) tagClassDescriptor; 

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (Ivar) getField;

/*!
	 @method     init
	 @abstract   An object level method to initialize a ClassDescriptor.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized self ClassDescriptor
 */
- (NSString *) getFieldName;



@end