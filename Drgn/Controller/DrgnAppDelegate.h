//
//  DrgnAppDelegate.h
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DrgnIteration;

@interface DrgnAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSWindow *window;

@property (nonatomic, assign) NSUInteger iterationCount;

@end
