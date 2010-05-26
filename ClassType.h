/*!
	 @header	 ClassType
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
#import "XMLTools.h"

/*!
	 @class		 ClassType	
	 @abstract   -
	 @discussion -
 */
@interface ClassType : ReferenceType 
{
	
}

/*!
	 @method     classTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) classTypeWithString: (NSString *) value;

@end