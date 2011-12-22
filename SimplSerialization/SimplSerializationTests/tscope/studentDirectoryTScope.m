#import "studentDirectoryTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation studentDirectoryTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[Person class];
	[Student class];
	[StudentDirectory class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"studentDirectoryTScope.xml"];
		simplTypesScope = [BootStrap deserializeSimplTypesFromFile: path];
	}
	return simplTypesScope;
}

@end

