#import <Foundation/Foundation.h>
#import "User.h"

@interface UserWithEmail : User
{
	NSString *email;
}

@property (nonatomic,readwrite, retain) NSString *email;

@end

