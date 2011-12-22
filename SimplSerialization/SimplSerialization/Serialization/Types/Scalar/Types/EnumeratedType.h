//
//  EnumeratedType.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/21/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScalarType.h"
#import "SimplEnum.h"

@interface EnumeratedType : ScalarType
{
    @private SimplEnum *simplEnum;
}

@property(nonatomic, readwrite, retain) SimplEnum *simplEnum;


+ (id) enumeratedTypeWithSimplEnum : (SimplEnum *) sipm


@end
