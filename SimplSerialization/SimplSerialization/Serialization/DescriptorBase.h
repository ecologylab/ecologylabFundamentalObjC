//
//  DescriptorBase.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplBaseType.h"

@interface DescriptorBase : SimplBaseType
{
    @protected NSString*        tagName;    
    @protected NSMutableArray*  otherTags;
    @protected NSString*        comment;    
}

@property(nonatomic, readwrite, retain) NSString* tagName;
@property(nonatomic, readwrite, retain) NSMutableArray* otherTags;
@property(nonatomic, readwrite, retain) NSString* comment;

@end
