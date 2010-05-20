//
//  HeartBeater.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 4/1/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ping.h"
#import "Client.h"

@interface HeartBeater : NSObject {
	BOOL started;
	Ping* cachedPing;
	id<Client> client;
	double delay;
}

@property(readwrite, retain) id<Client> client;

-(id) initWithClient:(id<Client>) c andDelay:(double) d;
-(void) start;
-(void) stop;
@end
