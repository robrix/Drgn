//
//  DrgnAppDelegate.h
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DrgnAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *view;

@property (readonly) NSUInteger iteration;

@end