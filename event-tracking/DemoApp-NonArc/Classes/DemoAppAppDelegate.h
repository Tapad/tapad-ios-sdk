//
//  DemoAppAppDelegate.h
//  DemoApp
//
//  Created by Li Qiu on 9/14/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Enabling all of the available identifiers so we can exercise them
// in the demo code.  However, developers should only enable the identifiers
// that they are actually going to use.

@interface DemoAppAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) resetIdentifierConfig;
- (void) testEventWithNoIdentifier;
- (void) testEventWithOpenUDID;
- (void) testEventWithMD5HashedRawMAC;
- (void) testEventWithSHA1HashedRawMAC;
- (void) testEventWithMD5HashedUDID;
- (void) testEventWithSHA1HashedUDID;
- (void) testEventWithMD5HashedMAC;
- (void) testEventWithSHA1HashedMAC;
- (void) testEventWithAllIdentifiers;

@end
