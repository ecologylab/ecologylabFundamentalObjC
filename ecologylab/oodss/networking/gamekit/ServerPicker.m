//
//  ServerPicker.m
//  ecologylabFundamentalObjC
//
//  Created by William Hamilton on 3/28/10.
//  Copyright 2010 Texas A&M University Department of Computer Science and Engineering. All rights reserved.
//

#import "ServerPicker.h"

@interface ServerPicker ()

@property(retain, readwrite) NSArray* serverNames;
@property(retain, readwrite) NSArray* serverIds;

-(void) updatePicker;
-(void) initActionSheet;

@end

@implementation ServerPicker

@synthesize delegate, serverNames, serverIds;

-(id) initWithSessionId:(NSString*) sessionId displayName:(NSString*) name
{
	if(self = [super init])
	{
		[self initActionSheet];
		
		session = [[GKSession alloc] initWithSessionID:sessionId displayName:name sessionMode:GKSessionModeClient];
		
		session.available = 1;
		session.delegate = self;
		
		serverNames = [[NSArray alloc] init];
	}
	return self;
}

- (void) initActionSheet
{
	actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Server\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	CGRect pickerFrame = CGRectMake(0, 80, 0, 0);
	
	pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	pickerView.showsSelectionIndicator = YES;
	pickerView.dataSource = self;
	pickerView.delegate = self;
	pickerView.backgroundColor = [UIColor clearColor];
	
	
	[actionSheet addSubview:pickerView];
	[pickerView release];
	
	closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Connect" , @"Cancel" , nil]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(70.0f, 35.0f, 180.0f, 40.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	[closeButton setEnabled:NO forSegmentAtIndex:0];
	
	//closeButton.tintColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
	[actionSheet addSubview:closeButton];
	[closeButton release];
	
	UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner autorelease];
	[spinner setCenter:CGPointMake(285, 40)]; // I do this because I'm in landscape mode
	
	[actionSheet addSubview:spinner]; // spinner is not visible until started
	
	[spinner startAnimating];
	
	[actionSheet setBounds:CGRectMake(0, 0, 320, 300)];
}

- (void) show
{
	[actionSheet showInView:([UIApplication sharedApplication].keyWindow)];
	[self updatePicker];
}

- (void) segmentSelected:(id) action
{
	int index = closeButton.selectedSegmentIndex;
	
	/*Selected*/
	if(index == 0)
	{
		[delegate pickedServer:[serverIds objectAtIndex:[pickerView selectedRowInComponent:0]] onSession:session];
	}
	/*Cancled*/
	else if (index == 1)
	{
		[delegate cancelSelected];
	}
	
	[actionSheet dismissWithClickedButtonIndex:index animated:YES];
}

/* UIPickerViewDataSource callbacks */

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return MAX([serverNames count], 1);
}

/* UIPickerViewDelegate callbacks */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	/* don't care */
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return ([serverNames count] == 0)?@"Searching for Servers":[serverNames objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 300.0f;
}

-(void) updatePicker
{
	NSArray* sessions = [session peersWithConnectionState:GKPeerStateAvailable];
	NSMutableArray* sessionNames = [NSMutableArray arrayWithCapacity:[sessions count]];
	for(int x = 0; x < [sessions count]; x++)
	{
		[sessionNames addObject:[session displayNameForPeer:[sessions objectAtIndex:0]]];
	}
	
	self.serverNames = sessionNames;
	self.serverIds = sessions;
	
	[pickerView reloadComponent:0];
	
	if([sessionNames count] >= 1)
	{
		[closeButton setEnabled:YES forSegmentAtIndex:0];
	}
	else
	{
		[closeButton setEnabled:NO forSegmentAtIndex:0];
	}
}

/* GKSessionDelegate callbacks */
- (void)session:(GKSession *)s peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	if(state == GKPeerStateAvailable || state == GKPeerStateUnavailable )
	{
		[self updatePicker];
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	/* Shouldn't recieve any of these */
	NSLog(@"WhatJ!\n\\n\n\n\n\n\n\n");
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	NSLog(@"Serious error occurred: %s", [error description]);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
	/*Shouldn't get these*/
}

-(void) dealloc
{
	[actionSheet release];
	actionSheet = nil;
	
	[pickerView release];
	pickerView = nil;
	
	[closeButton release];
	closeButton = nil;
	
	self.delegate = nil;
	self.serverNames = nil;
	self.serverIds = nil;
	
	NSLog(@"ActionSheet released!");
	
	[super dealloc];
}
@end
