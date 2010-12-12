//
//  networkutils.h
//  kismetclient
//
//  Created by gm on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "80211_packet.h"

@interface networkutils : NSObject {

}

+(NSString*)securityMode:(NSString*)mode2;
+(NSString*)networkType:(NSString*)type2;
+(NSString*)time:(NSString*)time2;

@end
