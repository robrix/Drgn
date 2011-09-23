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
	shape.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
	
	shape.lineWidth = 1;
	
	[view.layer addSublayer:shape];
	[shape release];
}

@end
