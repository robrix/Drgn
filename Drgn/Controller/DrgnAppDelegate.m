//
//  DrgnAppDelegate.m
//  Drgn
//
//  Created by Rob Rix on 11-09-22.
//  Copyright 2011 Monochrome Industries. All rights reserved.
//

#import "DrgnAppDelegate.h"

@implementation DrgnAppDelegate

@synthesize window, view, iteration;


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}


-(void)awakeFromNib {
	iteration = 0;
	
	CGColorRef backgroundColour = CGColorCreateGenericGray(0.5, 1.0);
	view.layer.backgroundColor = backgroundColour;
	CGColorRelease(backgroundColour);
}

@end
