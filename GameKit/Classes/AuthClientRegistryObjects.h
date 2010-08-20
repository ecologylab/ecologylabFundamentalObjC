//
//  AuthClientRegistryObjects.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 5/19/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Indicates whether or not a client is logged in.
 * 
 * Type: NSValue w/ BOOL
 */
extern NSString * const LOGIN_STATUS;

/**
 * Indicates the most recent server response regarding logging-in.
 * 
 * Type: NSString*
 */
extern NSString * const LOGIN_STATUS_STRING;


/**
 * Points to the authenticating client;
 *
 * Type: NSValue
 */
extern NSString * const MAIN_AUTHENTICABLE;