/*!
	 @header	 Type
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
#import <stdio.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>

@class FieldDescriptor;
@class ElementState;

@protocol Type

- (id) initWithString : (NSString *)value;
- (id) getValueFromString: (NSString *) value;
- (id) getInstance;
- (void) setField: (id) object fieldName: (const char *) fn;
- (void) setField: (id) object fieldName: (NSString *) fn value: (id) value;
- (void) appendValue: (NSMutableString *) buffy fieldDescriptor: (FieldDescriptor *) fd context: (id) context;
- (void) appendValue: (NSMutableString *) buffy context: (id) context;
- (BOOL) isDefaultValue: (FieldDescriptor *) fieldDescriptor context: (ElementState *) elementState;

@end