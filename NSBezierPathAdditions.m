//
//  NSPathAdditions.m
//  gpstool
//
//  Created by Geordie Millar on 28/01/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

// based on some code snippets from cocoadev

#import "NSBezierPathAdditions.h"

@implementation NSBezierPath (gradient)

- (void)fillGradientFrom:(NSColor*)first to:(NSColor*)second height:(float)height
{	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	
	CIFilter* filter = [CIFilter filterWithName:@"CILinearGradient"];
	[filter setValue:[CIColor colorWithRed:[first redComponent] green:[first greenComponent] blue:[first blueComponent] alpha:[first alphaComponent]] forKey:@"inputColor0"];
	[filter setValue:[CIColor colorWithRed:[second redComponent] green:[second greenComponent] blue:[second blueComponent] alpha:[second alphaComponent]] forKey:@"inputColor1"];
	[filter setValue:[CIVector vectorWithX:0.0 Y:0.0] forKey:@"inputPoint0"];
	[filter setValue:[CIVector vectorWithX:0.0 Y:height] forKey:@"inputPoint1"];
	
	[self setClip];
	[[[NSGraphicsContext currentContext] CIContext] drawImage:[filter valueForKey:@"outputImage"] atPoint:CGPointZero fromRect:CGRectMake( 0.0, 0.0, [self bounds].size.width + 100.0, [self bounds].size.height + 100.0 )];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end


@implementation NSBezierPath (RoundRect)

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius {
    NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithRoundedRect:rect cornerRadius:radius];
    return result;
}

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius {
    if (!NSIsEmptyRect(rect)) {
  if (radius > 0.0) {
      float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));

      NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
      NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
      NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));

      [self moveToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
      [self appendBezierPathWithArcFromPoint:topLeft     toPoint:rect.origin radius:clampedRadius];
      [self appendBezierPathWithArcFromPoint:rect.origin toPoint:bottomRight radius:clampedRadius];
      [self appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight    radius:clampedRadius];
      [self appendBezierPathWithArcFromPoint:topRight    toPoint:topLeft     radius:clampedRadius];
      [self closePath];
  } else {
      [self appendBezierPathWithRect:rect];
  }
    }
}

@end