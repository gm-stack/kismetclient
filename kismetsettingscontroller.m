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
					 @"preferredchannels", @"channelvelocity", @"channeldwell", @"listen",@"allowedhosts", @"maxclients", @"maxbacklog",
					 @"gps", @"gpstype", @"gpsdevice", @"gpshost", @"gpsmodelock", @"gpsreconnect", @"tuntap_export", @"tuntap_device",
					 @"allowkeytransmit", @"writeinterval", @"enablesound", @"soundbin", @"enablespeech", @"speechbin", @"speechtype",
					 @"speechencoding",@"alertbacklog",@"pcapdumpformat", @"logdefault", @"logtemplate", @"configdir",nil] retain];
	
	complexSettings = [[NSArray arrayWithObjects:@"ncsource",@"enablesources",@"channellist",@"ouifile", @"alert", @"apspoof", @"wepkey",
						@"sound", @"logtypes", nil] retain];
	
	settingsDictionary = [[NSMutableDictionary dictionaryWithCapacity:20] retain];
	
	for (int i=0; i<[complexSettings count]; i++) {
		[settingsDictionary setObject:[NSMutableArray arrayWithCapacity:1] forKey:[complexSettings objectAtIndex:i]];
	}
	
	//[prefsTable reloadData];
	NSLog(@"inited");
	return;
}

-(IBAction) reloadConfig:(id)sender {
		
	NSString *config = [NSString stringWithContentsOfFile:[path stringValue] encoding:NSUTF8StringEncoding error:nil];
	NSArray *configArray = [config componentsSeparatedByString:@"\n"];
	NSMutableArray *configParts = [NSMutableArray arrayWithCapacity:20];
	
	NSEnumerator *e = [configArray objectEnumerator];
	NSString *str;
	while ((str = [e nextObject])) {
		if (([str length] >= 1) && (![[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"])) {
			[configParts addObject:str];
			}
	}

	NSEnumerator *e2 = [configParts objectEnumerator];
	NSString *configLine;
	while ((configLine = [e2 nextObject])) {
		NSRange equalsRange = [configLine rangeOfString:@"="];
		
		NSString *settingName = [configLine substringToIndex:equalsRange.location];
		NSString *settingValue = [configLine substringFromIndex:equalsRange.location+1];
		
		if ([complexSettings containsObject:settingName]) {
			[[settingsDictionary objectForKey:settingName] addObject:settingValue];
		} else {
			[settingsDictionary setObject:settingValue forKey:settingName];
		}
	}
	NSLog(@"settingsDictionary %@", settingsDictionary);
	
	[prefsTable reloadData];
	[sourcesTable reloadData];
	[channelTable reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (tableView == prefsTable) {
		return [simpleSettings count];
	} else if (tableView == sourcesTable) {
		return [[settingsDictionary objectForKey:@"ncsource"] count];
	} else if (tableView == channelTable) {
		return [[settingsDictionary objectForKey:@"channellist"] count];
	}
	NSLog(@"Unknown TableView");
	return 0;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
			row:(int)row
{
	if (tableView == prefsTable) {
		if ([[tableColumn identifier] isEqualToString:@"Name"]) {
			return [simpleSettings objectAtIndex:row];
		} else {
			return [settingsDictionary objectForKey:[simpleSettings objectAtIndex:row]];
		}
	} else if (tableView == sourcesTable) {
		NSString *sourceString = [[settingsDictionary objectForKey:@"ncsource"] objectAtIndex:row];
		NSRange colRange = [sourceString rangeOfString:@":"];
				
		if ([[tableColumn identifier] isEqualToString:@"Enabled"]) {
			if ([[settingsDictionary objectForKey:@"enablesources"] count] == 0) {
				return [NSNumber numberWithBool:YES];
			} else {
				//if ([settingsDictionary objectForKey:@"enablesources"]
				return [NSNumber numberWithBool:YES];
			}
		} else if ([[tableColumn identifier] isEqualToString:@"Name"]) {
			if (colRange.length > 0) {
				return [sourceString substringToIndex:colRange.location];
			} else {
				return sourceString;
			}
		} else {
			if (colRange.length > 0) {
				return [sourceString substringFromIndex:colRange.location+1];
			} else {
				return @"";
			}
		}
	} else if (tableView == channelTable) {
		NSString *sourceString = [[settingsDictionary objectForKey:@"channellist"] objectAtIndex:row];
		NSRange colRange = [sourceString rangeOfString:@":"];
		
		if ([[tableColumn identifier] isEqualToString:@"Name"]) {
			return [sourceString substringToIndex:colRange.location];
		} else {
			return [sourceString substringFromIndex:colRange.location+1];
		}
	}
	
	NSLog(@"Unknown TableView");
	return @"";
}


@end
