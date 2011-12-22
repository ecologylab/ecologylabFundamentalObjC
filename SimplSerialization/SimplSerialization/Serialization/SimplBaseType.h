//
//  SimplBaseType.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimplBaseType : NSObject
{
    @protected NSString* name;    
}

@property(nonatomic, readwrite, retain) NSString* name;

@end
