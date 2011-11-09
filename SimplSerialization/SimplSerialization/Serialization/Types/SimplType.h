//
//  SimplType.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 11/6/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

//this is an abstract type
@interface SimplType : NSObject
{
    @protected NSString* simpleName;    
}

@property(nonatomic, readwrite, retain) NSString* simpleName;

- (id) initWithSimpleName : (NSString*) name;



@end
