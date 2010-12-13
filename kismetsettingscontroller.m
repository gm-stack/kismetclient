//
//  kismetsettingscontroller.m
//  kismetclient
//
//  Created by Geordie Millar on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "kismetsettingscontroller.h"


@implementation kismetsettingscontroller

-(void) awakeFromNib {
	simpleSettings = [[NSArray arrayWithObjects:@"version",@"servername",@"logprefix",@"hidedata",@"allowplugins",
					 @"preferredchannels", @"channelvelocity", @"channeldwell", @"allowedhosts", @"maxclients", @"maxbacklog",
					 @"gps", @"gpstype", @"gpsdevice", @"gpshost", @"gpsmodelock", @"gpsreconnect", @"logtypes", @"speechencoding",nil] retain];
	
	complexSettings = [[NSArray arrayWithObjects:@"ncsource",@"enablesources",@"channellist",@"ouifile", @"alert", @"apspoof", @"sound", @"logtypes", nil] retain];
	
	settingsDictionary = [[NSMutableDictionary dictionaryWithCapacity:20] retain];
	
	for (int i=0; i<[complexSettings count]; i++) {
		[settingsDictionary setObject:[NSMutableArray arrayWithCapacity:1] forKey:[complexSettings objectAtIndex:i]];
	}
	
	[prefsTable reloadData];
	NSLog(@"inited");
	return;
}

-(IBAction) reloadConfig:(id)sender {
	NSString *config = [NSString stringWithContentsOfFile:[path stringValue]];
	NSArray *configArray = [config componentsSeparatedByString:@"\n"];
	NSMutableArray *configParts = [NSMutableArray arrayWithCapacity:20];
	for (int i=0; i<[configArray count]; i++) {
		NSString *str = [configArray objectAtIndex:i];
		if (([str length] >= 1) && (![[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"])) {
			[configParts addObject:[configArray objectAtIndex:i]];
			}
	}
	NSLog(@"configParts %@",configParts);
	for (int i=0; i<[configParts count]; i++) {
		NSArray *configItem = [[configParts objectAtIndex:i] componentsSeparatedByString:@"="];
		if ([complexSettings containsObject:[configItem objectAtIndex:0]]) {
			[[settingsDictionary objectForKey:[configItem objectAtIndex:0]] addObject:[configItem objectAtIndex:1]];
		} else {
			[settingsDictionary setObject:[configItem objectAtIndex:1] forKey:[configItem objectAtIndex:0]];
		}
	}
	NSLog(@"settingsDictionary %@", settingsDictionary);
	[prefsTable reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [simpleSettings count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
			row:(int)row
{
	if ([[tableColumn identifier] isEqualToString:@"Name"]) {
		return [simpleSettings objectAtIndex:row];
	} else {
		return [settingsDictionary objectForKey:[simpleSettings objectAtIndex:row]];
	}
}


@end
