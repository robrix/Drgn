//
//  DrgnAppDelegate.m
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import "DrgnAppDelegate.h"
#import "DrgnIteration.h"
#import <QuartzCore/QuartzCore.h>

@interface DrgnAppDelegate () <NSWindowDelegate>
@end

@implementation DrgnAppDelegate

@synthesize window, view, iteration;


-(void)dealloc {
	[iteration release];
	[super dealloc];
}


-(void)awakeFromNib {
	self.iterationCount = 1;
	
	CGColorRef backgroundColour = CGColorCreateGenericGray(0.5, 1.0);
	view.layer.backgroundColor = backgroundColour;
	CGColorRelease(backgroundColour);
	
	self.window.delegate = self;
}


+(NSSet *)keyPathsForValuesAffectingIterationCount {
	return [NSSet setWithObject:@"iteration"];
}

-(NSUInteger)iterationCount {
	return iteration.count;
}

-(void)setIterationCount:(NSUInteger)count {
	[self willChangeValueForKey:@"iteration"];
	iteration = [DrgnIteration new];
	
	NSUInteger i = 1;
	for(; i < count; i++) {
		iteration = [DrgnIteration newWithPreviousIteration:[iteration autorelease]];
	}
	[self didChangeValueForKey:@"iteration"];
	
	for(CALayer *layer in [[view.layer.sublayers copy] autorelease]) {
		[layer removeFromSuperlayer];
	}
	
	CAShapeLayer *shape = [CAShapeLayer new];
	
	shape.path = iteration.path;
	
	CGColorRef strokeColour = CGColorCreateGenericGray(1, 1);
	shape.strokeColor = strokeColour;
	CGColorRelease(strokeColour);
	
	shape.bounds = CGPathGetBoundingBox(shape.path);
	shape.position = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
	
	shape.lineWidth = 1;
	
	CGRect drawingBounds = CGRectInset(view.bounds, 50, 50);
	CGFloat scale = MIN(CGRectGetWidth(drawingBounds) / CGRectGetWidth(shape.bounds), CGRectGetHeight(drawingBounds) / CGRectGetHeight(shape.bounds));
	
	shape.affineTransform = CGAffineTransformMakeScale(scale, scale);
	
	[view.layer addSublayer:shape];
	[shape release];
}


-(void)windowDidResize:(NSNotification *)notification {
	[CATransaction begin];
	[CATransaction setAnimationDuration:0];
	((CALayer *)self.view.layer.sublayers.lastObject).position = (CGPoint){
		CGRectGetMidX(view.bounds),
		CGRectGetMidY(view.bounds),
	};
	[CATransaction commit];
}

@end
