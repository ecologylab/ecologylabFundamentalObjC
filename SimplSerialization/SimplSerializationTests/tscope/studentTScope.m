#import "studentTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation studentTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[Person class];
	[Student class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"studentTScope.xml"];
		simplTypesScope = [BootStrap deserializeSimplTypesFromFile: path];
	}
	return simplTypesScope;
}

@end

