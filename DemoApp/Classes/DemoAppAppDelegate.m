//
//  DemoAppAppDelegate.m
//  DemoApp
//
//  Created by Li Qiu on 9/14/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import "DemoAppAppDelegate.h"
#import "TapadEvent.h"

@implementation DemoAppAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    /*
     Add launch tracking logic here.
     */

    // Uncomment if supplied with an app id from Tapad.  If unspecified, the app id is set to the CFBundleName.
    //[TapadEvent registerAppWithId:appId];

    // Prepare and send the launch tracking event.
    [TapadEvent applicationDidFinishLaunching:application];
}

@end
