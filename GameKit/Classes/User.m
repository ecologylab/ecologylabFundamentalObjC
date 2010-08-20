#import "User.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDataAdditions.h"

@implementation User

@synthesize userKey;
@synthesize password;
@synthesize level;
@synthesize uid;

+ (void) initialize {
	[User class];
}

- (void) setLevelWithReference: (int *) p_level {
	level = *p_level;
}

- (void) setUidWithReference: (long *) p_uid {
	uid = *p_uid;
}

+ (NSString*) hashPassword:(NSString*) plaintextPassword
{
	CC_SHA256_CTX context;
	CC_SHA256_Init(&context);
	
	NSData* stringBytes = [plaintextPassword dataUsingEncoding:NSUTF8StringEncoding];
	
	CC_SHA256_Update(&context,[stringBytes bytes], [stringBytes length]);
	
	NSMutableData* hashedData = [NSMutableData dataWithLength:256];
	
	CC_SHA256_Final([hashedData mutableBytes] , &context);
	
	return [hashedData base64Encoding]; 
}

@end

