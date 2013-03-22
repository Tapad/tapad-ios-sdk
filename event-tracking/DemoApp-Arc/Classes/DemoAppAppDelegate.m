//
//  DemoAppAppDelegate.m
//  DemoApp
//
//  Created by Li Qiu on 9/14/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import "DemoAppAppDelegate.h"
#import "TapadEvent.h"
#import "TapadIdentifiers.h"

@implementation DemoAppAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    /*
     Add launch tracking logic here.
     */

    NSLog(@"App Started");

    // Uncomment if supplied with an app id from Tapad.  If unspecified, the app id is set to the CFBundleName.
    [TapadEvent registerAppWithId:@"Tapad Tracking SDK (arc) Demo App"];

    // reset all Identifier config
    [self resetIdentifierConfig];
    
    // Prepare and send the launch tracking event.
    [TapadEvent applicationDidFinishLaunching:application];

    // tests (scheduled because the event sending is asynchronous but the config setting is synchronous
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(testEventWithNoIdentifier) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(testEventWithOpenUDID) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(testEventWithMD5HashedRawMAC) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(testEventWithSHA1HashedRawMAC) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(testEventWithMD5HashedMAC) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(testEventWithSHA1HashedMAC) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:14 target:self selector:@selector(testEventWithAdvertisingIdentifier) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:16 target:self selector:@selector(testEventWithAllIdentifiers) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:18 target:self selector:@selector(testEventWithAllIdentifiersAndExtraParams) userInfo:nil repeats:NO];
}

- (void) resetIdentifierConfig {
    // reset all Identifier config
    [TapadIdentifiers sendOpenUDID:NO];
    [TapadIdentifiers sendMD5HashedRawMAC:NO];
    [TapadIdentifiers sendSHA1HashedRawMAC:NO];
    [TapadIdentifiers sendMD5HashedMAC:NO];
    [TapadIdentifiers sendSHA1HashedMAC:NO];
    [TapadIdentifiers sendAdvertisingIdentifier:NO];
}

- (void) testEventWithNoIdentifier {
    [self resetIdentifierConfig];
    
    // send test event with no identifiers specified
    [TapadEvent send:@"no identifiers enabled event"];
}

- (void) testEventWithOpenUDID {
    [self resetIdentifierConfig];
    
    // enable OpenUDID
    [TapadIdentifiers sendOpenUDID:YES];

    // send test event with OpenUDID enabled
    [TapadEvent send:@"OpenUDID specified"];
}

- (void) testEventWithMD5HashedRawMAC {
    [self resetIdentifierConfig];
    
    // enable MD5 Hashed Raw MAC
    [TapadIdentifiers sendMD5HashedRawMAC:YES];

    // send test event with MD5 Hashed Raw MAC enabled
    [TapadEvent send:@"MD5HashedRawMAC specified"];
}

- (void) testEventWithSHA1HashedRawMAC {
    [self resetIdentifierConfig];
    
    // enable SHA1 Hashed Raw MAC
    [TapadIdentifiers sendSHA1HashedRawMAC:YES];

    // send test event with SHA1 Hashed Raw MAC enabled
    [TapadEvent send:@"SHA1HashedRawMAC specified"];
}

- (void) testEventWithMD5HashedMAC {
    [self resetIdentifierConfig];
    
    // enable MD5 Hashed MAC
    [TapadIdentifiers sendMD5HashedMAC:YES];
    
    // send test event with MD5 Hashed MAC enabled
    [TapadEvent send:@"MD5HashedMAC specified"];
}

- (void) testEventWithSHA1HashedMAC {
    [self resetIdentifierConfig];
    
    // enable SHA1 Hashed MAC
    [TapadIdentifiers sendSHA1HashedMAC:YES];
    
    // send test event with SHA1 Hashed MAC enabled
    [TapadEvent send:@"SHA1HashedMAC specified"];
}

- (void) testEventWithAdvertisingIdentifier {
    [self resetIdentifierConfig];
    
    // enable iOS 6 Advertising Identifier
    [TapadIdentifiers sendAdvertisingIdentifier:YES];
    
    // send test event with iOS 6 Advertising Identifier enabled
    [TapadEvent send:@"Advertising Identifier specified"];
}

- (void) testEventWithAllIdentifiers {
    [self resetIdentifierConfig];

    // enable all identifiers
    [TapadIdentifiers sendOpenUDID:YES];
    [TapadIdentifiers sendMD5HashedRawMAC:YES];
    [TapadIdentifiers sendSHA1HashedRawMAC:YES];
    [TapadIdentifiers sendMD5HashedMAC:YES];
    [TapadIdentifiers sendSHA1HashedMAC:YES];
    [TapadIdentifiers sendAdvertisingIdentifier:YES];
    
    // send test event with all identifiers enabled
    [TapadEvent send:@"all identifiers enabled"];
}

- (void) testEventWithAllIdentifiersAndExtraParams {
    [self resetIdentifierConfig];
    
    // enable all identifiers
    [TapadIdentifiers sendOpenUDID:YES];
    [TapadIdentifiers sendMD5HashedRawMAC:YES];
    [TapadIdentifiers sendSHA1HashedRawMAC:YES];
    [TapadIdentifiers sendMD5HashedMAC:YES];
    [TapadIdentifiers sendSHA1HashedMAC:YES];
    [TapadIdentifiers sendAdvertisingIdentifier:YES];
    
    // configure extra params
    [TapadEvent registerCustomDataForKey:@"EXTRA_DATA_1" value:@"foo&123"];
    [TapadEvent registerCustomDataForKey:@"SPECIAL DATA 2" value:@"bar=567"];
    [TapadEvent registerCustomDataForKey:@"DATA NOT TO BE SENT" value:@"baz999"];
    // remove the custom data that is not to be sent any more
    [TapadEvent clearCustomDataForKey:@"DATA NOT TO BE SENT"];
    
    // send test event with all identifiers enabled and extra params
    [TapadEvent send:@"all identifiers enabled with extra params"];
}
@end
