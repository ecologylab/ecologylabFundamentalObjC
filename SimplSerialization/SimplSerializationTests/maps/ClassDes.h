//
//  ClassDescriptor.h
//  ecologylabXML
//
//  Generated by CocoaTranslator on 12/14/11.
//  Copyright 2011 Interface Ecology Lab. 
//

#import <Foundation/Foundation.h>


/*!
	@class		ClassDes
	@abstract	This class is generated by CocoaTranslator. Annotated as: 
				@simpl_inherit
	@discussion	missing java doc comments or could not find the source file.
*/
@interface ClassDes : NSObject
{
	/*!
		@var		tagName
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	NSString *tagName;

	/*!
		@var		fieldDescriptorsByTagName
		@abstract	Annotated as : 
					@simpl_nowrap
					@simpl_map
		@discussion	missing java doc comments or could not find the source file.
	*/
	NSDictionary *fieldDescriptorsByTagName;

}

@property (nonatomic, readwrite, retain) NSString *tagName;
@property (nonatomic, readwrite, retain) NSDictionary *fieldDescriptorsByTagName;


@end

