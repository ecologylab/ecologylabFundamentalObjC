//
//  LogEvent.h
//  ecologylabXML
//
//  Generated by CocoaTranslator on 10/18/10.
//  Copyright 2010 Interface Ecology Lab. 
//

#import <Foundation/Foundation.h>
#import "RequestMessage.h"
@class StringBuilder;


/*!
	@class		LogEvent
	@abstract	This class is generated by CocoaTranslator. Annotated as: 
				@simpl_inherit
	@discussion	missing java doc comments or could not find the source file.
*/
@interface LogEvent : RequestMessage
{
	/*!
		@var		bufferToLog
		@abstract	Annotated as : 
					@simpl_scalar
					@simpl_hints
		@discussion	missing java doc comments or could not find the source file.
	*/
	StringBuilder *bufferToLog;

}

@property (nonatomic, readwrite, retain) StringBuilder *bufferToLog;


@end

