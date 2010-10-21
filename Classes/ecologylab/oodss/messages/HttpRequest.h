//
//  HttpRequest.h
//  ecologylabXML
//
//  Generated by CocoaTranslator on 10/18/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import <Foundation/Foundation.h>
#import "RequestMessage.h"
#import "ParsedURL.h"


/*!
	@class		HttpRequest
	@abstract	This class is generated by CocoaTranslator. Annotated as: 
				@simpl_inherit
	@discussion	missing java doc comments or could not find the source file.
*/
@interface HttpRequest : RequestMessage
{
	/*!
		@var		okResponseUrl
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	ParsedURL *okResponseUrl;

	/*!
		@var		errorResponseUrl
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	ParsedURL *errorResponseUrl;

}

@property (nonatomic, readwrite, retain) ParsedURL *okResponseUrl;
@property (nonatomic, readwrite, retain) ParsedURL *errorResponseUrl;


@end

