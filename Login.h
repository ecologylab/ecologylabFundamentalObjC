#import <Foundation/Foundation.h>
#import "RequestMessage.h"
#import "User.h"

@interface Login : RequestMessage
{
	User *entry;
}

@property (nonatomic,readwrite, retain) User *entry;

@end

