/*!
	 @header	 Scope
	 @abstract   -
	 @discussion -
	 @updated    05/24/10
	 @created	 01/05/10
	 @author	 Nabeel Shahzad
	 @copyright  Interface Ecology Lab
 */

#import <Foundation/Foundation.h>


@interface Scope : NSObject 
{
	NSDictionary		*m_parent;
	NSMutableDictionary *mutableDictionary;
}

@property (readwrite, retain) NSDictionary *m_parent;

#pragma mark Scope - class initializers

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
+ (id) scope;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
+ (id) scopeWithParent: (NSDictionary *) parent;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
*/
+ (id) scopeWithCapacity: (NSUInteger) capacity;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
+ (id) scopeWithParentAndCapacity: (NSDictionary *) parent withCapacity: (NSUInteger) capacity;

#pragma mark Scope - instance initializers

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
- (id) initWithParent: (NSDictionary *) parent;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (id) initWithCapacity: (NSUInteger) capacity;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (id) initWithParentAndCapacity: (NSDictionary *) parent withCapacity: (NSUInteger) capacity;

#pragma mark Scope - instance functions

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 - 
 */
- (id) objectForKey: (id) aKey;

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
- (void) setParent: (NSDictionary *) newParent;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (NSDictionary *) operativeParent;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (NSString *) toString;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (NSString *) sizeMsg;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
 */
- (NSString *) dump;

/*!
	 @method     -
	 @abstract   -
	 @discussion -
	 @param		 -
	 @result	 -
*/
- (void) dump: (NSString *) result withPrefix: (NSString *) prefix;

@end