//
//  ExplanationResponse.h
//  ecologylabXML
//
//  Created by William Hamilton on 1/22/10.
//  Copyright 2010 Texas A&M University. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ResponseMessage.h"

@interface ExplanationResponse : ResponseMessage
{
	NSString *explanation;
}

@property (nonatomic,readwrite, retain) NSString *explanation;

@end

