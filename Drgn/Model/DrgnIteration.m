//
//  DrgnIteration.m
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import "DrgnIteration.h"

@implementation DrgnIteration

@synthesize previous, path, anchor;


+(id)newWithPreviousIteration:(DrgnIteration *)previous {
	return [[self alloc] initWithPreviousIteration:previous];
}

-(id)initWithPreviousIteration:(DrgnIteration *)_previous {
	if((self = [super init])) {
		CGMutablePathRef _path = CGPathCreateMutable();
		
		previous = [_previous retain];
		
		if(previous) {
			CGPathAddPath(_path, NULL, previous.path);
			CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(previous.anchor.x, previous.anchor.y), M_PI / -2);
			anchor = CGPointApplyAffineTransform(previous.anchor, transform);
			transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(anchor.x, anchor.y), M_PI / 2);
			CGPathAddPath(_path, &transform, previous.path);
		} else {
			CGPathMoveToPoint(_path, NULL, 0, 0);
			CGPathAddLineToPoint(_path, NULL, 0, 10);
			anchor = CGPointMake(0, 10.0);
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


-(NSUInteger)count {
	return 1 + previous.count;
}

@end
