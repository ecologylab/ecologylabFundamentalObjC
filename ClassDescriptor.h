/*!
    @header		ClassDescriptor.h
    @abstract   This header file contains the definition of the class descriptor 
    @discussion ClassDescriptors are the objects which are associated for each class. They are mapped with class names and 
				XML tag names which helps in the serialization and deserialiazation and binds the objects to their XML represeantion. 
				Class descriptors also holds the arrays and mappings of the field descriptors again completing the bindings of run-time
				objects to their XML representation.
	@updated    05/24/10
	@created	01/05/10
	@author		Nabeel Shahzad
 	@copyright  Interface Ecology Lab
*/

#import <stdio.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "DictionaryList.h"
#import "XMLTools.h"

@class TranslationScope;
@class FieldDescriptor;

/*!
    @class		 ClassDescriptor	
    @abstract    Class to hold relevant data structures and relevant 
				 functinality for a serializable class
    @discussion  ClassDescriptors defines the data strucutres and relevant functionality 
				 to perform serialization of a class. They also hold information about the class and its 
				 fields.
*/
@interface ClassDescriptor : NSObject
{
	Class				 *describedClass;
	NSString			 *tagName;
	NSString			 *decribedClassSimpleName;
	NSString			 *describedClassPackageName;
	NSMutableArray		 *attributeFieldDescriptors;
	NSMutableArray		 *elementFieldDescriptors;
	DictionaryList		 *fieldDescriptorsByFieldName;
	FieldDescriptor		 *pseudoFieldDescriptor;
	NSMutableDictionary  *allFieldDescriptorsByTagNames; 
}

//Proporties.
//TODO : some properties are read only. Need to fix this. 
@property (nonatomic, readwrite)		 Class				*describedClass;
@property (nonatomic, readwrite, retain) NSString			*tagName;
@property (nonatomic, readwrite, retain) NSString			*decribedClassSimpleName;
@property (nonatomic, readwrite, retain) NSString			*describedClassPackageName;
@property (nonatomic, readwrite, retain) NSDictionary		*allFieldDescriptorsByTagNames;
@property (nonatomic, readwrite, retain) NSMutableArray		*attributeFieldDescriptors;
@property (nonatomic, readwrite, retain) NSMutableArray		*elementFieldDescriptors;
@property (nonatomic, readwrite, retain) DictionaryList		*fieldDescriptorsByFieldName;
@property (nonatomic, readwrite, retain) FieldDescriptor	*pseudoFieldDescriptor;

#pragma mark ClassDescriptor - class initializer

/*!
	@method     classDescriptor
	@abstract   Static method to initialize a ClassDescriptor
	@discussion A static method which initializes a class descriptor. This static methods
				creates an autoreleased object of the class descriptor. Internally it calls
				an the init mehtod which initializes basic data strucutures of the class descriptor
	@result		returns an initialized ClassDescritor object
*/
+ (id) classDescriptor;

#pragma mark ClassDescriptor - instance functions

/*!
	@method     init
	@abstract   An object level method to initialize a ClassDescriptor.
	@discussion Simple mehtod to initialize the class data structures. 
	@result     initilized self ClassDescriptor
*/
- (id) init;

/*!
	@method     getInstance
	@abstract   Gets the instance of the class defined by the class descriptor.
	@discussion This methods uses reflection methods in the XMLTools.h file to create an instance of the 
				class described by this class descriptor.
	@result		A run-time created object. 
 */
- (id) getInstance;

/*!
	@method     addFieldDescriptor
	@abstract   Adds the field descriptor to the internal mapping data strcutres of the field descriptors.
	@discussion Adds the field descriptor to attribute/element field descriptors based on the type of the field 
				descriptor and also adds it to the static global field descriptor mapping.
	@param		FieldDescriptor fd to be added to the mappings.
 */
- (void) addFieldDescriptor: (FieldDescriptor *) fd;

/*!
	@method     addFieldDescriptorMapping
	@abstract   Add field descriptor to the global field descritor mappings
	@discussion Adds the field descritpro the global field descriptor mappings by tag name. If a field descritpor
				already exists in the mapping then it outputs a warning and overrides the field descriptor
	@param		fieldDescriptor : The field descriptor object to be added the mappings. 
 */
- (void) addFieldDescriptorMapping: (FieldDescriptor *) fieldDescriptor;

/*!
	@method     addFieldDescriptorMapping
	@abstract   Add field descriptor to the global field descritor mappings
	@discussion Adds the field descritpro the global field descriptor mappings by tag name. If a field descritpor
				already exists in the mapping then it outputs a warning and overrides the field descriptor
	@param		tName : Tag name for the field descriptor.
	@param		fieldDescriptor : The field descriptor object to be added the mappings. 
 */
- (void) addFieldDescriptorMapping: (NSString*) tName fieldDescriptor : (FieldDescriptor *) fieldDescriptor; 

/*!
	@method     describedClassName
	@abstract   Returns the described class name
	@result		NSString name of the described class.
 */
- (NSString *) describedClassName;

/*!
	@method     attributeFieldDescriptors
	@abstract   Gets the array of the attribte field descriptors of the class.
	@discussion Return the array of the attribute field descriptors. Attribute field descriptors are the field descriptors whose XML 
				representation is an attribute of a leaf tag. 
	@result		NSMutableArray of the attribute field descriptors.
*/
- (NSMutableArray *) attributeFieldDescriptors;

/*!
	@method     elementFieldDescriptors
	@abstract   Gets the array of the element field descriptors of the class
	@discussion Returns the array of the element field descriptors. Element field descriptors are the field descriptors whose XML representation
				is by its own ta. 
	@result		NSMutableArray	of the element field descriptors. 
*/
- (NSMutableArray *) elementFieldDescriptors;

/*!
	@method     pseudoFieldDescriptor
	@abstract   Returns a pseudo field descriptor
	@discussion Returns a pseudo field descriptor. A pseudo field descriptor is an abstract object which holds only the tag for wrapping collections.
	@result		FieldDescriptor
*/
- (FieldDescriptor *)	pseudoFieldDescriptor;

/*!
	@method     getFieldDescriptorByTag
	@abstract   Gets a field descriptor by its tag name
	@discussion Gets the field descriptor by its tag name from the global all field descriptor map.
	@param		NSString tag Name
	@param		TranslationScope : deprecated not used.		
	@param		ElementState : deprecated not used. 
	@result		FieldDescriptor with the tag name or nil if doesnot exists.
*/
- (FieldDescriptor *) getFieldDescriptorByTag:  (NSString *) elementName scope: (TranslationScope *) translationScope elementState: (ElementState *) elementState;

#pragma mark ClassDescriptor - static accessors

/*!
	@method     classDescriptor
	@abstract   A static method to get the class descriptor from the Class object.
	@discussion This method gets the name from the class object and uses the global class descriptor map to return 
				associated class descriptor. 
	@param		Class reflected class type
	@result		ClassDescriptor associated with the passes in class
*/
+ (id) classDescriptor: (Class) cls;

/*!
	@method     classDescriptorWithField
	@abstract   A static method to get the class descriptor from the field object. 
	@discussion This method uses reflection to get the class descriptor from the field object by reflecting upon the 
				type of the class containing the field 
	@param		Field object whos cotaining class descriptor is needed to be fetched.
	@result		Class descriptor of the class containing the field.
*/
+ (id) classDescriptorWithField: (Ivar) field;

/*!
	@method     classDescriptorWithName
	@abstract   A static method to get the class from the class name.
	@discussion This method fetches the class from the name of the class from the global class descriptor map.
	@param		NSString className.
	@result		ClassDescriptor associated with the class name.
*/
+ (id) classDescriptorWithName:	 (NSString *) className;

/*!
	@method     globalClassDescriptorsMap
	@abstract   Simple methods to return the global class descriptor map
	@discussion This simple returns a global class descriptor map. This is guranteed to be initialized
				a static constructor.
	@result		returns a the static globalClassDescriptorsMap
*/
+ (NSMutableDictionary *) globalClassDescriptorsMap;

@end