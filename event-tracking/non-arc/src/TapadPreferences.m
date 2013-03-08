//
//  TapadPreferences.m
//
//  Created by gmack on 7/7/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import "TapadPreferences.h"


@implementation TapadPreferences

static NSString* kTAPAD_IS_FIRST_RUN = @"Tapad First run";
static NSString* kTAPAD_OPT_OUT = @"Tapad Opt-out";
static NSString* kTAPAD_GEO_OPT_IN = @"Tapad Geo Opt-in";
static NSString* kTAPAD_APP_ID = @"Tapad App Id";
static NSString* kTAPAD_IDENTIFIER_PREFIX = @"Tapad Identifier";
static NSString* kTAPAD_CUSTOM_DATA = @"Tapad Custom Data";

+ (BOOL) registerDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], kTAPAD_IS_FIRST_RUN,
                                 [NSNumber numberWithBool:NO], kTAPAD_OPT_OUT,
                                 [NSNumber numberWithBool:NO], kTAPAD_GEO_OPT_IN,
                                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"], kTAPAD_APP_ID,
                                 [NSDictionary dictionary], kTAPAD_CUSTOM_DATA,
                                 nil
                                 ];
    
    [defaults registerDefaults:appDefaults];
    BOOL syncOK = [defaults synchronize];
    return syncOK;
}

+ (void) setTapadOptOutUserDefault {
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kTAPAD_OPT_OUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) getTapadOptOutUserDefault {
    NSString* defaultValue = [[NSUserDefaults standardUserDefaults] stringForKey:kTAPAD_OPT_OUT];
    return defaultValue;
}

+ (void) setTapadAppId:(NSString*)appId {
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:kTAPAD_APP_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) getTapadAppId {
    NSString* defaultValue = [[NSUserDefaults standardUserDefaults] stringForKey:kTAPAD_APP_ID];
    return defaultValue;
}

+ (BOOL) willSendIdFor:(NSString*)method {
    BOOL defaultValue = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@ %@", kTAPAD_IDENTIFIER_PREFIX, method]];
    return defaultValue;
}

+ (void) setSendIdFor:(NSString *)method to:(BOOL)state {
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:[NSString stringWithFormat:@"%@ %@", kTAPAD_IDENTIFIER_PREFIX, method]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setCustomDataForKey:(NSString*)key value:(NSString*)value {
    NSDictionary* existingCustomData = [[NSUserDefaults standardUserDefaults] objectForKey:kTAPAD_CUSTOM_DATA];
    NSMutableDictionary* newCustomData = [NSMutableDictionary dictionaryWithDictionary:existingCustomData];
    [newCustomData setObject:value forKey: key];
    [[NSUserDefaults standardUserDefaults] setObject:newCustomData forKey:kTAPAD_CUSTOM_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) removeCustomDataForKey:(NSString*)key {
    NSDictionary* existingCustomData = [[NSUserDefaults standardUserDefaults] objectForKey:kTAPAD_CUSTOM_DATA];
    NSMutableDictionary* newCustomData = [NSMutableDictionary dictionaryWithDictionary:existingCustomData];
    [newCustomData removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:newCustomData forKey:kTAPAD_CUSTOM_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) clearAllCustomData {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:kTAPAD_CUSTOM_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) getCustomDataAsSingleEncodedString {
    NSDictionary* existingCustomData = [[NSUserDefaults standardUserDefaults] objectForKey:kTAPAD_CUSTOM_DATA];
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:[existingCustomData count]]; // autoreleased
    for (id key in existingCustomData) {
        id value = [existingCustomData objectForKey:key];
        [params addObject:[NSString stringWithFormat:@"%@=%@", [TapadPreferences encodeString:key], [TapadPreferences encodeString:value] ]];
    }
    if ([params count] == 0) {
        return NULL;
    }
    else {
        return [TapadPreferences encodeString:[params componentsJoinedByString:@"&"]];
    }
}

+ (NSString*) encodeString: (id) unencodedString {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                             (CFStringRef)unencodedString,
                                                             NULL,
                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                             kCFStringEncodingUTF8);
}

// the user defaults this value to "YES", so the first call should return YES
// if the first parameter is YES, then the call will flip the value to NO,
// and return the value that was previously there
+ (BOOL) isFirstAppInstall:(BOOL)change {
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:kTAPAD_IS_FIRST_RUN];
    
    if (firstTime && change) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kTAPAD_IS_FIRST_RUN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return firstTime;
}


@end
