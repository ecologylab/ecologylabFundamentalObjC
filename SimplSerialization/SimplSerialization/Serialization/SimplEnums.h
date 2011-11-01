//
//  FormatEnums.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 10/31/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

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
