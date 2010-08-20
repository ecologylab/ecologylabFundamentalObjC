//
//  ServerPickerDelegate.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/28/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ServerPickerDelegate

-(void) cancelSelected;

-(void) pickedServer:(NSString*) serverId onSession:(GKSession*) session;

@end

