#import "testingMapWithinMapsTScope.h"

#import "BootStrap.h"

static SimplTypesScope *simplTypesScope;

@implementation testingMapWithinMapsTScope

+ (SimplTypesScope *) simplTypesScope
{	
	[ClassDes class];
	[FieldDes class];
	[TranslationS class];

	if (simplTypesScope == nil)
	{
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"testingMapWithinMapsTScope.xml"];
		simplTypesScope = [BootStrap deserializeSimplTypesFromFile: path];
	}
	return simplTypesScope;
}

@end

