/*!
	 @header	 type.h
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

#import "Type.h"
#import "StringType.h"
#import "ClassType.h"
#import "FieldType.h"
#import "ParsedURLType.h"
#import "BooleanType.h"
#import "IntType.h"
#import "LongType.h"
#import "ReferenceTypeType.h"
#import "ReferenceIntegerType.h"