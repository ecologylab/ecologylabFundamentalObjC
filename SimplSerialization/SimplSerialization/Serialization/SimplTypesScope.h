/*!
	 @header	 SimplTypesScope.h
	 @abstract   SimplTypesScope holds the class descriptors to guide the serialization process.
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

#import "SimplTools.h"
#import "SimplDefs.h"
#import "TranslationContext.h"
#import "DeserializationHookStrategy.h"

@class FieldDescriptor;
@class ClassDescriptor;


@interface SimplTypesScope : NSObject
{
	NSString			*name;
	NSMutableDictionary *entriesByTag;
}

@property(nonatomic, readwrite, retain) NSString* name;

// bootstrap load s.im.pl types
+ (id) simplTypesScopeWithFilePath : (NSString *) pathToFile;


// returns the ClassDescriptor mapped with its associated tag. 
- (ClassDescriptor *) getClassDescriptorByTag: (NSString *) tagName;

// add mapping
- (void) mapTagToClassDescriptor: (NSString *) tagName andClassDescriptor: (ClassDescriptor *) classDescriptor;

// deserialize methods
- (NSObject *) deserialize: (NSString *) inputString andStringFormat : (StringFormat) format;
- (NSObject *) deserialize: (NSString *) inputString andContext : (TranslationContext *) translationContext andStringFormat : (StringFormat) format;
- (NSObject *) deserialize: (NSString *) inputString andContext : (TranslationContext *) translationContext andStrategy : (id<DeserializationHookStrategy>) hookStrategy andStringFormat : (StringFormat) format;


- (NSObject *) deserialize: (NSData *) inputData andFormat : (Format) format;
- (NSObject *) deserialize: (NSData *) inputData andContext : (TranslationContext *) translationContext andFormat : (Format) format;
- (NSObject *) deserialize: (NSData *) inputData andContext : (TranslationContext *) translationContext andStrategy : (id<DeserializationHookStrategy>) hookStrategy andFormat : (Format) format;

- (NSObject *) deserializeFilePath : (NSString *) filePath andFormat : (Format) format;
- (NSObject *) deserializeFilePath : (NSString *) filePath andContext : (TranslationContext *) translationContext andFormat : (Format) format;
- (NSObject *) deserializeFilePath : (NSString *) filePath andContext : (TranslationContext *) translationContext andStrategy : (id<DeserializationHookStrategy>) hookStrategy andFormat : (Format) format;


// serialize methods
+ (void) serialize: (NSObject *) object andString : (NSMutableString *) outputString andStringFormat : (StringFormat) format;
+ (void) serialize: (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext andStringFormat : (StringFormat) format;

+ (void) serialize: (NSObject *) object andData : (NSData *) outputData andFormat: (Format) format;
+ (void) serialize: (NSObject *) object andData : (NSData *) outputData andContext : (TranslationContext *) translationContext andFormat: (Format) format;

+ (NSString *) serialize: (NSObject *) object  andStringFormat : (StringFormat) format;
+ (NSData *) serialize: (NSObject *) object andFormat: (Format) format;

+ (NSString *) serialize: (NSObject *) object andContext : (TranslationContext *) translationContext andStringFormat : (StringFormat) format;
+ (NSData *) serialize: (NSObject *) object andContext : (TranslationContext *) translationContext andFormat: (Format) format;

+ (void) serializeToFilePath: (NSString *) filePath andFormat: (Format) format;
+ (void) serializeToFilePath: (NSString *) filePath andContext : (TranslationContext *) translationContext andFormat: (Format) format;

// graph handling
+ (void) enableGraphHandling;
+ (void) disableGraphHandling;
+ (bool) isGraphHandlingEnabled;

@end