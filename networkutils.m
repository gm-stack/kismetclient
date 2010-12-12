//
//  networkutils.m
//  kismetclient
//
//  Created by Geordie Millar on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "networkutils.h"


@implementation networkutils

+(NSString*)securityMode:(NSString*)mode2 {
	int mode = [mode2 intValue];
	
	NSMutableArray *secstr = [NSMutableArray arrayWithCapacity:1];
	
	if (mode == 0)
		[secstr addObject:@"None (Open)"];
	if (mode == crypt_wep)
		[secstr addObject:@"WEP (Privacy bit set)"];
	if (mode & crypt_layer3)
		[secstr addObject:@"Layer3"];
	if (mode & crypt_wpa_migmode)
		[secstr addObject:@"WPA Migration Mode"];
	if (mode & crypt_wep40)
		[secstr addObject:@"WEP (40bit)"];
	if (mode & crypt_wep104)
		[secstr addObject:@"WEP (104bit)"];
	if (mode & crypt_wpa)
		[secstr addObject:@"WPA"];
	if (mode & crypt_tkip)
		[secstr addObject:@"TKIP"];
	if (mode & crypt_psk)
		[secstr addObject:@"PSK"];
	if (mode & crypt_aes_ocb)
		[secstr addObject:@"AES-ECB"];
	if (mode & crypt_aes_ccm)
		[secstr addObject:@"AES-CCM"];
	if (mode & crypt_leap)
		[secstr addObject:@"LEAP"];
	if (mode & crypt_ttls)
		[secstr addObject:@"TTLS"];
	if (mode & crypt_tls)
		[secstr addObject:@"TLS"];
	if (mode & crypt_peap)
		[secstr addObject:@"PEAP"];
	if (mode & crypt_isakmp)
		[secstr addObject:@"ISA-KMP"];
	if (mode & crypt_pptp)
		[secstr addObject:@"PPTP"];
	if (mode & crypt_fortress)
		[secstr addObject:@"Fortress"];
	if (mode & crypt_keyguard)
		[secstr addObject:@"Keyguard"];
	if (mode & crypt_unknown_nonwep)
		[secstr addObject:@"WPA/ExtIV data"];
	
	return [secstr componentsJoinedByString:@" "];
}

+(NSString*)networkType:(NSString*)type2 {
	int type = [type2 intValue];
	switch (type) {
		case network_ap:
			return @"Managed";
		case network_probe:
			return @"Probe";
		case network_turbocell:
			return @"Turbocell";
		case network_data:
			return @"Data only";
		case network_mixed:
			return @"Multiple";
		default:
			return @"Unknown";
	}
}

+(NSString*)time:(NSString*)time2 {
	int time = [time2 intValue];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"hh:mm:ss a"];
    return [dateFormatter stringFromDate:date];
	
}

@end