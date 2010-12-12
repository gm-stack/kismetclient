//
//  kismetsocket.m
//  kismetclient
//
//  Created by Geordie Millar on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "kismetsocket.h"


@implementation kismetsocket

- (IBAction) connect2:(id)sender {
	[self connect:@"127.0.0.1" port:2501];
}


- (void) connect:(NSString *)server port:(unsigned int)port {
	socket = [[AsyncSocket alloc] initWithDelegate:self];
	BOOL success = [socket connectToHost:server onPort:port error:nil];
	if (success) {
		NSLog(@"connected");
		netArray = [[NSMutableDictionary alloc] init];
		BSSIDinfo = [[NSMutableDictionary alloc] init];
		[table reloadData];
		[socket writeData:[@"!0 ENABLE ssid mac,checksum,type,cryptset,cloaked,firsttime,lasttime,maxrate,beaconrate,\
packets,beacons,dot11d,ssid,\n" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:0];
		[socket writeData:[@"!0 ENABLE client bssid,mac,type,firsttime,lasttime,manuf,llcpackets,datapackets,cryptpackets,\
gpsfixed,minlat,minlon,minalt,maxlat,maxlon,maxalt,agglat,agglon,aggalt,aggpoints,signal_dbm,noise_dbm,minsignal_dbm,\
minnoise_dbm,maxsignal_dbm,maxnoise_dbm,signal_rssi,noise_rssi,minsignal_rssi,minnoise_rssi,maxsignal_rssi,maxnoise_rssi,\
bestlat,bestlon,bestalt,atype,ip,gatewayip,datasize,maxseenrate,encodingset,carrierset,decrypted,channel,fragments,retries,\
newpackets,freqmhz,cdpdevice,cdpport,dhcphost,dhcpvendor,datacryptset,\n" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:0];
		[socket writeData:[@"!34 ENABLE bssid bssid,type,llcpackets,datapackets,cryptpackets,manuf,channel,firsttime,lasttime,atype,\
rangeip,netmaskip,gatewayip,gpsfixed,minlat,minlon,minalt,minspd,maxlat,maxlon,maxalt,maxspd,signal_dbm,noise_dbm,minsignal_dbm,\
minnoise_dbm,maxsignal_dbm,maxnoise_dbm,signal_rssi,noise_rssi,minsignal_rssi,minnoise_rssi,maxsignal_rssi,maxnoise_rssi,bestlat,\
bestlon,bestalt,agglat,agglon,aggalt,aggpoints,datasize,turbocellnid,turbocellmode,turbocellsat,carrierset,maxseenrate,encodingset,\
decrypted,dupeivpackets,bsstimestamp,cdpdevice,cdpport,fragments,retries,newpackets,freqmhz,datacryptset,\n" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:0];
		[socket readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
	} else {
		NSLog(@"error");
	}
	
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag {
	NSString *datastr = [NSString stringWithCString:[data bytes] length:[data length]];
	//NSLog(@"read %@",datastr);
	[socket readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
	
	NSRange ran = [datastr rangeOfString:@": "];
	if (ran.length) {
		NSString *type = [datastr substringToIndex:ran.location];
		//NSLog(@"Packet type %@",type);
		
		ran.location += 2;
		ran.length = [datastr length] - (ran.location+2);
		NSString *msg = [datastr substringWithRange:ran];
		
		if ([type isEqualToString:@"*TIME"]) {
			time = [msg intValue];
			//NSLog(@"time is %i", time);
		} else if ([type isEqualToString:@"*SSID"]) {
			NSArray *p = [msg componentsSeparatedByString:@"\x01"];
			NSArray *p2 = [[p objectAtIndex:0] componentsSeparatedByString:@" "];
			NSString *ssid = [p objectAtIndex:3];
			if ([[p2 objectAtIndex:4] isEqualToString:@"1"]) {
				ssid = @"<hidden SSID>";
			}
			
			if ([netArray objectForKey:[p2 objectAtIndex:0]] == nil) {
				[netArray setObject:[[NSMutableDictionary alloc] initWithCapacity:12] forKey:[p2 objectAtIndex:0]];
			}
			
			NSMutableDictionary *network = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											ssid,@"SSID",
											[p objectAtIndex:1],@".11d",
											[p2 objectAtIndex:0],@"BSSID",
											[p2 objectAtIndex:1],@"Checksum",		
											[networkutils networkType:[p2 objectAtIndex:2]],@"Type",	
											[networkutils securityMode:[p2 objectAtIndex:3]],@"Crypt Set",	
											[networkutils time:[p2 objectAtIndex:5]],@"First Time",	
											[networkutils time:[p2 objectAtIndex:6]],@"Last Time",	
											[p2 objectAtIndex:7],@"Max Rate",		
											[p2 objectAtIndex:8],@"Beacon Rate",	
											[p2 objectAtIndex:9],@"Packets",		
											[p2 objectAtIndex:10],@"Beacons",				
											nil];
			
			[[netArray objectForKey:[p2 objectAtIndex:0]] setValuesForKeysWithDictionary:network];
			[table reloadData];
		} else if ([type isEqualToString:@"*BSSID"]) {
			//NSLog(@"msg %@",msg);
			NSArray *p = [msg componentsSeparatedByString:@"\x01"];
			NSArray *p2 = [[p objectAtIndex:0] componentsSeparatedByString:@" "];
			NSArray *p3 = [[p objectAtIndex:2] componentsSeparatedByString:@" "];
			NSArray *p4 = [[p objectAtIndex:6] componentsSeparatedByString:@" "];
			//NSLog(@"p %@\n p2 %@\n p3 %@\np4 %@\n",p,p2,p3,p4);
			
			if ([BSSIDinfo objectForKey:[p2 objectAtIndex:0]] == nil) {
				[BSSIDinfo setObject:[[NSMutableDictionary alloc] initWithCapacity:12] forKey:[p2 objectAtIndex:0]];
			}
			
			NSMutableDictionary *network = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											[p2 objectAtIndex:0],@"BSSID",
											[p2 objectAtIndex:1],@"Type",
											[p2 objectAtIndex:2],@"llcpackets",
											[p2 objectAtIndex:3],@"datapackets",
											[p2 objectAtIndex:4],@"cryptpackets",
											
											[p objectAtIndex:1],@"Manufacturer",
											
											[p3 objectAtIndex:1],@"Channel",
											[p3 objectAtIndex:2],@"firsttime",
											[p3 objectAtIndex:3],@"lasttime",
											[p3 objectAtIndex:4],@"atype",
											[p3 objectAtIndex:5],@"rangeip",
											[p3 objectAtIndex:6],@"netmaskip",
											[p3 objectAtIndex:7],@"gatewayip",
											[p3 objectAtIndex:8],@"gpsfixed",
											[p3 objectAtIndex:9],@"minlat",
											[p3 objectAtIndex:10],@"minlon",
											[p3 objectAtIndex:11],@"minalt",
											[p3 objectAtIndex:12],@"minspd",
											[p3 objectAtIndex:13],@"maxlat",
											[p3 objectAtIndex:14],@"maxlon",
											[p3 objectAtIndex:15],@"maxalt",
											[p3 objectAtIndex:16],@"maxspd",
											[p3 objectAtIndex:17],@"signal_dbm",
											[p3 objectAtIndex:18],@"noise_dbm",
											[p3 objectAtIndex:19],@"minsignal_dbm",
											[p3 objectAtIndex:20],@"minnoise_dbm",
											[p3 objectAtIndex:21],@"maxsignal_dbm",
											[p3 objectAtIndex:22],@"maxnoise_dbm",
											[p3 objectAtIndex:23],@"signal_rssi",
											[p3 objectAtIndex:24],@"noise_rssi",
											[p3 objectAtIndex:25],@"minsignal_rssi",
											[p3 objectAtIndex:26],@"minnoise_rssi",
											[p3 objectAtIndex:27],@"maxsignal_rssi",
											[p3 objectAtIndex:28],@"maxnoise_rssi",
											[p3 objectAtIndex:29],@"bestlat",
											[p3 objectAtIndex:30],@"bestlon",
											[p3 objectAtIndex:31],@"bestalt",
											[p3 objectAtIndex:32],@"agglat",
											[p3 objectAtIndex:33],@"agglon",
											[p3 objectAtIndex:34],@"aggalt",
											[p3 objectAtIndex:35],@"aggpoints",
											[p3 objectAtIndex:36],@"datasize",
											[p3 objectAtIndex:37],@"turbocellnid",
											[p3 objectAtIndex:38],@"turbocellmode",
											[p3 objectAtIndex:39],@"turbocellsat",
											[p3 objectAtIndex:40],@"carriersat",
											[p3 objectAtIndex:41],@"maxseenrate",
											[p3 objectAtIndex:42],@"encodingset",
											[p3 objectAtIndex:43],@"decrypted",
											[p3 objectAtIndex:44],@"dupeivpackets",
											
											[p objectAtIndex:3],@"bsstimestamp",
											[p objectAtIndex:4],@"cdpdevice",
											[p objectAtIndex:5],@"cdpport",
											
											[p4 objectAtIndex:1],@"fragments",
											[p4 objectAtIndex:2],@"retries",
											[p4 objectAtIndex:3],@"newpackets",
											[p4 objectAtIndex:4],@"freqmhz",
											[p4 objectAtIndex:5],@"datacryptset",
											nil];
			//NSLog(@"net %@",network);
		[[BSSIDinfo objectForKey:[p2 objectAtIndex:0]] setValuesForKeysWithDictionary:network];
		[table reloadData];
			
		} else {
			//NSLog(@"Unknown packet %@", type);
		}
	}
	
}


- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == table) {
		return [netArray count];
	} else if (tableView == netTable) {
		if (netInfo == nil) return 0;
		return [netInfo count];
	}
	NSLog(@"Unknown tableView");
	return 0;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
			row:(int)row
{
	if (tableView == table) {
		NSDictionary *tablerow = [[netArray allKeys] objectAtIndex:row];
		
		if ([[tableColumn identifier] isEqualToString:@"Channel"]) {
			return [[BSSIDinfo objectForKey:tablerow] objectForKey:[tableColumn identifier]];
		} else {
			return [[netArray objectForKey:tablerow] objectForKey:[tableColumn identifier]];
		}
	} else if (tableView == netTable) {
		if (netInfo == nil) {
			return @"";
		}
		if ([[tableColumn identifier] isEqualToString:@"Key"]) {
			return [[netInfo allKeys] objectAtIndex:row];
		} else if ([[tableColumn identifier] isEqualToString:@"Value"]) {
			return [netInfo objectForKey:[[netInfo allKeys] objectAtIndex:row]];
		} else {
			return @"Unknown Column";
		}
	} else {
		return @"Unknown Table";
	}
}

- (IBAction)tableViewSelected:(id)sender
{
	if (sender == table) {
		int row = [sender selectedRow];
		if (row >= 0) {
			NSString *network = [[netArray allKeys] objectAtIndex:row];
			NSLog(@"clicked %@", network);
			//TODO: mem leak
			if (netInfo != nil) [netInfo release];
			netInfo = [NSMutableDictionary dictionaryWithDictionary:[netArray objectForKey:network]];
			[netInfo addEntriesFromDictionary:[BSSIDinfo objectForKey:network]];
			[netInfo retain];
			
			[sigview setSignalParamsNoiseMin:[[netInfo objectForKey:@"minnoise_dbm"] floatValue]
									noisecur:[[netInfo objectForKey:@"noise_dbm"] floatValue]
									noisemax:[[netInfo objectForKey:@"maxnoise_dbm"] floatValue]
									  sigmin:[[netInfo objectForKey:@"minsignal_dbm"] floatValue]
									  sigcur:[[netInfo objectForKey:@"signal_dbm"] floatValue]
									  sigmax:[[netInfo objectForKey:@"maxsignal_dbm"] floatValue]];
			
			[netTable reloadData];
		}
    }	
}


@synthesize time;

@end
