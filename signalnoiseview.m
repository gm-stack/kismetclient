//
//  signalnoiseview.m
//  kismetclient
//
//  Created by Geordie Millar on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "signalnoiseview.h"


@implementation signalnoiseview

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        [style setAlignment:NSCenterTextAlignment];
        attr_red = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName, nil];
		attr_green = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, [NSColor greenColor], NSForegroundColorAttributeName, nil];
		[style release];
		
		minnoise_dbm = -100;
		noise_dbm = -100;
		maxnoise_dbm = -100;
		
		minsignal_dbm = -100;
		signal_dbm = -100;
		maxsignal_dbm = -100;
		
    }
    return self;
}

#define dbm2pixels(dbm) (((dbm)+100)*pixelsperdb)

- (void)drawRect:(NSRect)dirtyRect {
	
	NSRect bounds = [self bounds];
	
	NSBezierPath *bp = [NSBezierPath bezierPathWithRect:[self bounds]];
	NSColor *color = [NSColor colorWithCalibratedRed:0.4 green:0.4 blue:0.4 alpha:0.3];
	[color set];
	[bp fill];
	
	float pixelsperdb = (bounds.size.width) / 100.0;
	
	
	for (int i = 0; i<11; i++) {
		[[NSColor blueColor] set];
		NSBezierPath *thePath = [NSBezierPath bezierPath];
		[thePath moveToPoint:NSMakePoint(bounds.origin.x + (int)(i * pixelsperdb * 10.0), bounds.origin.y)];
		[thePath lineToPoint:NSMakePoint(bounds.origin.x + (int)(i * pixelsperdb * 10.0), bounds.origin.y + bounds.size.height)];
		[thePath closePath];
		[thePath stroke];
		
		[[NSString stringWithFormat:@"%.0f",-100.0 + (i * 10)] drawAtPoint:NSMakePoint(bounds.origin.x + 3 + (int)(i * pixelsperdb * 10.0), bounds.origin.y) withAttributes:attr_red];
	}
	
	NSBezierPath *noisepath = [NSBezierPath bezierPathWithRect:NSMakeRect(dbm2pixels(minnoise_dbm), 40, dbm2pixels(maxnoise_dbm) - dbm2pixels(minnoise_dbm), 20)];
	[[NSColor redColor] set];
	[noisepath fillGradientFrom:[NSColor colorWithCalibratedRed:0.5 green:0.2 blue:0.1 alpha:0.5] 
							  to:[NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.1 alpha:0.6]
						  height:40
	 ];
	
	NSBezierPath *signalPath = [NSBezierPath bezierPathWithRect:NSMakeRect(dbm2pixels(minsignal_dbm), 15, dbm2pixels(maxsignal_dbm) - dbm2pixels(minsignal_dbm), 20)];
	[[NSColor blueColor] set];
	[signalPath fillGradientFrom:[NSColor colorWithCalibratedRed:0 green:0.2 blue:0.3 alpha:0.5] 
						   to:[NSColor colorWithCalibratedRed:0 green:0.0 blue:0.4 alpha:0.6]
						  height:40
	 ];
	
	[[NSColor greenColor] set];
	NSBezierPath *thePath = [NSBezierPath bezierPath];
	[thePath moveToPoint:NSMakePoint(dbm2pixels(noise_dbm), bounds.size.height)];
	[thePath lineToPoint:NSMakePoint(dbm2pixels(noise_dbm), bounds.size.height - 20)];
	[thePath closePath];
	[thePath stroke];
	
	[[NSColor greenColor] set];
	NSBezierPath *thePath2 = [NSBezierPath bezierPath];
	[thePath2 moveToPoint:NSMakePoint(dbm2pixels(signal_dbm), bounds.size.height - 25)];
	[thePath2 lineToPoint:NSMakePoint(dbm2pixels(signal_dbm), bounds.size.height - 45)];
	[thePath2 closePath];
	[thePath2 stroke];
	
	

	//[self setNeedsDisplay:TRUE];
}


- (void)setSignalParamsNoiseMin:(float)noisemin noisecur:(float)noisecur noisemax:(float)noisemax sigmin:(float)sigmin sigcur:(float)sigcur sigmax:(float)sigmax {
	NSLog(@"set signal");
		  
	minnoise_dbm = noisemin;
	noise_dbm = noisecur;
	maxnoise_dbm = noisemax;
	
	minsignal_dbm = sigmin;
	signal_dbm = sigcur;
	maxsignal_dbm = sigmax;
	
	[self setNeedsDisplay:TRUE];
}

@end
