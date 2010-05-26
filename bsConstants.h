/*!
	 @header	 ElementState
	 @abstract   This header file contains the definition of the field descriptor 
	 @discussion ElementState are the objects which describe each field. They are mapped with field names and 
				 XML tag names which helps in the serialization and deserialiazation and binds the objects to their XML representation. 
				 Field descriptors also holds the arrays and mappings of the field descriptors to their tag names which binds run-time objects
				 to their XML representation
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/


//TODO: can also use the property list here!

//TranslationScope constants
#define TRANSLATION_SCOPE				 @"translation_scope"
#define TRANSLATION_SCOPE_NAME			 @"name"

//ClassDescriptor constants
#define CLASS_DESCRIPTOR				 @"class_descriptor"
#define CLASS_DESCRIPTOR_DESCRIBED_CLASS @"described_class"
#define CLASS_DESCRIPTOR_TAG_NAME		 @"tag_name"

//FieldDescriptor constants
#define FIELD_DESCRIPTOR				 @"field_descriptor"
#define FIELD_DESCRIPTOR_FIELD			 @"field"
#define FIELD_DESCRIPTOR_TAG_NAME		 @"tag_name"
#define FIELD_DESCRIPTOR_TYPE			 @"type"
#define FIELD_DESCRIPTOR_SCALAR_TYPE	 @"scalar_type"
#define FIELD_DESCRIPTOR_NEEDS_ESCAPING  @"needs_escaping"
#define FIELD_DESCRIPTOR_COLLECTION_TAG  @"collection_or_map_tag_name"
#define FIELD_DESCRIPTOR_WRAPPED		 @"wrapped"
#define FIELD_DESCRIPTOR_ELEMENT_CLASS   @"element_class"
#define TAG_CLASSES_OUTER				 @"tag_classes"
#define TAG_CLASSES						 @"tagClasses"

