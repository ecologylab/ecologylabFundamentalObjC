//
//  MessageOutputDelegate.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/25/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SessionManager;
@class ServiceMessage;
@class Scope;

@protocol ServerDelegate

- (void) sendMessage:(ServiceMessage*) message withUid:(int) uid toClient:(NSString*) clientId;

- (BOOL) reestablishSession:(NSString*) sessionToken withManager:(SessionManager*) manager;
- (void) establishSession:(NSString*) sessionToken withManager:(SessionManager*) manager;
- (void) disestablishSession:(SessionManager*) sessionToken;

@end

