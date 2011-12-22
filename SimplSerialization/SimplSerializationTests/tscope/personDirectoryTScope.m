#import "personDirectoryTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation personDirectoryTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[Person class];
	[Student class];
	[PersonDirectory class];
	[Faculty class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"personDirectoryTScope.xml"];
		simplTypesScope = [BootStrap deserializeSimplTypesFromFile: path];
	}
	return simplTypesScope;
}

@end

