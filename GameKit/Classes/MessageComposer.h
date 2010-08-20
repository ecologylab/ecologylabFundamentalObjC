//
//  MessageComposer.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/26/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceMessage.h"
#import "NetworkConstants.h"

@interface MessageComposer : NSObject {
	NSMutableString* headerConstructionString;
	NSMutableString* messageConstructionString;
	NSMutableData* outgoingMessageBuffer;
}

-(id) init;

-(NSData*) composeMessage:(ServiceMessage*) request withUID:(int) uid;

@end
