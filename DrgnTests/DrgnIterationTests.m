//
//  DrgnIterationTests.m
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DrgnIteration.h"

@interface DrgnIterationTests : SenTestCase

@property (nonatomic, retain) DrgnIteration *iteration;

@end

@implementation DrgnIterationTests

@synthesize iteration;

-(void)tearDown {
	[iteration release];
}


-(void)assertPoint:(CGPoint)actual isEqualToPoint:(CGPoint)expected {
	STAssertTrue((actual.x == expected.x) && (actual.y == expected.y), @"%@ != %@", NSStringFromPoint(actual), NSStringFromPoint(expected));
}


-(DrgnIteration *)iterationOfDegree:(NSUInteger)degree {
	DrgnIteration *_iteration = nil;
	for(NSUInteger i = 0; i < degree; i++) {
		_iteration = [DrgnIteration newWithPreviousIteration:[_iteration autorelease]];
	}
	return _iteration;
}


-(void)testTerminalIterationsConsistOfAVerticalLine {
	iteration = [DrgnIteration new];
	
	CGMutablePathRef expected = CGPathCreateMutable();
	CGPathMoveToPoint(expected, NULL, 0, 0);
	CGPathAddLineToPoint(expected, NULL, 0, 10);
	
	STAssertTrue(CGPathEqualToPath(iteration.path, expected), @"The paths %@ and %@ were not equal", iteration.path, expected);
	
	CGPathRelease(expected);
}

-(void)testIterationOneIsAnchoredAtItsTip {
	iteration = [self iterationOfDegree:1];
	
	[self assertPoint:iteration.anchor isEqualToPoint:CGPointMake(0, 10)];
}


-(void)testIterationTwoIsAnchoredAtItsOriginRotatedAroundThePreviousIterationsAnchor {
	iteration = [self iterationOfDegree:2];
	
	[self assertPoint:iteration.anchor isEqualToPoint:CGPointMake(10, 10)];
}

-(void)testIterationThreeIsAnchoredAtItsOriginRotatedAroundThePreviousIterationsAnchor {
	iteration = [self iterationOfDegree:3];
	
	[self assertPoint:iteration.anchor isEqualToPoint:CGPointMake(20, 0)];
}

-(void)testIterationFourIsAnchoredAtItsOriginRotatedAroundThePreviousIterationsAnchor {
	iteration = [self iterationOfDegree:4];
	
	[self assertPoint:iteration.anchor isEqualToPoint:CGPointMake(20, -20)];
}


-(void)testTerminalIterationsHaveACountOfOne {
	iteration = [self iterationOfDegree:1];
	
	STAssertEquals(iteration.count, (NSUInteger)1, @"Terminal iterations should have a count of 1.");
}

-(void)testNonterminalIterationsHaveACountOneGreaterThanTheirPreviousIterations {
	iteration = [self iterationOfDegree:4];
	
	STAssertEquals(iteration.count, (NSUInteger)4, @"Terminal iterations should have a count of 4.");
}

@end
