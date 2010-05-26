/*!
	 @header	 FloatType
	 @abstract   -
	 @discussion -
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */

#import <stdio.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>

#import "ScalarType.h"

@class FieldDescriptor;

/*!
	 @class		 FloatType	
	 @abstract   -
	 @discussion -
*/
@interface FloatType : ScalarType 
{
	
}

/*!
	 @method     floatTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) floatTypeWithString: (NSString *) value;

@end