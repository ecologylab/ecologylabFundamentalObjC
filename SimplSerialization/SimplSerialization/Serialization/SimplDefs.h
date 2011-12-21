//
//  SimplDefs.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//


#define START_CDATA "<![CDATA["
#define END_CDATA	"]]>"

#define SIMPL_NAMESPACE	" xmlns:simpl=\"http://ecologylab.net/research/simplGuide/serialization/index.html\""
#define SIMPL_ID "simpl:id"
#define SIMPL_REF "simpl:ref"
#define SIMPL_JSON_ID "simpl.id"
#define SIMPL_JSON_REF "simpl.ref"


//all formats 
typedef enum Format
{
    kFXml,
    kFJson,
    kFBibtex,
    kFTlv
} Format;

//string formats
typedef enum StringFormat
{
    kSFXml,
    kSFJson,
    kSFBibtex
} StringFormat;

//binary formats
typedef enum BinaryFormat
{
    kBFTlv
} BinaryFormat;

//graph handling
typedef enum GraphSwitch
{
    kGHOn,
    kGHOff
} GraphSwitch;

typedef enum XmlHint
{
	XmlAttribute = 0, 
	XmlLeaf = 1, 
	XmlLeafCdata = 2, 
	XmlText = 3, 
	XmlTextCdata = 4, 
	Undefined = 5
} XmlHint;

