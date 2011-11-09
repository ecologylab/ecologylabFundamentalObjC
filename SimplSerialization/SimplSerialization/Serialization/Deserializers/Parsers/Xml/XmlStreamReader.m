//
//  XmlStreamReader.m
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/27/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import "XmlStreamReader.h"


@implementation XmlStreamReader

@dynamic eof;
@dynamic localName;
@dynamic nodeType;
@dynamic read;
@dynamic readElementContentAsString;
@dynamic isEmptyElement;
@dynamic moveToNextAttribute;
@dynamic name;
@dynamic value;
@dynamic moveToElement;

- (void) dealloc
{
    xmlFreeTextReader(xmlReader);
    [super dealloc];
}


+ (id) xmlStreamReaderWithString : (NSString *) inputString
{
    return [[XmlStreamReader alloc] initWithString:inputString];
}

+ (id) xmlStreamReaderWithData : (NSData *) inputData
{
    return [[XmlStreamReader alloc] initWithData:inputData];
}

+ (id) xmlStreamReaderWithFilePath : (NSString *) filePath
{
    return [[XmlStreamReader alloc] initWithPath:filePath];
}


/**
 * xmlTextReaderClose:
 * @reader:  the xmlTextReaderPtr used
 *
 * This method releases any resources allocated by the current instance
 * changes the state to Closed and close any underlying input.
 *
 * Returns 0 or -1 in case of error
 */
- (void) close
{
    xmlTextReaderClose(xmlReader);
}

/**
 * @reader:  the xmlTextReaderPtr used
 * @name: the qualified name of the attribute.
 *
 * Provides the value of the attribute with the specified qualified name.
 *
 * Returns a string containing the value of the specified attribute, or NULL
 *    in case of error. The string must be deallocated by the caller.
 */
- (id) getAttribute:(NSString *) paramName
{
    
    xmlChar *attribute = xmlTextReaderGetAttribute(xmlReader, (xmlChar *)[paramName UTF8String]);
    
    if(attribute != NULL){
        NSString *rtString = [NSString stringWithUTF8String:(const char *)attribute];
        free(attribute);
        return rtString;
    }
    return NULL;
}

/**
 * Checks if, the reader has reached to the end of file
 * 'EOF' is not used as it is already defined in stdio.h
 * as '#define  EOF (-1)'
 */
- (BOOL) eof
{
    return xmlTextReaderReadState(xmlReader) == XML_TEXTREADER_MODE_EOF;
}



/**
 * Initializing the xml stream reader with some uri
 * or local path.
 */
- (id) initWithPath:(NSString *) path
{
    if(self = [super init])
    {
        xmlReader = xmlNewTextReaderFilename([path UTF8String]);
        if(xmlReader == NULL)
            return nil;
    }
    return self;
}

- (id) initWithString : (NSString *) dataString
{
    if(self = [super init])
    {
        xmlReader = xmlReaderForDoc((const unsigned char*)[dataString UTF8String], "", nil, (XML_PARSE_NOWARNING));
    }
    return self;
    
}

- (id) initWithData : (NSData *) data
{
    if(self = [super init])
    {
        xmlReader = xmlReaderForMemory([data bytes], [data length], "", nil, (XML_PARSE_NOWARNING));
    }
    return self;
}


/**
 * @reader:  the xmlTextReaderPtr used
 *
 * The local name of the node.
 *
 * Returns the local name or NULL if not available,
 *   if non NULL it need to be freed by the caller.
 */
- (NSString *) localName
{
    xmlChar *lclName = xmlTextReaderLocalName(xmlReader);
    
    if(lclName != NULL)
    {
        NSString *rtString = [NSString stringWithUTF8String:(const char *)lclName];
        free(lclName);
        return rtString;
    }
    return NULL;
}

- (xmlReaderTypes) nodeType
{
    int t = xmlTextReaderNodeType(xmlReader);
    return t;
}

/**
 * @reader:  the xmlTextReaderPtr used
 *
 *  Moves the position of the current instance to the next node in
 *  the stream, exposing its properties.
 *
 *  Returns 1 if the node was read successfully, 0 if there is no more
 *          nodes to read, or -1 in case of error
 */
- (BOOL) read
{
    return xmlTextReaderRead(xmlReader);
}



/**
 * @reader:  the xmlTextReaderPtr used
 *
 * Reads the contents of an element or a text node as a string.
 *
 * Returns a string containing the contents of the Element or Text node,
 *         or NULL if the reader is positioned on any other type of node.
 *         The string must be deallocated by the caller.
 */
- (NSString *) readElementContentAsString
{
    xmlChar *content = xmlTextReaderReadString(xmlReader);
    
    if(content != NULL)
    {
        NSString *rtString = [NSString stringWithUTF8String:(const char *)content];
        free(content);
        return rtString;
    }
    return NULL;
}

/**
 * @reader:  the xmlTextReaderPtr used
 * @localName:  the local name of the attribute.
 * @namespaceURI:  the namespace URI of the attribute.
 *
 * Moves the position of the current instance to the attribute with the
 * specified local name and namespace URI.
 *
 * Returns 1 in case of success, -1 in case of error, 0 if not found
 */
- (int) readToFollowing:(NSString *) localname namespace:(NSString *) namespaceURI
{
    return xmlTextReaderMoveToAttributeNs(xmlReader, (xmlChar *)[localname UTF8String], (xmlChar *)[namespaceURI UTF8String]);
}


- (BOOL) moveToNextAttribute
{
    return xmlTextReaderMoveToNextAttribute(xmlReader);
}

- (BOOL) isEmptyElement
{
    return xmlTextReaderIsEmptyElement(xmlReader);
}

- (NSString *) name
{
    return [NSString stringWithUTF8String:(const char *)xmlTextReaderName(xmlReader)];
}

- (NSString *) value
{
    return [NSString stringWithUTF8String:(const char *)xmlTextReaderValue(xmlReader)];
}

- (BOOL) moveToElement
{    
    return xmlTextReaderMoveToElement(xmlReader);
}

- (void) skipCurrentTag
{
    NSString* tagName = self.name;    
    if(tagName == NULL) return;
    
    NSMutableArray* startElement = [NSMutableArray array];
    [startElement addObject:tagName];
    
    while(self.read)
    {
        switch (self.nodeType) 
        {
            case XML_READER_TYPE_ELEMENT:
                if([self.name isEqualToString:tagName])
                    [startElement addObject:tagName];
                break;
            case XML_READER_TYPE_END_ELEMENT:
                if([self.name isEqualToString:tagName])
                    [startElement removeLastObject];                    
                break;       
            default:
                break;                
        }
        
        if(startElement.count <= 0)
            break;
    }
}


@end
