/*!
	 @header	 SimplTools.h
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
	 @class		 SimplTools	
	 @abstract   Contains simple utility functions
	 @discussion XMLTools class contains static utility functions which are used by simpl serialization
				 to perform reflection and XML related operations on data structures
*/
@interface SimplTools : NSObject 
{
	
}

+ (NSString *) getClassSimpleName: (NSString *) classFullName;
+ (Class) getClass: (NSString *) className;
+ (const char *) getSetterFunction: (const char *) fieldName;
+ (id <Type>) typeWithString: (NSString *) value;
+ (NSString *) getTypeFromField: (Ivar) field;
+ (const char *) getCTypeFromField: (Ivar) field;
+ (id) getInstance: (Class *) getInstance;
+ (id) getInstanceByClassName: (NSString *) className;
+ (id) getCollection : (NSObject  *) collectionObject;
+ (void) writeOnStream: (NSOutputStream *) outputStream andString : (NSString*) dataString;

@end