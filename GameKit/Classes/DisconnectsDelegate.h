//
//  DisconnectsDelegate.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 4/3/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"

@protocol DisconnectsDelegate <NSObject>

-(void) sessionDisconnected:(SessionManager*) manager;

@end

