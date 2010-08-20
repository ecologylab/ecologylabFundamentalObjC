#import "LoginStatusResponse.h"
#import "AuthClientRegistryObjects.h"
#import "Authclient.h"
#import "AuthMessages.h"

@implementation LoginStatusResponse


+ (void) initialize {
	[LoginStatusResponse class];
}

-(void) processResponse:(Scope*) scope
{
	id<AuthClient> auth = [((NSValue*)[scope objectForKey:MAIN_AUTHENTICABLE]) pointerValue];
	
	if(auth != nil)
	{
		[scope setObject:LOGIN_STATUS_STRING forKey:self.explanation];
		if([self isOk])
		{
			[auth loginSucceeded];
		}
		else 
		{
			[auth loginFailed];
		}
	}
}

-(BOOL) isOk
{
	return [explanation isEqualToString:LOGIN_SUCCESSFUL];
}

@end

