#import "Login.h"

@implementation Login

@synthesize entry;

+ (void) initialize {
	[Login class];
}


+ (id) loginWithUserData : (NSString *) p_userKey withPassword : (NSString *) p_password withLevel : (int) p_level withUID : (long) p_uid
{
	return [Login loginWithUserObject:[User userWithUserData:p_userKey withPassword:p_password withLevel:p_level withUID:p_uid]];
}

+ (id) loginWithUserObject : (User *) p_entry
{
	return [[[Login alloc] initWithUserObject : p_entry] autorelease];
}

- (id) initWithUserObject : (User *) p_entry
{
	if(( self = [super init] ))
	{
		self.entry = p_entry;
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}


@end

