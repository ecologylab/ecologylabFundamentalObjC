#import "classDTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation classDTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[ClassD class];
	[ClassC class];
	[ClassB class];
	[ClassA class];
	[ClassX class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"classDTScope.xml"];
		simplTypesScope = [BootStrap deserializeSimplTypesFromFile: path];
	}
	return simplTypesScope;
}

@end

