//
//  ChatAppDelegate.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 2/24/10.
//  Copyright 2010 Texas A&M University. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XMLClient.h"
#import "GameKitXMLClient.h"
#import "ChatTranslations.h"

@class ChatViewController, ChatRoomViewController, WelcomeViewController;

@interface ChatAppDelegate : NSObject <UIApplicationDelegate, XMLClientDelegate> {
  UIWindow *window;
  GameKitXMLClient* client;
  ChatRoomViewController *chatRoomViewController;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet ChatRoomViewController *chatRoomViewController;
@property(nonatomic, retain) GameKitXMLClient *client;

// Show chat room
- (void)showChatRoom;

@end
