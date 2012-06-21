//
//  TapadPreferences.h
//  AdWhirlSDK2_Sample
//
//  Created by gmack on 7/7/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TapadPreferences : NSObject {}

+ (BOOL) registerDefaults;

+ (void) setTapadOptOutUserDefault;
+ (NSString*) getTapadOptOutUserDefault;
+ (void) setTapadAppId:(NSString*)appId;
+ (NSString*) getTapadAppId;

// the user defaults this value to "YES", so the first call should return YES
// if the first parameter is YES, then the call will flip the value to NO,
// and return the value that was previously there
+ (BOOL) isFirstAppInstall:(BOOL)change; 


@end
