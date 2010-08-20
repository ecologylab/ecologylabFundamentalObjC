#import "LogoutStatusResponse.h"
#import "AuthMessages.h"
#import "AuthClient.h"
#import "AuthClientRegistryObjects.h"

@implementation LogoutStatusResponse


+ (void) initialize {
	[LogoutStatusResponse class];
}

-(void) processResponse:(Scope*) scope
{
	id<AuthClient> auth = [((NSValue*)[scope objectForKey:MAIN_AUTHENTICABLE]) pointerValue];
	
	if(auth != nil)
	{
		[scope setObject:LOGIN_STATUS_STRING forKey:self.explanation];
		if([self isOk])
		{
			[auth loggedOut];
		}
	}
}

-(BOOL) isOk
{
	return [explanation isEqualToString:LOGOUT_SUCCESSFUL];
}

@end

