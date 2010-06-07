//
//  ChatUpdateImpl.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 6/3/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "ChatUpdateImpl.h"
#import "ChatUpdateDelegate.h"

@implementation ChatUpdate (Implementation)

-(void) processUpdate:(Scope *) scope
{
	/*
	 * Get reference to the CHAT_UPDATE_DELEGATE out of the application scope. 
	 */
	NSValue* updateDelegatePtr = (NSValue*)[scope objectForKey:CHAT_UPDATE_DELEGATE];
	id<ChatUpdateDelegate> updateDelegate = (id<ChatUpdateDelegate>)[updateDelegatePtr pointerValue];
	
	/*
	 * updateDelegate may be nil but we can send a selector to nil
	 */
	[updateDelegate recievedChatUpdate:self];
}

@end
