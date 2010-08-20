//
//  AuthClientDelegate.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/19/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLClientDelegate.h"

@protocol AuthClientDelegate<XMLClientDelegate>

-(void) loginFailed;
-(void) loginSucceeded;
-(void) loggedOut;

@end
