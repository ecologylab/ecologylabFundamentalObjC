/*!
	 @header	 ParsedURL
	 @abstract   -
	 @discussion -
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>

@class ElementState;
@class SimplTypesScope;

@interface ParsedURL : NSObject 
{
	NSURL		 *url;
	NSFileHandle *file;
	NSURL		 *hashUrl;
	NSURL		 *directory;
	ParsedURL	 *directoryPURL;
	NSString	 *string;
	NSString	 *shortString;
	NSString	 *lc;
	NSString	 *suffix;
	NSString	 *domain;
}

+ (id) parsedURLWithURL: (NSURL *) newURL;
+ (id) parsedURLWithFile: (NSFileHandle *) fileHandle;
+ (id) parsedURLWithAbsoluteAddress: (NSString *) webAddr;
+ (id) parsedURLWithAbsoluteAddress: (NSString *) webAddr withErrorDescription: (NSString *) errorDescription;
+ (id) parsedURLWithRelativePath: (NSURL *) url relativeURLPath: (NSString *) relativeURLPath withErrorDescription: (NSString *) errorDescription;
+ (NSURL *) getURL: (NSURL *) base withPath: (NSString *) path withErro: (NSString *) error;

- (id) iniWithURL: (NSURL *) newURL;
- (id) initWithFile: (NSFileHandle *) fileHandle;

- (BOOL) isUndetectedMalformedURL: (NSURL *) url;
- (BOOL) isNotFileOrExisits;
- (ParsedURL *) getRelative: (NSString *) relativeURLPath;
- (ParsedURL *) getRelative: (NSString *) relativeURLPath withErrorDescription: (NSString *) errorDescription;
- (ElementState *) translateFromXML: (SimplTypesScope *) TranslationScope;
- (NSString *) description;
- (NSString *) lc;
- (NSString *) suffix;
- (NSString *) suffix: (NSString *) lc;
- (ParsedURL *) directoryPURL;
- (NSURL *) directory;
- (NSString *) domain;
- (NSString *) filename;
- (NSURL *) url;
- (NSURL *) hashUrl;
- (BOOL) isNull;
- (NSString *) noAnchorNoQueryPageString;
- (NSString *) noAnchorPageString;
- (BOOL) hasSuffix: (NSString *) s;
- (NSString *) toString;

@end