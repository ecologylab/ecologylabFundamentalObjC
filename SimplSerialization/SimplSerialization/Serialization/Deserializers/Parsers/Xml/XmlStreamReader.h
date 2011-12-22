//
//  XmlStreamReader.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>

@interface XmlStreamReader  : NSObject 
{
    xmlTextReaderPtr xmlReader;
}

@property (nonatomic, readonly, assign) BOOL eof;
@property (nonatomic, readonly, retain) NSString *localName;
@property (nonatomic, readonly, assign) xmlReaderTypes nodeType;
@property (nonatomic, readonly, assign) BOOL read;
@property (nonatomic, readonly, retain) NSString *readElementContentAsString;
@property (nonatomic, readonly, assign) BOOL isEmptyElement;
@property (nonatomic, readonly, assign) BOOL moveToNextAttribute;
@property (nonatomic, readonly, assign) BOOL moveToElement;
@property (nonatomic, readonly, retain) NSString *name;
@property (nonatomic, readonly, retain) NSString *value;

+ (id) xmlStreamReaderWithString : (NSString *) inputString;
+ (id) xmlStreamReaderWithData : (NSData *) inputData;
+ (id) xmlStreamReaderWithFilePath : (NSString *) filePath;

- (void) close;

- (id) getAttribute:(NSString *) paramName;
- (id) initWithPath:(NSString *) path;
- (id) initWithString : (NSString *) dataString;
- (id) initWithData : (NSData *) data;
- (void) skipCurrentTag;


@end