//
//  SimplEnum.h
//  SimplSerialization
//
//  Created by Nabeel Shahzad on 12/19/11.
//  Copyright (c) 2011 Texas A&M University. All rights reserved.
//

#import <Foundation/Foundation.h>

// An abstract base class from whic all generated enum types will inherit. 
@interface SimplEnum : NSObject

- (int) valueFromString : (NSString *) enumString;
- (NSString *) stringFromValue : (int) value;

@end
