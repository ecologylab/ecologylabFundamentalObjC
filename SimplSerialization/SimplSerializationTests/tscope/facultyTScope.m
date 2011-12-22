#import "facultyTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation facultyTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[Person class];
	[Faculty class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"facultyTScope.xml"];
		simplTypesScope = [[BootStrap deserializeSimplTypesFromFile: path] retain];
	}
	return simplTypesScope;
}

@end

