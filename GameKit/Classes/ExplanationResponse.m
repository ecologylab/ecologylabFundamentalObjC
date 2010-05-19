#import "ExplanationResponse.h"

@implementation ExplanationResponse

@synthesize explanation;

+ (void) initialize {
	[ExplanationResponse class];
}

-(void) dealloc
{
	self.explanation = nil;
	
	[super dealloc];
}

@end

