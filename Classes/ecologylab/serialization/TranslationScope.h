/*!
	 @header	 TranslationScope.h
	 @abstract   TranslationScope holds the class descriptors to guide the serialization process.
	 @discussion TranslationScopes are the abstraction which binds which classes are bound to which	
				 tags in the XML representation of runtime objects. 
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
	 @abstract   TranslationScope holds the class descriptors to guide the serialization process.
     @discussion TranslationScopes are the abstraction which binds which classes are bound to which	
                 tags in the XML representation of runtime objects. 
*/
@interface TranslationScope : NSObject<NSXMLParserDelegate>
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
	 @abstract   initializes the translation scopes from the XML file
	 @discussion This method is the bootstrap in objective-c. This reads a translated translation scope XML file
				 using a SAX parser on the document. It then fills the relevant data structures which guides the serialzation process
				 in objective-c
	 @result     initilized TranslationScope
*/
- (TranslationScope *) initWithXMLFilePath: (NSString *) pathToFile; 

/*!
	 @method     getClassDescriptorByTag
	 @discussion Gets a class descriptor from the tag name from the internal map.
	 @param		 NSString tagName for which the associated class descriptor is required. 
	 @result     ClassDescriptor associated with the supplied tag name.
*/
- (ClassDescriptor *) getClassDescriptorByTag: (NSString *) tagName;

/*!
 @method     deserialize
 @discussion - 
 @param		 NSString* 
 @param		 TranslationScope*
 @result     ElementState*
 */
- (ElementState *) deserialize: (NSString *) pathToFile;

/*!
 @method     deserializeData
 @discussion -
 @param		 NSData*
 @param		 TranslationScope*
 @result     ElementState*
 */
- (ElementState *) deserializeData: (NSData *) data;

@end