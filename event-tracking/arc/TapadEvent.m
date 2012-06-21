//
//  TapadEvent.m
//  TapadEvent
//
//  Created by gmack on 7/8/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import "TapadEvent.h"
#import "TapadPreferences.h"
#import "TapadRequest.h"

@implementation TapadEvent

@synthesize name;
@synthesize appId;

-(id)initWithName:(NSString *)initname appId:(NSString *)initAppId{
    self = [super init];
    self.name = initname;
    self.appId = initAppId;
    return self;
}

+ (void) registerAppWithId:(NSString *)appId {
    [TapadPreferences setTapadAppId:appId];
}

+ (BOOL) send:(NSString *)eventName {
    
    TapadEvent* event = [[TapadEvent alloc] initWithName:eventName appId:[TapadPreferences getTapadAppId]];

    // todo: should we hold on to this object?
    dispatch_queue_t tapadq = dispatch_queue_create("Tapad Events Queue", NULL); 
    
    dispatch_block_t block = ^{
        // note: since we are referencing the event object instance within this 
        // block, it will be retained by the block until freed
        TapadRequest* request = [TapadRequest requestForEvent:event];
        NSString* response = [request getSynchronous]; // autoreleased string
        NSLog(@"response from event tracking:%@",response);
    }; 

    dispatch_async(tapadq, block);
    dispatch_release(tapadq);
        
    return YES;
}

// the basic hook for automatically checking first install
// as well as other global initializations
// note that the method signature matches the one expected of app developers
+ (BOOL)applicationDidFinishLaunching:(UIApplication *)application {
    
    [TapadPreferences registerDefaults];
    
    if ( [TapadPreferences isFirstAppInstall:YES]) {
        [TapadEvent send:@"install"];
    }
    
    return YES;
}

@end
