/*!
	 @header	 StringType
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
#import "ReferenceType.h"

/*!
	 @class		 StringType	
	 @abstract   -
	 @discussion -
*/
@interface StringType : ReferenceType 
{
	
}

/*!
	 @method     stringTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) stringTypeWithString: (NSString *) value;

@end