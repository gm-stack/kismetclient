//
//  NSPathAdditions.h
//  gpstool
//
//  Created by Geordie Millar on 28/01/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef GNUSTEP
	#import <QuartzCore/CIFilter.h>
	#import <QuartzCore/CIVector.h>
	@interface NSBezierPath (gradient)
		- (void)fillGradientFrom:(NSColor*)first to:(NSColor*)second height:(float)height;
	@end
#endif

@interface NSBezierPath (RoundRect)
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
@end
