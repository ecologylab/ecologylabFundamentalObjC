//
//  XMLAuthDatagramClient.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/19/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "XMLAuthDatagramClient.h"
#import "AuthClientRegistryObjects.h"
#import "Login.h"
#import "Logout.h"

@interface XMLAuthDatagramClient (Private)

@property(readwrite, assign) BOOL isLoggingIn;
@property(readwrite, assign) BOOL isLoggingOut;

-(void) sendLoginMessage;
-(void) sendLogoutMessage;

@end

@implementation XMLAuthDatagramClient

@synthesize isLoggingIn = loggingIn, isLoggingOut = loggingOut, user, delegate;

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
					 user:(User*) u
			doCompression:(BOOL) compress
{
	if((self = [super initWithHostAddress:host andPort:port andTranslationScope:transScope doCompression:compress]))
	{
		self.user = u;
		self.isLoggingIn = NO;
		self.isLoggingOut = NO;
		
		NSValue* selfPointerWrapper = [NSValue valueWithPointer: self];
		[scope setObject:selfPointerWrapper forKey:MAIN_AUTHENTICABLE];
	}
	return self;
}

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
					 user:(User*) u
{
	return [self initWithHostAddress:host andPort:port andTranslationScope:transScope user:u doCompression:NO];
}

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
			doCompression:(BOOL) compress
{
	return [self initWithHostAddress:host andPort:port andTranslationScope:transScope user:nil doCompression:compress];
}

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
{
	return [self initWithHostAddress:host andPort:port andTranslationScope:transScope user:nil doCompression:NO];
}

-(void) login
{
	if(user != nil)
	{
		self.isLoggingIn = YES;
		self.isLoggingOut = NO;
		
		[self sendLoginMessage];
	}
}

-(void) logout
{
	if(user != nil)
	{
		self.isLoggingIn = NO;
		self.isLoggingOut = YES;
		
		[self sendLogoutMessage];
	}
}

-(void) sendLoginMessage
{
	Login* req = [[[Login alloc] init] autorelease];
	req.entry = user;
	
	[self sendMessage:req];
}

-(void) sendLogoutMessage
{
	Logout* req = [[[Logout alloc] init] autorelease];
	req.entry = user;
	
	[self sendMessage:req];
}

-(void) loginSucceeded
{
	self.isLoggingIn = NO;
	self.isLoggingOut = NO;
	[self.delegate loginSucceeded];
}

-(void) loginFailed
{
	self.isLoggingIn = NO;
	self.isLoggingOut = NO;
	[self.delegate loginFailed];
}

-(void) loggedOut
{
	self.isLoggingIn = NO;
	self.isLoggingOut = NO;
	[self.delegate loggedOut];
}

-(NSString*) getExplanation
{
	NSString* tmp = [scope objectForKey:LOGIN_STATUS_STRING];
	
	if(tmp == nil)
	{
		return @"";
	}
	
	return tmp;
}

-(void) dealloc
{
	self.user = nil;
	
	[super dealloc];
}

@end
