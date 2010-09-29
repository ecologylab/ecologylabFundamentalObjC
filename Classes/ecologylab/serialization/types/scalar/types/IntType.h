/*!
	 @header	 IntType
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
	 @class		 IntType	
	 @abstract   -
	 @discussion -
*/
@interface IntType : ScalarType 
{
	
}

/*!
	 @method     intTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) intTypeWithString: (NSString *) value;

@end