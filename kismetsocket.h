//
//  kismetsocket.h
//  kismetclient
//
//  Created by Geordie Millar on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "networkutils.h"
#import "signalnoiseview.h"

@class AsyncSocket;

@interface kismetsocket : NSObject {
	IBOutlet NSTableView *table;
	IBOutlet NSTableView *netTable;
	IBOutlet signalnoiseview *sigview;
	AsyncSocket *socket;
	NSMutableDictionary *netDict;
	NSMutableDictionary *BSSIDdict;
	NSMutableDictionary *currentNetInfo;
	NSMutableArray *netArray;
	
	NSArray *netInfoHeaders;
	int time;

}


- (IBAction) connect2:(id)sender;
- (void)connect:(NSString *)server port:(unsigned int)port;
- (IBAction)tableViewSelected:(id)sender;

@property (readonly)int time;

@end
