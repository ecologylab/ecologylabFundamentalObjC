//
//  Client.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/27/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestMessage.h"

@protocol Client <NSObject>

-(void) sendMessage:(RequestMessage*) message;

@end
