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
	STAssertTrue((actual.x == expected.x) && (actual.y == expected.y), @"%@ is not equal to the expected value %@", NSStringFromPoint(actual), NSStringFromPoint(expected));
}


-(void)testTerminalIterationsConsistOfAVerticalLine {
	iteration = [DrgnIteration new];
	
	CGMutablePathRef expected = CGPathCreateMutable();
	CGPathMoveToPoint(expected, NULL, 0, 0);
	CGPathAddLineToPoint(expected, NULL, 0, 10);
	
	STAssertTrue(CGPathEqualToPath(iteration.path, expected), @"The paths %@ and %@ were not equal", iteration.path, expected);
	
	CGPathRelease(expected);
}

-(void)testTerminalIterationsAreAnchoredAtTheEndOfTheirPath {
	iteration = [DrgnIteration new];
	
	[self assertPoint:iteration.anchor isEqualToPoint:CGPointMake(0, 10)];
}


//-(void)testNonterminalIterationsAreAnchoredAt

@end
