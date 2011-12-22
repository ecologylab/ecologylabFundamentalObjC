/*!
	 @header	 DictionaryList
	 @abstract   -
	 @discussion -
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>


@interface DictionaryList : NSObject <NSFastEnumeration> 
{
	NSMutableArray		*mutableArray;
	NSMutableDictionary *mutableDictionary;
}

@property (readwrite, retain) NSMutableArray *mutableArray;

#pragma mark NSScope - class initializers

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
+ (id) dictionaryList;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
+ (id) dictionaryListFromCapacity: (NSUInteger) capacity;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
+ (id) dictionaryListFromDictionary: (NSDictionary *) dictionary;

#pragma mark NSScope - instance initializers

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
*/
- (id) init;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (id) initFromCapacity: (NSUInteger) capacity;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (id) initFromDictionary: (NSDictionary *) dictionary;

#pragma mark NSScope - instance functions

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (id) objectAtIndex: (NSUInteger) aKey;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (void) setObject: (id) anObject forKey: (id) aKey;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (NSArray *) allValues;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (void) recycle;

@end