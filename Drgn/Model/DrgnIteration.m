//
//  DrgnIteration.m
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import "DrgnIteration.h"

@implementation DrgnIteration

@synthesize previous, path;

+(id)newWithPreviousIteration:(DrgnIteration *)previous {
	return [[self alloc] initWithPreviousIteration:previous];
}

-(id)initWithPreviousIteration:(DrgnIteration *)_previous {
	if((self = [super init])) {
		CGMutablePathRef _path = CGPathCreateMutable();
		
		previous = [_previous retain];
		
		if(previous) {
			CGPathMoveToPoint(_path, NULL, 0, 0);
			CGPathAddPath(_path, NULL, previous.path);
			
			CGPathMoveToPoint(_path, NULL, previous.anchor.x, previous.anchor.y);
			CGAffineTransform transform = CGAffineTransformMakeTranslation(previous.anchor.x, previous.anchor.y);
			transform = CGAffineTransformRotate(transform, M_PI / 2);
			CGPathAddPath(_path, &transform, previous.path);
		} else {
			CGPathMoveToPoint(_path, NULL, 0, 0);
			CGPathAddLineToPoint(_path, NULL, 0, 10);
		}
		path = _path;
	}
	return self;
}

-(id)init {
	return [self initWithPreviousIteration:nil];
}

-(void)dealloc {
	[previous release];
	[super dealloc];
}


-(CGPoint)anchor {
	return CGPathGetCurrentPoint(path);
}


-(NSUInteger)count {
	return 1 + previous.count;
}

@end
