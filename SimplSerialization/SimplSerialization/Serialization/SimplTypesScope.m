#import "SimplTypesScope.h"
#import "ClassDescriptor.h"
#import "FieldDescriptor.h"
#import "BootStrap.h"
#import "FormatSerializer.h"
#import "StringSerializer.h"
#import "PullDeserializer.h"
#import "StringPullDeserializer.h"

static GraphSwitch graphSwitch = kGHOff;

@implementation SimplTypesScope

@synthesize name;

- (void) dealloc 
{
	[name release];
	[entriesByTag release];
	[super dealloc];
}

+ (id) simplTypesScopeWithFilePath : (NSString *) pathToFile
{
    return [BootStrap deserializeSimplTypesFromFile : pathToFile];
}

- (ClassDescriptor *) getClassDescriptorByTag: (NSString *) tagName 
{
	return [entriesByTag objectForKey: tagName];
}

- (void) mapTagToClassDescriptor: (NSString *) tagName andClassDescriptor: (ClassDescriptor *) classDescriptor
{
    [entriesByTag setObject:classDescriptor forKey:tagName];
}

- (id) init 
{
	if ( (self = [super init]) ) 
	{
		entriesByTag = [[NSMutableDictionary dictionary] retain];
	}

	return self;
}

// deserialize methods
- (NSObject *) deserialize: (NSString *) inputString andStringFormat : (StringFormat) format
{
    return [self deserialize:inputString andContext: [TranslationContext translationContext] andStringFormat: format];
}

- (NSObject *) deserialize: (NSString *) inputString andContext : (TranslationContext *) translationContext andStringFormat : (StringFormat) format
{
    return [self deserialize:inputString andContext: translationContext andStrategy: nil andStringFormat: format];
}

- (NSObject *) deserialize: (NSString *) inputString andContext : (TranslationContext *) translationContext andStrategy : (id<DeserializationHookStrategy>) hookStrategy andStringFormat : (StringFormat) format
{
    StringPullDeserializer *stringPullDeserializer = [PullDeserializer stringDeserializer:self andContext:translationContext andStringFormat:format];    
    return [stringPullDeserializer parseString:inputString];
}

- (NSObject *) deserialize: (NSData *) inputData andFormat : (Format) format
{
    return [self deserialize:inputData andContext:[TranslationContext translationContext] andFormat:format];
}

- (NSObject *) deserialize: (NSData *) inputData andContext : (TranslationContext *) translationContext andFormat : (Format) format
{
    return [self deserialize:inputData andContext:translationContext andStrategy:nil andFormat:format];
}

- (NSObject *) deserialize: (NSData *) inputData andContext : (TranslationContext *) translationContext andStrategy : (id<DeserializationHookStrategy>) hookStrategy andFormat : (Format) format
{
    PullDeserializer* pullDeserializer = [PullDeserializer formatDeserializer:self andContext:translationContext andFormat:format];
    return [pullDeserializer parse:inputData];
}

- (NSObject *) deserializeFilePath : (NSString *) filePath andFormat : (Format) format
{
    return [self deserializeFilePath:filePath andContext:[TranslationContext translationContext] andFormat:format];
}

- (NSObject *) deserializeFilePath : (NSString *) filePath andContext : (TranslationContext *) translationContext andFormat : (Format) format
{
    return [self deserializeFilePath:filePath andContext:translationContext andStrategy:nil andFormat:format];
}

- (NSObject *) deserializeFilePath : (NSString *) filePath andContext : (TranslationContext *) translationContext andStrategy : (id<DeserializationHookStrategy>) hookStrategy andFormat : (Format) format
{
    //TODO: implement this
    return nil;
}


// serialize methods
+ (void) serialize: (NSObject *) object andString : (NSMutableString *) outputString andStringFormat : (StringFormat) format
{
    [self serialize:object andString:outputString andContext:[TranslationContext translationContext] andStringFormat:format];
}

+ (void) serialize: (NSObject *) object andString : (NSMutableString *) outputString andContext : (TranslationContext *) translationContext andStringFormat : (StringFormat) format
{
    StringSerializer* serializer = [FormatSerializer serializerWithStringFormat:format];
    [serializer serialize:object andString:outputString andContext:translationContext];
}

+ (void) serialize: (NSObject *) object andData : (NSData *) outputData andFormat: (Format) format
{
    [self serialize:object andData:outputData andContext:[TranslationContext translationContext] andFormat:format];
}

+ (void) serialize: (NSObject *) object andData : (NSData *) outputData andContext : (TranslationContext *) translationContext andFormat: (Format) format
{
    FormatSerializer* serializer = [FormatSerializer serializerWithFormat:format];
    [serializer serialize:object andData:outputData andContext:translationContext];
}

+ (NSString *) serialize: (NSObject *) object  andStringFormat : (StringFormat) format
{
    return [self serialize:object andContext:[TranslationContext translationContext] andStringFormat:format];
}

+ (NSData *) serialize: (NSObject *) object andFormat: (Format) format
{
    return [self serialize:object andContext:[TranslationContext translationContext] andFormat:format];
}

+ (NSString *) serialize: (NSObject *) object andContext : (TranslationContext *) translationContext andStringFormat : (StringFormat) format
{
    StringSerializer* serializer =  [FormatSerializer serializerWithStringFormat: format];
    return [serializer serialize:object andContext:translationContext];    
}

+ (NSData *) serialize: (NSObject *) object andContext : (TranslationContext *) translationContext andFormat: (Format) format
{
    //TODO: implement this    
    return nil;    
}

+ (void) serializeToFilePath: (NSString *) filePath andFormat: (Format) format
{
    [self serializeToFilePath:filePath andContext:[TranslationContext translationContext] andFormat:format];
}

+ (void) serializeToFilePath: (NSString *) filePath andContext : (TranslationContext *) translationContext andFormat: (Format) format
{
    //TODO: implement this    
}

+ (void) enableGraphHandling
{
    graphSwitch = kGHOn;
}

+ (void) disableGraphHandling
{
    graphSwitch = kGHOff;
}

+ (bool) isGraphHandlingEnabled
{
    return graphSwitch == kGHOn;
}

@end