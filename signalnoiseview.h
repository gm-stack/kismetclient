//
//  signalnoiseview.h
//  kismetclient
//
//  Created by Geordie Millar on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSBezierPathAdditions.h"


@interface signalnoiseview : NSView {
	NSMutableArray* pointsArray;
	NSMutableParagraphStyle *style;
	NSDictionary *attr_red, *attr_green;
	float minnoise_dbm;
	float noise_dbm;
	float maxnoise_dbm;
	float minsignal_dbm;
	float signal_dbm;
	float maxsignal_dbm;
}	

- (void)setSignalParamsNoiseMin:(float)noisemin noisecur:(float)noisecur noisemax:(float)noisemax sigmin:(float)sigmin sigcur:(float)sigcur sigmax:(float)sigmax;

@end
