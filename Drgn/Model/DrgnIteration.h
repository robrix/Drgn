//
//  DrgnIteration.h
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrgnIteration : NSObject

+(id)newWithPreviousIteration:(DrgnIteration *)previous;
-(id)initWithPreviousIteration:(DrgnIteration *)_previous;

@property (nonatomic, readonly) DrgnIteration *previous;

@property (nonatomic, readonly) CGPathRef path;

@property (nonatomic, readonly) CGPoint anchor;

@property (nonatomic, readonly) NSUInteger count;

@end
