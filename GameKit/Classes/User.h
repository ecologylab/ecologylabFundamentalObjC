#import <Foundation/Foundation.h>
#import "ElementState.h"

@interface User : ElementState
{
	NSString *userKey;
	NSString *password;
	int level;
	long uid;
}

@property (nonatomic,readwrite, retain) NSString *userKey;
@property (nonatomic,readwrite, retain) NSString *password;
@property (nonatomic,readwrite) int level;
@property (nonatomic,readwrite) long uid;

- (void) setLevelWithReference: (int *) p_level;

- (void) setUidWithReference: (long *) p_uid;

@end

