/*!
	 @header	 ParsedURLType
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
	 @class		 ParsedURLType	
	 @abstract   -
	 @discussion -
*/
@interface ParsedURLType : ReferenceType 
{
	
}

/*!
	 @method     parsedURLTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) parsedURLTypeWithString: (NSString *) value;



@end