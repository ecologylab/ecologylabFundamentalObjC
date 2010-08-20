#import <Foundation/Foundation.h>
#import "DisconnectRequest.h"
#import "User.h"

@interface Logout : DisconnectRequest
{
	User *entry;
}

@property (nonatomic,readwrite, retain) User *entry;

@end

