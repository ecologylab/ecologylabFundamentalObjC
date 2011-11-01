/*!
	 @header	 FieldType
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
#import "SimplTools.h"
#import "ReferenceType.h"

/*!
	 @class		 FieldType	
	 @abstract   -
	 @discussion -
*/
@interface FieldType : ReferenceType 
{
	
}

/*!
	 @method     fieldTypeWithStringAndClass
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (id) fieldTypeWithStringAndClass: (NSString *) value containerClass: (Class *) c;

/*!
	 @method     initWithStringAndClass
	 @discussion -
	 @param		 - 
	 @result     -
 */
- (id) initWithStringAndClass: (NSString *) value containerClass: (Class *) c;

/*!
	 @method     setInstance
	 @discussion -
	 @param		 - 
	 @result     -
*/
- (void) setInstance: (NSString *) value containerClass: (Class *) c;

@end