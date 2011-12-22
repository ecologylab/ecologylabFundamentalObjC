#import "RssSimplTypes.h"
#import "BootStrap.h"

static SimplTypesScope *simplTypeScope;

@implementation RssSimplTypes

+ (SimplTypesScope *) simplTypeScope
{	
	[Channel class];
	[Item class];

	if (simplTypeScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"RssSimplTypes.xml"];
		simplTypeScope = [[BootStrap deserializeSimplTypesFromFile: path] retain];
	}
	return simplTypeScope;
}

@end

