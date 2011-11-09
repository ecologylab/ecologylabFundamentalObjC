//
//  XMLTools.m
//  ecologylabXML
//
//  Created by Nabeel Shahzad on 1/5/10.
//  Copyright 2010 Interface Ecology Lab. All rights reserved.
//

#import "SimplTools.h"


@implementation SimplTools

+ (NSString *) getClassSimpleName : (NSString *) classFullName 
{
	NSArray *splitString = [classFullName componentsSeparatedByString: @"."];
	return (NSString *)[splitString objectAtIndex: splitString.count - 1];
}

+ (Class) getClass: (NSString *) className 
{
	return (Class)objc_getClass([[SimplTools getClassSimpleName: className] cStringUsingEncoding: NSASCIIStringEncoding]);
}

+ (const char *) getSetterFunction: (const char *) fieldName
{
	//TODO :  works but do this a better way!
	NSString *fName = [NSString stringWithUTF8String: fieldName];
	NSString *capitalizedFieldName = [fName stringByReplacingCharactersInRange: NSMakeRange(0, 1)  withString:[[fName substringToIndex: 1] capitalizedString]];
	NSString *functionName = [NSString stringWithFormat: @"set%@WithReference:", capitalizedFieldName];
	return [functionName cStringUsingEncoding: NSASCIIStringEncoding];
}

+ (id <Type>) typeWithString: (NSString *) value 
{
	Class type = [SimplTools getClass: value];
	return class_createInstance(type, 0);
}

+ (NSString *) getTypeFromField: (Ivar) field 
{
	NSString *result = [NSString stringWithUTF8String: ivar_getTypeEncoding(field)];
	return [result substringWithRange: NSMakeRange(2, [result length] - 3)];
}

+ (const char *) getCTypeFromField: (Ivar) field 
{
	NSString *result = [NSString stringWithUTF8String: ivar_getTypeEncoding(field)];
	return [[result substringWithRange: NSMakeRange(2, [result length] - 3)] cStringUsingEncoding: NSASCIIStringEncoding];
}

+ (id) getInstance: (Class *) class 
{
	return class_createInstance(*class, 0);
}

+ (id) getInstanceByClassName: (NSString *) className
{
    return class_createInstance([SimplTools getClass: className], 0);
}

+ (id) getCollection : (NSObject  *) collectionObject
{
    if([collectionObject isKindOfClass:[NSDictionary class]])
     return [((NSDictionary *)collectionObject) allValues];
    
    if([collectionObject isKindOfClass:[NSArray class]])
        return ((NSArray *)collectionObject);

    return nil;    
}

+ (void) writeOnStream: (NSOutputStream *) outputStream andString : (NSString*) dataString
{
    const uint8_t *rawString=(const uint8_t *)[dataString UTF8String];
    [outputStream write:rawString maxLength:[dataString length]];    
}

@end