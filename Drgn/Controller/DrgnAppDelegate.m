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

@interface NSWindow (DrgnYesContentViewIsAViewHowDoIKnowIJustDoOkay)

@property (nonatomic, retain) NSView *contentView;

@end


@interface DrgnAppDelegate () <NSWindowDelegate>

@property (nonatomic, readonly) DrgnIteration *iteration;
@property (nonatomic, assign) NSUInteger iterationCount;

@property (nonatomic, assign) CAShapeLayer *curveLayer;

@property (nonatomic, retain) NSCache *layerCache;

-(void)positionCurveInView;

@end

@implementation DrgnAppDelegate

@synthesize window, curveLayer, layerCache;


-(void)dealloc {
	[layerCache release];
	[super dealloc];
}


-(void)awakeFromNib {
	layerCache = [NSCache new];
	
	self.iterationCount = 1;
	
	CGColorRef backgroundColour = CGColorCreateGenericGray(0.5, 1.0);
	self.window.contentView.layer.backgroundColor = backgroundColour;
	CGColorRelease(backgroundColour);
	
	self.window.delegate = self;
}


+(NSSet *)keyPathsForValuesAffectingIteration {
	return [NSSet setWithObject:@"curveLayer"];
}

-(DrgnIteration *)iteration {
	return [curveLayer valueForKey:@"iteration"];
}


+(NSSet *)keyPathsForValuesAffectingIterationCount {
	return [NSSet setWithObject:@"iteration"];
}

-(NSUInteger)iterationCount {
	return self.iteration.count;
}

-(void)setIterationCount:(NSUInteger)count {
	
	[self willChangeValueForKey:@"curveLayer"];
	[curveLayer removeFromSuperlayer];
	curveLayer = [layerCache objectForKey:[NSNumber numberWithUnsignedInteger:count]];
	
	if(curveLayer == nil) {
		DrgnIteration *iteration = [DrgnIteration new];
		
		NSUInteger i = 1;
		for(; i < count; i++) {
			iteration = [DrgnIteration newWithPreviousIteration:[iteration autorelease]];
		}
		
		curveLayer = [CAShapeLayer new];
		[curveLayer setValue:iteration forKey:@"iteration"];
		
		CGAffineTransform pathRotation = CGAffineTransformMakeRotation(M_PI / 4.0 * (iteration.count + 5));
		CGPathRef curve = CGPathCreateCopyByTransformingPath(iteration.path, &pathRotation);
		curveLayer.path = curve;
		CGPathRelease(curve);
		
		CGColorRef strokeColour = CGColorCreateGenericGray(1, 1);
		curveLayer.strokeColor = strokeColour;
		CGColorRelease(strokeColour);
		
		curveLayer.bounds = CGPathGetBoundingBox(curveLayer.path);
		
		[self positionCurveInView];
		
		[layerCache setObject:curveLayer forKey:[NSNumber numberWithUnsignedInteger:count]];
	}
	[self.window.contentView.layer addSublayer:curveLayer];
	
	[self didChangeValueForKey:@"curveLayer"];
}


-(void)positionCurveInView {
	[CATransaction begin];
	[CATransaction setAnimationDuration:0];
	
	curveLayer.position = (CGPoint){
		CGRectGetMidX(self.window.contentView.bounds),
		CGRectGetMidY(self.window.contentView.bounds),
	};
	
	CGRect drawingBounds = CGRectInset(self.window.contentView.bounds, 50, 50);
	CGFloat scale = MIN(CGRectGetWidth(drawingBounds) / CGRectGetWidth(curveLayer.bounds), CGRectGetHeight(drawingBounds) / CGRectGetHeight(curveLayer.bounds));
	
	curveLayer.lineWidth = 1.0 / scale;
	
	curveLayer.affineTransform = CGAffineTransformMakeScale(scale, scale);
	
	[CATransaction commit];
}


-(void)windowDidResize:(NSNotification *)notification {
	[self positionCurveInView];
}

@end
