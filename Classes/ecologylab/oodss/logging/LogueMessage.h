//
//  LogueMessage.h
//  ecologylabXML
//
//  Generated by CocoaTranslator on 10/18/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import <Foundation/Foundation.h>
#import "LogEvent.h"


/*!
	@class		LogueMessage
	@abstract	This class is generated by CocoaTranslator. Annotated as: 
				@simpl_inherit
	@discussion	missing java doc comments or could not find the source file.
*/
@interface LogueMessage : LogEvent
{
	/*!
		@var		logName
		@abstract	Annotated as : 
					@simpl_scalar
		@discussion	missing java doc comments or could not find the source file.
	*/
	NSString *logName;

}

@property (nonatomic, readwrite, retain) NSString *logName;


@end

