//
//  XMLAuthDatagramClient.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/19/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDatagramClient.h"
#import "AuthClient.h"
#import "User.h"

@interface XMLAuthDatagramClient : XMLDatagramClient<AuthClient> {

	User* user;
	BOOL loggingIn;
	BOOL loggingOut;
	
}

@property(nonatomic, readwrite, retain) id<AuthClientDelegate> authDelegate;
@property(nonatomic, readonly, assign) BOOL isLoggingIn;
@property(nonatomic, readonly, assign) BOOL isLoggingOut;
@property(nonatomic, retain, readwrite) User* user;

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
					 user:(User*) u
			doCompression:(BOOL) compress;
- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
					 user:(User*) u;

- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope
					doCompression:(BOOL) compress;
- (id)initWithHostAddress:(NSString*)host andPort:(UInt16) port 
	  andTranslationScope:(TranslationScope*) transScope;

-(NSString*) getExplanation;
-(void) login;
-(void) logout;

@end
