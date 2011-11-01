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
@property (nonatomic, readonly, assign) xmlElementType nodeType;
@property (nonatomic, readonly, assign) BOOL read;
@property (nonatomic, readonly, retain) NSString *readElementContentAsString;
@property (nonatomic, readonly, assign) BOOL isEmptyElement;

- (void) close;
- (id) getAttribute:(NSString *) paramName;
- (id) initWithPath:(NSString *) path;
@end