/*!
	 @header	 XMLTools.h
	 @abstract   Contains simple utility functions
	 @discussion XMLTools class contains static utility functions which are used by simpl serialization
				 to perform reflection and XML related operations on data structures
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/

#import <stdio.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>
#import "Type.h"


/*!
	 @class		 XMLTools	
	 @abstract   Contains simple utility functions
	 @discussion XMLTools class contains static utility functions which are used by simpl serialization
				 to perform reflection and XML related operations on data structures
*/
@interface SimplTools : NSObject 
{
	
}

/*!
	 @method     getClassSimpleName
	 @discussion -
	 @param		 - 
	 @result     -
*/
+ (NSString *) getClassSimpleName: (NSString *) classFullName;

/*!
	 @method     getClass		
	 @discussion -
 	 @param		 - 
	 @result     -
*/
+ (Class) getClass: (NSString *) className;

/*!
	 @method     getSetterFunction
	 @discussion -
 	 @param		 - 
	 @result     -
*/
+ (const char *) getSetterFunction: (const char *) fieldName;

/*!
	 @method     typeWithString
	 @discussion -
 	 @param		 - 
	 @result     -
*/
+ (id <Type>) typeWithString: (NSString *) value;

/*!
	 @method     getTypeFromField
	 @discussion -
 	 @param		 - 
	 @result     -
*/
+ (NSString *) getTypeFromField: (Ivar) field;

/*!
	 @method     getCTypeFromField
	 @discussion - 
 	 @param		 - 
	 @result     -
*/
+ (const char *) getCTypeFromField: (Ivar) field;

/*!
	 @method     getInstance
	 @discussion -
 	 @param		 - 
	 @result     -
*/
+ (id) getInstance: (Class *) getInstance;


+ (id) getCollection : (NSObject  *) collectionObject;

+ (void) writeOnStream: (NSOutputStream *) outputStream andString : (NSString*) dataString;

@end