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

@property (nonatomic, retain) DrgnIteration *iteration;

@property (nonatomic, assign) CAShapeLayer *curveLayer;

@property (nonatomic, retain) NSCache *iterationCache;

-(void)updateCurvePath;
-(void)centreCurveInWindow;

@end

@implementation DrgnAppDelegate

@synthesize window, curveLayer, iterationCache, iteration;

-(void)dealloc {
	[iterationCache release];
	[iteration release];
	[super dealloc];
}


-(void)awakeFromNib {
	iterationCache = [NSCache new];
	
	CGColorRef backgroundColour = CGColorCreateGenericGray(0.5, 1.0);
	self.window.contentView.layer.backgroundColor = backgroundColour;
	CGColorRelease(backgroundColour);
	
	curveLayer = [CAShapeLayer new];
	CGColorRef strokeColour = CGColorCreateGenericGray(1, 1);
	curveLayer.strokeColor = strokeColour;
	CGColorRelease(strokeColour);
	
	[self.window.contentView.layer addSublayer:curveLayer];
	
	[curveLayer release];
	
	if(iteration == nil)
		self.iterationCount = 1;
	else
		[self updateCurvePath];
	
	self.window.delegate = self;
}


-(void)setIteration:(DrgnIteration *)_iteration {
	id old = iteration;
	iteration = [_iteration retain];
	[old release];
	
	[self updateCurvePath];
}


+(NSSet *)keyPathsForValuesAffectingIterationCount {
	return [NSSet setWithObject:@"iteration"];
}

-(NSUInteger)iterationCount {
	return self.iteration.count;
}

-(void)setIterationCount:(NSUInteger)count {
	DrgnIteration *_iteration = [iterationCache objectForKey:[NSNumber numberWithUnsignedInteger:count]];
	
	if(_iteration == nil) {
		_iteration = [[DrgnIteration newWithDegree:count] autorelease];
		
		[iterationCache setObject:_iteration forKey:[NSNumber numberWithUnsignedInteger:count]];
	}
	
	self.iteration = _iteration;
}


-(void)updateCurvePath {
	[CATransaction begin];
	[CATransaction setAnimationDuration:0];
	
	CGAffineTransform pathRotation = CGAffineTransformMakeRotation(M_PI / 4.0 * (iteration.count + 5));
	CGPathRef curve = CGPathCreateCopyByTransformingPath(iteration.path, &pathRotation);
	curveLayer.path = curve;
	CGPathRelease(curve);
	curveLayer.bounds = CGPathGetBoundingBox(curveLayer.path);
	
	[self centreCurveInWindow];
	
	[CATransaction commit];
}

-(void)centreCurveInWindow {
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
	[self centreCurveInWindow];
}


-(void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
	[state encodeObject:self.iteration forKey:@"iteration"];
}

-(void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
	self.iteration = [state decodeObjectForKey:@"iteration"];
}

@end
