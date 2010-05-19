//
//  ChatAppDelegate.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 2/24/10.
//  Copyright 2010 Texas A&M University. All rights reserved.
//
#import "ChatAppDelegate.h"
#import "ChatViewController.h"
#import "ChatRoomViewController.h"
#import "ServerPicker.h"
#import "GameKitXMLServer.h"

/*
 App Delegate
 */
@implementation ChatAppDelegate

@synthesize window;
@synthesize chatRoomViewController;
@synthesize client;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{         
	/*
	 * Get an instance of the ChatTranslations scope.
	 */
	TranslationScope* scope = [DefaultServicesTranslations get];
    
	/*
	 * Initialize the client with the ChatTranslations scope.
	 */
	/*
	 /*self.client = [[XMLClient alloc] initWithHostAddress:@"shady.cse.tamu.edu" andPort:2108 
	 andTranslationScope:scope];*/
	
	
	/*
	 * Set the ChatRoomViewController's client as the client.
	 */
	//chatRoomViewController.client = self.client;
	
	/*
	 * Set up the chatRoomViewController as the CHAT_UPDATE_DELEGATE in the application scope.
	 */
	//[self.client.scope setObject:[NSValue valueWithPointer:(chatRoomViewController)] forKey:CHAT_UPDATE_DELEGATE];
	
	[window addSubview:chatRoomViewController.view];
	[window makeKeyAndVisible];
	
	/*
	 * Connect the client to the server.
	 */
	//[self.client connect];
	
	Scope* applicationScope = [[Scope alloc] init];
	
	//self.client = [[GameKitXMLClient alloc] initWithSessionID:@"dude" displayName:@"dude" translationScope:scope delgate:self appScope:applicationScope];
	//GameKitXMLServer* server = [[GameKitXMLServer alloc] initWithSessionID:@"rummy" displayName:@"Test Server" translationScope:scope];
	self.client = [[XMLDatagramClient alloc] initWithHostAddress:@"localhost" andPort:2107 
											 andTranslationScope: scope 
												   doCompression: YES];
	self.client.delegate = self;
		
	/*
	 * Designate self as the client's delegate.
	 */
	//self.client.delegate = self;
	
	
	
	
	/*ServerPicker* picker = [[ServerPicker alloc] initWithSessionId:@"dude" displayName:@"Client"];
	 [picker showd];*/
	
	
}


- (void)dealloc {
	[chatRoomViewController release];
	[window release];
	[super dealloc];
}

/*
 * Show chat room
 */
- (void)showChatRoom
{
	[chatRoomViewController activate];  
	[window bringSubviewToFront:chatRoomViewController.view];
}



/*
 * XMLClientDelegate methods:
 */
- (void) connectionTerminated:(id<Client>)client
{
	NSLog(@"The connection terminated!\n");
	
}

- (void) connectionAttemptFailed:(id<Client>) connection
{
	NSLog(@"The connection failed to connect!\n");
}

- (void) connectionSuccessful:(id<Client>) client withSessionId:(NSString*) sessionId;
{
	/*
	 * Show the chat window after the client has connected.
	 */ 
	[window bringSubviewToFront:chatRoomViewController.view];
	[self showChatRoom];
	
	NSLog(@"Connection successful with session id:%@\n", sessionId);
	
	HistoryEchoRequest* req = [[HistoryEchoRequest alloc] init];
	req.newEcho = @"1";
	
	
	[client sendMessage:req];
	
	[req release];
}

- (void) reconnectSuccessful:(id<Client>) connection
{
	NSLog(@"Reconnected successfully!");
}

- (void) restablishSessionFailed:(id<Client>) connection withSessionId:(NSString*) sessionId
{
	NSLog(@"Failed to restablish connection!");
}

/*
 * Close the connection when the user hits the home button.
 */
- (void) applicationWillTerminate:(UIApplication*) application
{
	//[client disconnect];
}
@end
