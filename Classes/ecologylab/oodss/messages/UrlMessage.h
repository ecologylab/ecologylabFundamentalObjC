//
//  UrlMessage.h
//  ecologylabXML
//
//  Generated by CocoaTranslator on 10/18/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import <Foundation/Foundation.h>
#import "RequestMessage.h"


/*!
	@class		UrlMessage
	@abstract	This class is generated by CocoaTranslator. Annotated as: 
				@simpl_inherit
	@discussion	missing java doc comments or could not find the source file.
*/
@interface UrlMessage : RequestMessage
{
	/*!
		@var		url
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	NSString *url;

	/*!
		@var		collection
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	NSString *collection;

}

@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) NSString *collection;


@end
