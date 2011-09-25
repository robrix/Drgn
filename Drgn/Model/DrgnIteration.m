//
//  DrgnIteration.m
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import "DrgnIteration.h"

@implementation DrgnIteration

@synthesize previous, path, anchor, count;


+(id)newWithPreviousIteration:(DrgnIteration *)previous {
	return [[self alloc] initWithPreviousIteration:previous];
}

-(id)initWithPreviousIteration:(DrgnIteration *)_previous {
	if((self = [super init])) {
		previous = [_previous retain];
	}
	return self;
}

-(id)init {
	return [self initWithPreviousIteration:nil];
}

-(void)dealloc {
	[previous release];
	CGPathRelease(path);
	[super dealloc];
}


-(CGPathRef)path {
	if(path == NULL) {
		CGMutablePathRef _path = CGPathCreateMutable();
		if(previous) {
			CGPathAddPath(_path, NULL, previous.path);
			CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(self.anchor.x, self.anchor.y), M_PI / 2);
			CGPathAddPath(_path, &transform, previous.path);
		} else {
			CGPathMoveToPoint(_path, NULL, 0, 0);
			CGPathAddLineToPoint(_path, NULL, 0, 10);
		}
		path = _path;
	}
	return path;
}


-(CGPoint)anchor {
	if(CGPointEqualToPoint(anchor, CGPointZero)) {
		if(previous) {
			CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(previous.anchor.x, previous.anchor.y), M_PI / -2);
			anchor = CGPointApplyAffineTransform(previous.anchor, transform);
		} else {
			anchor = CGPointMake(0, 10.0);
		}
	}
	return anchor;
}


-(NSUInteger)count {
	if(count == 0) {
		count = 1 + previous.count;
	}
	return count;
}

@end
