/*!
	 @header	 ElementState.h
	 @abstract   This header file contains the definition of the element state class
	 @discussion ElementState is the heart of simpl serialization library. It provides functionality to translate to and 
				 from XML file representation of inherited objects. 
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
*/

#import <stdio.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>

#import "fTypes.h"
#import "XMLTools.h"

@class FieldDescriptor;
@class ClassDescriptor;
@class TranslationScope;
@class ElementStateSAXHandler;


/*!
	 @class		 ElementState	
	 @abstract   Class to hold relevant data structures and relevant 
				 functinality for a serializable Classes
	 @discussion ElementState is the heart of simple serialization. It provides relevant functionalities to translate to
				 and from XML representation. Each class which needs to be serialized is supposed to inherit from ElementState
				 class.
*/
@interface ElementState : NSObject
{
	ElementState		*parent;
	ClassDescriptor		*classDescriptor;
	NSMutableDictionary *elementById;
}

@property (nonatomic, readwrite, retain) ElementState		 *parent;
@property (nonatomic, readwrite, retain) ClassDescriptor	 *classDescriptor;
@property (nonatomic, readwrite, retain) NSMutableDictionary *elementById;

#pragma mark ElementState - static translateFromXML methods

/*!
	 @method     translateFromXML
	 @discussion - 
 	 @param		 NSString* 
 	 @param		 TranslationScope*
	 @result     ElementState*
*/
+ (ElementState *) translateFromXML: (NSString *) pathToFile translationScope: (TranslationScope *) translationScope;

/*!
	 @method     translateFromXMLData
	 @discussion -
 	 @param		 NSData*
 	 @param		 TranslationScope*
	 @result     ElementState*
*/
+ (ElementState *) translateFromXMLData: (NSData *) data translationScope: (TranslationScope *) translationScope;

#pragma mark FieldDescriptor - instance methods for translateToXML

/*!
	 @method     translateToXML
	 @discussion -
 	 @param		 NSMutableString* 
 	 @param		 FieldDescriptor*
*/
- (void) translateToXML: (NSMutableString *) output fieldDescriptor: (FieldDescriptor *) fieldDescriptor;

/*!
	 @method     translateToXML
	 @discussion -
 	 @param		 NSMutableString*
*/
- (void) translateToXML: (NSMutableString *) output;

#pragma mark FieldDescriptor - instance methods to drive the marshalling processes.

/*!
	 @method     classDescriptor
	 @discussion -
	 @result     ClassDescriptor* 
*/
- (ClassDescriptor *) classDescriptor;

/*!
	 @method     parent
	 @discussion - 
	 @result     ElementState*
*/
- (ElementState *) parent;

/*!
	 @method     setupRoot
	 @discussion -
 */
- (void) setupRoot;

/*!
	 @method     setupChildElementState
	 @discussion -
	 @param		 ElementState* 
*/
- (void) setupChildElementState: (ElementState *) childElementState;

/*!
	 @method     translateAttributes
	 @discussion -
	 @param		 TranslationScope* 
 	 @param		 NSDictionary*
 	 @param		 ElementState*
 */
- (void) translateAttributes: (TranslationScope *) translationScope withAttrib: (NSDictionary *) attributes context: (ElementState *) context;


@end