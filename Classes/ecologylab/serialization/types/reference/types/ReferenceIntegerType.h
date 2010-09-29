//
//  NSNumberType.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 8/26/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <stdio.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>
#import "ReferenceType.h"

/*!
 @class		 ReferenceIntegerType	
 @abstract   -
 @discussion -
 */
@interface ReferenceIntegerType : ReferenceType 
{
	
}

/*!
 @method     referenceIntegerTypeWithString
 @discussion -
 @param		 - 
 @result     -
 */
+ (id) referenceIntegerTypeWithString: (NSString *) value;

@end
