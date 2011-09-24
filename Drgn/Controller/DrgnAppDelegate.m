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

@property (nonatomic, retain) DrgnIteration *iteration;
@property (nonatomic, assign) NSUInteger iterationCount;

@property (nonatomic, assign) CAShapeLayer *curveLayer;

-(void)positionCurveInView;

@end

@implementation DrgnAppDelegate

@synthesize window, view, iteration, curveLayer;


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
	
	curveLayer = [CAShapeLayer new];
	
	CGAffineTransform pathRotation = CGAffineTransformMakeRotation(M_PI / 4.0 * (iteration.count + 5));
	CGPathRef curve = CGPathCreateCopyByTransformingPath(iteration.path, &pathRotation);
	curveLayer.path = curve;
	CGPathRelease(curve);
	
	CGColorRef strokeColour = CGColorCreateGenericGray(1, 1);
	curveLayer.strokeColor = strokeColour;
	CGColorRelease(strokeColour);
	
	curveLayer.bounds = CGPathGetBoundingBox(curveLayer.path);
	
	[self positionCurveInView];
	
	[view.layer addSublayer:curveLayer];
	[curveLayer release];
}


-(void)positionCurveInView {
	[CATransaction begin];
	[CATransaction setAnimationDuration:0];
	
	curveLayer.position = (CGPoint){
		CGRectGetMidX(view.bounds),
		CGRectGetMidY(view.bounds),
	};
	
	CGRect drawingBounds = CGRectInset(view.bounds, 50, 50);
	CGFloat scale = MIN(CGRectGetWidth(drawingBounds) / CGRectGetWidth(curveLayer.bounds), CGRectGetHeight(drawingBounds) / CGRectGetHeight(curveLayer.bounds));
	
	curveLayer.lineWidth = 1.0 / scale;
	
	curveLayer.affineTransform = CGAffineTransformMakeScale(scale, scale);
	
	[CATransaction commit];
}


-(void)windowDidResize:(NSNotification *)notification {
	[self positionCurveInView];
}

@end
