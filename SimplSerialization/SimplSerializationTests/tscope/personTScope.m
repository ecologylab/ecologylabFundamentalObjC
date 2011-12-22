#import "personTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation personTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[Person class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"personTScope.xml"];
		simplTypesScope = [[BootStrap deserializeSimplTypesFromFile: path] retain];
	}
	return simplTypesScope;
}

@end

