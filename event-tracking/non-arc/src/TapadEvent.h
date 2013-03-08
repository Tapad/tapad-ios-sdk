//
//  TapadEvent.h
//  TapadEvent
//
//  Created by gmack on 7/8/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIApplication;

// Tapad Events are used for tracking significant application occurrences that
// will be sent to Tapad for possible ad targeting.  They are not related in any
// way to iOS events such as touch and accelerometer events, but they can be 
// created and sent from code that handles them, if appropriate for targeting. 

// They are designed to be generic, i.e. there are no specific event types per 
// se.  The one exception is the application installation event, which is
// handled by the tapad library in a special way.   

// To send an event to tapad, it's best to use one of the class methods, which 
// construct and transmit the events for you.  In special cases, you may want
// to instantiate a TapadEvent object, and then send them to Tapad later. 

// Behind the scenes, Tapad takes your event, and schedules it for transmission
// in the background, using the iOS Grand Central Dispath API, with a queue name
// distinct to tapad.  This means you can send an event at any time in your 
// code, including during the main run loop.  The call will return immediately,
// and the event will be sent at some point later in the execution of the app. 

// Events are not guaranteed to arrive at Tapad, and have delivery timeouts.

@interface TapadEvent : NSObject {
    NSString* name;
    NSString* appId;
    NSString* extraParams;
}

@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* appId;
@property (nonatomic,copy) NSString* extraParams;


- (id)initWithName:(NSString*)name appId:(NSString*)appId extraParams:(NSString*)extraParams;

// register an app id with the library, if pre-given to the developer.
// the app id defaults to CFBundleName if not set
+ (void) registerAppWithId:(NSString*)appId;

// registers custom key value pair that will be sent with every subsequent event
// registration of a new value with an existing key will override the existing value
+ (void) registerCustomDataForKey:(NSString*)key value:(NSString*)value;

// removes the value associated with a custom data key
+ (void) clearCustomDataForKey:(NSString*)key;

// remove all custom data key and value pairs
+ (void) clearAllCustomData;

// construct and send event, returns YES if successfully scheduled
+ (BOOL) send:(NSString *)eventName; 

// To enable install tracking, call this method from your 
// application's own method of the same name. 
+ (BOOL)applicationDidFinishLaunching:(UIApplication *)application;

@end
