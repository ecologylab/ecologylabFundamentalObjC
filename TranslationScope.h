/*!
	 @header	 TranslationScope
	 @abstract   -
	 @discussion -
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/

#import <stdio.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#import "XMLTools.h"
#import "types.h"

@class FieldDescriptor;
@class ClassDescriptor;

/*!
	 @class		 TranslationScope	
	 @abstract   -
	 @discussion -
*/
@interface TranslationScope : NSObject
{
	NSString			*name;
	NSMutableDictionary *entriesByTag;
	ClassDescriptor		*classDescriptor;
	FieldDescriptor		*fieldDescriptor;
	NSMutableArray		*fdStack;
	BOOL				success;
	BOOL				addTagClasses;
}

/*!
	 @method     initWithXMLFilePath
	 @abstract   An object level method to initialize a TranslationScope.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized TranslationScope
*/
- (TranslationScope *) initWithXMLFilePath: (NSString *) pathToFile; 

/*!
	 @method     getClassDescriptorByTag
	 @abstract   An object level method to initialize a TranslationScope.
	 @discussion Simple mehtod to initialize the class data structures. 
	 @result     initilized TranslationScope
*/
- (ClassDescriptor *) getClassDescriptorByTag: (NSString *) tagName;


@end