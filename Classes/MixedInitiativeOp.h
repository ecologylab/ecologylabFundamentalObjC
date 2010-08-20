//
//  MixedInitiativeOp.h
//  ecologylabXML
//
//  Generated by CocoaTranslator on 08/19/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import <Foundation/Foundation.h>
#import "BasicOp.h"


/*!
	@class		MixedInitiativeOp
	@abstract	This class is generated by CocoaTranslator. Annotated as: 
				@simpl_inherit
	@discussion	missing java doc comments or could not find the source file.
*/
@interface MixedInitiativeOp : BasicOp
{
	/*!
		@var		intensity
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	short intensity;

	/*!
		@var		invert
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	bool invert;

	/*!
		@var		action
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	NSString *action;

	/*!
		@var		recordTime
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	long recordTime;

}

@property (nonatomic, readwrite) short intensity;
@property (nonatomic, readwrite) bool invert;
@property (nonatomic, readwrite, retain) NSString *action;
@property (nonatomic, readwrite) long recordTime;

- (void) setIntensityWithReference: (short *) p_intensity;
- (void) setInvertWithReference: (bool *) p_invert;
- (void) setRecordTimeWithReference: (long *) p_recordTime;

@end
