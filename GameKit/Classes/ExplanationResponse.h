#import <Foundation/Foundation.h>
#import "ResponseMessage.h"

@interface ExplanationResponse : ResponseMessage
{
	NSString *explanation;
}

@property (nonatomic,readwrite, retain) NSString *explanation;

@end

