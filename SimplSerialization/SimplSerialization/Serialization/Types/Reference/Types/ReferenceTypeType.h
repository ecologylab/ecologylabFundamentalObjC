/*!
	 @header	 ReferenceTypeType
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
#import "XmlTools.h"
#import "ReferenceType.h"

/*!
	 @class		 ReferenceTypeType	
	 @abstract   -
	 @discussion -
*/
@interface ReferenceTypeType : ReferenceType 
{
	
}

/*!
	 @method     referenceTypeTypeWithString
	 @discussion -
	 @param		 - 
	 @result     -
 */
+ (id) referenceTypeTypeWithString: (NSString *) value;


@end