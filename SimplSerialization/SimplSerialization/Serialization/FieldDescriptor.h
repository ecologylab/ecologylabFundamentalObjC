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

#import "FieldTypes.h"
#import "SimplDefs.h"
#import "DescriptorBase.h"
#import "ScalarType.h"
#import "CollectionType.h"



@class ClassDescriptor;

/*!
	 @class		 FieldDescriptor	
	 @abstract   Class to hold relevant data structures and relevant 
				 functinality for a serializable field
	 @discussion FieldDescriptors defines the data strucutres and relevant functionality 
				 to perform serialization of a field. They also hold information about the field and its
				 declaring class descriptor.
*/
@interface FieldDescriptor : DescriptorBase
{
	int					type;
	ScalarType			*scalarType;
	bool				isCDATA;
	bool				needsEscaping;
	bool				isWrapped;	
	XmlHint				xmlHint;
	
    NSString			*collectionOrMapTagName;
	NSMutableDictionary *polymorphClassDescriptors;
	NSMutableDictionary *tagClasses;
	ClassDescriptor		*declaringClassDescriptor;
	ClassDescriptor		*elementClassDescriptor;    
	FieldDescriptor		*wrapperFD; 
}

@property (nonatomic, readwrite)		 int type;
@property (nonatomic, readwrite)		 bool isCDATA;
@property (nonatomic, readwrite)		 bool needsEscaping;
@property (nonatomic, readwrite)		 bool isWrapped;
@property (nonatomic, readwrite)		 XmlHint xmlHint;
@property (nonatomic, readwrite, retain) NSString *collectionOrMapTagName;
@property (nonatomic, readwrite, retain) NSString *compositeTagName;
@property (nonatomic, readwrite, retain) NSMutableDictionary *tagClasses;
@property (nonatomic, readwrite, retain) ClassDescriptor *declaringClassDescriptor;
@property (nonatomic, readwrite, retain) ClassDescriptor *elementClassDescriptor;
@property (nonatomic, readwrite, retain) ScalarType *scalarType;
@property (nonatomic, readwrite, retain) FieldDescriptor *wrapperFD;
@property (nonatomic, readwrite, retain) NSMutableDictionary *polymorphClassDescriptors;


#pragma mark FieldDescriptor - static accessors

+ (NSDictionary *) hintTypes;

+ (int) hintFromValue : (NSString *) value;

+ (id) fieldDescriptor;

+ (id) fieldDescritorWithClassDescriptor: (ClassDescriptor *) classDescriptor;

+ (id) ignoredElementFieldDescriptor;

+ (id) fieldDescriptorWithTagName: (NSString *) elementName;

+ (id) fieldDescriptorWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag;

#pragma mark FieldDescriptor - instance initializers 

- (id) initWithClassDescriptor: (ClassDescriptor *) classDescriptor;

- (id) initWithTagName: (NSString *) elementName;

- (id) initWrapped: (ClassDescriptor *) classDescriptor fieldDescriptor: (FieldDescriptor *) fieldDescriptor wrapperTag: (NSString *) wrapperTag;

- (id) init;

#pragma mark FieldDescriptor - instance methods

- (id) getWrappedFieldDescriptor;

- (id) getChildClassDescriptor: (NSString *) tag;

- (void) setFieldToNestedObject: (NSObject *) object andChildObject: (NSObject *) childObject;

- (void) setFieldToScalar: (NSObject *) object andValue : (NSString *) value;

- (BOOL) isTagNameFromClassName;

- (NSString *) elementStart;

- (BOOL) isCollection;

- (BOOL) isPolymorphic;

- (void) addLeafNodeToCollection: (NSObject *) object leafNodeValue: (NSString *) leafNodeValue;

- (id) automaticLazyGetCollectionOrMap: (NSObject *) object;

- (id) getMap: (NSObject *) object;

- (void) addTagClassDescriptor : (NSString*) name tagClass :  (ClassDescriptor *) tagClassDescriptor; 

- (NSObject *) getObject : (NSObject *) object;

- (bool) isNested;

- (bool) isDefaultValueFromContext : (NSObject *) object;

- (bool) isDefaultValue : (NSString *) value;

- (void) appendCollectionScalarValue : (NSMutableString *) outputString andObject : (NSObject *) object;

- (void) appendValue: (NSMutableString *) outputString andObject: (NSObject *) object;

@end