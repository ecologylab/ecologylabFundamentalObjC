//
//  RequestMessage.h
//  ecologylabXML
//
//  Created by ecologylab on 1/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ServiceMessage.h"
#import "ResponseMessage.h"
#import "Scope.h"

@interface RequestMessage : ServiceMessage
{
}

-(ResponseMessage *) PerformService:(Scope*) scope;

@end