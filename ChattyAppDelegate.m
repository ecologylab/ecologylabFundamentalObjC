//
//  ChattyAppDelegate.m
//  Chatty
//
//  Copyright (c) 2009 Peter Bakhyryev <peter@byteclub.com>, ByteClub LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "ChattyAppDelegate.h"
#import "ChattyViewController.h"
#import "ChatRoomViewController.h"

static ChattyAppDelegate* _instance;

@implementation ChattyAppDelegate

@synthesize window;
@synthesize chatRoomViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  // Allow other classes to use us
  _instance = self;
  
  
  TranslationScope* scope = [DefaultServicesTranslations get];
  XMLClient* client = [[XMLClient alloc] initWithHostAddress:@"shady.cse.tamu.edu" andPort:2108 
                                         andTranslationScope:scope];
  [client retain];
  client.delegate = self;
  [client.scope setObject:[NSValue valueWithPointer:(self)] forKey:@"delegate"];
  [client connect];
  
  // Override point for customization after app launch
  [window addSubview:chatRoomViewController.view];
  [window makeKeyAndVisible];
  
  // Greet user
  [window bringSubviewToFront:chatRoomViewController.view];
  [self showChatRoom];
}


- (void)dealloc {
  [chatRoomViewController release];
  [window release];
  [super dealloc];
}


+ (ChattyAppDelegate*)getInstance {
  return _instance;
}


// Show chat room
- (void)showChatRoom
{
  [chatRoomViewController activate];  
  [window bringSubviewToFront:chatRoomViewController.view];
}


- (void) connectionTerminated:(XMLClient*)client
{
  NSLog(@"The connection terminated!\n");
  /*invoke on the same run loop a little while down the road*/
  [client performSelector:@selector(connect) withObject: nil afterDelay:10.00];
}

- (void) connectionAttemptFailed:(XMLClient*) connection
{
  NSLog(@"The connection failed to connect!\n");
}

- (void) connectionSuccessful:(XMLClient*) client withSessionId:(NSString*) sessionId;
{
  NSLog(@"Connection successful with session id:%@\n", sessionId);
  
  HistoryEchoRequest* request = [[HistoryEchoRequest alloc] init];
  
  [request setNewEcho:@"1"];
  
  /*invoke on the same run loop a little while down the road*/
  [client performSelector:@selector(sendMessage:) withObject: request afterDelay:0.25];
  
  [request release];
}
@end
