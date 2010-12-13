//
//  kismetsettingscontroller.h
//  kismetclient
//
//  Created by gm on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface kismetsettingscontroller : NSObject {
	IBOutlet NSTableView *prefsTable;
	IBOutlet NSTextField *path;
	NSArray *simpleSettings;
	NSArray *complexSettings;
	
	NSMutableDictionary *settingsDictionary;
}

-(IBAction) reloadConfig:(id)sender;

@end
