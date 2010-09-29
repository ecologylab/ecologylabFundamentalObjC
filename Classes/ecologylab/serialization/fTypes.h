/*!
	 @header	 fTypes.h
	 @abstract   Defines constants for types of field descriptors
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/

#define UNSET_TYPE					-999
#define BAD_FIELD					-99
#define IGNORED_ATTRIBUTE			-1
#define	SCALAR						0x12
#define COMPOSITE_ELEMENT			3
#define IGNORED_ELEMENT				-3
#define COLLECTION_ELEMENT			4
#define COLLECTION_SCALAR			5
#define MAP_ELEMENT					6
#define MAP_SCALAR					7
#define WRAPPER						0x0a
#define PSEUDO_FIELD_DESCRIPTOR		0x0d
#define NAMESPACE_IGNORED_ELEMENT	-2
#define XMLNS_ATTRIBUTE				0x0e
#define XMLNS_IGNORED				0x0f
#define NAME_SPACE_MASK				0x10
#define NAMESPACE_TRIAL_ELEMENT		NAME_SPACE_MASK
#define NAME_SPACE_SCALAR			NAME_SPACE_MASK + SCALAR
#define NAME_SPACE_NESTED_ELEMENT	NAME_SPACE_MASK + COMPOSITE_ELEMENT