//
//  ServerPicker.h
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/28/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameKitXMLClient.h"
#import "ServerPickerDelegate.h"

@interface ServerPicker : NSObject<UIPickerViewDelegate, UIPickerViewDataSource, GKSessionDelegate> {
	UIActionSheet* actionSheet;
	UIPickerView* pickerView;
	id<ServerPickerDelegate> delegate;
	NSArray* serverNames;
	NSArray* serverIds;
	UISegmentedControl *closeButton;
	GKSession* session;
}

@property(retain, readwrite) id<ServerPickerDelegate> delegate;

-(id) initWithSessionId:(NSString*) sessionId displayName:(NSString*) name;

-(void) show;

@end
