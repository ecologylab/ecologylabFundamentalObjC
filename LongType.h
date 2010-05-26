/*!
	 @header	 LongType
	 @abstract   -
	 @discussion -
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>


#import "ScalarType.h"

@class FieldDescriptor;

/*!
	 @class		 LongType	
	 @abstract   -
	 @discussion -
*/
@interface LongType : ScalarType 
{
	
}

/*!
	 @method     longTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) longTypeWithString: (NSString *) value;

@end
