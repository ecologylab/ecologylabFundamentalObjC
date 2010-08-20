//
//  AuthMessages.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/19/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "AuthMessages.h"


NSString * const LOGIN_SUCCESSFUL = @"Successfully logged in.";
NSString * const LOGIN_FAILED_PASSWORD = @"Cannot log in: username/password combination not found.";
NSString * const LOGIN_FAILED_LOGGED_IN = @"Cannot log in: username already logged-in.";
NSString * const LOGIN_FAILED_NO_IP_SUPPLIED = @"Cannot log in: server unable to determine IP address.";
NSString * const CREATE_USER_FAILED_ALREADY_EXISTS = @"Could not create new user; user already exists.";
NSString * const LOGOUT_SUCCESSFUL = @"Successfully logged out.";
NSString * const LOGOUT_FAILED_IP_MISMATCH = @"Cannot log out: username and IP do not match.";
NSString * const LOGOUT_FAILED_NOT_LOGGEDIN = @"Cannot log out: username was not logged-in.";
NSString * const REQUEST_FAILED_NOT_AUTHENTICATED = @"Cannot process request, connection not yet authenticated.";
