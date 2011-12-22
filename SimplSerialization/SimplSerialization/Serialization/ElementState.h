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

#import "FieldTypes.h"
#import "SimplTools.h"

@class FieldDescriptor;
@class ClassDescriptor;
@class SimplTypesScope;
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

@end