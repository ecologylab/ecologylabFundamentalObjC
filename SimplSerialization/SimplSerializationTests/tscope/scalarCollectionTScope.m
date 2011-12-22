#import "scalarCollectionTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation scalarCollectionTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[ScalarCollection class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"scalarCollectionTScope.xml"];
		simplTypesScope = [BootStrap deserializeSimplTypesFromFile: path];
	}
	return simplTypesScope;
}

@end

