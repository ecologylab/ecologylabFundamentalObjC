/*!
	 @header	 ReferenceType
	 @abstract   -
	 @discussion ReferenceType
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */
#import <Foundation/Foundation.h>
#import "Type.h"

@class FieldDescriptor;

/*!
	 @class		 ReferenceType	
	 @abstract   -
	 @discussion -
*/
@interface ReferenceType : NSObject <Type> 
{
	id m_value;
	id DEFAULT_VALUE_STRING;
}

/*!
	 @method     initWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (id) initWithString: (NSString *) value;

/*!
	 @method     getValueFromString
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (id) getValueFromString: (NSString *) value;

/*!
	 @method     setField
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (void) setField: (id) object fieldName: (const char *) fn;

/*!
	 @method     appendValue
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (void) appendValue: (NSMutableString *) buffy fieldDescriptor: (FieldDescriptor *) fd context: (id) context;

/*!
	 @method     getInstance
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (id) getInstance;

/*!
	 @method     setInstance
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (void) setInstance: (NSString *) value;

/*!
	 @method     setDefaultValue
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (void) setDefaultValue;

@end