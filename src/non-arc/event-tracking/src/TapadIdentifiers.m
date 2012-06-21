//
//  TapadIdentifiers.m
//
//  Created by Li Qiu on 6/20/2012.
//  Copyright 2012 Tapad, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "OpenUDID.h"
#import "TapadIdentifiers.h"
#import "TapadPreferences.h"
#import "UIDevice-Hardware.h"
#import "NSString+MD5.h"

@interface TapadIdentifiers()

#ifdef TAPAD_IDENTIFIER_ENABLE_OPENUDID
+(NSString*) fetchOpenUDID;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_MAC
+(NSString*) fetchMD5HashedMAC;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_MAC
+(NSString*) fetchSHA1HashedMAC;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_UDID
+(NSString*) fetchMD5HashedUDID;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_UDID
+(NSString*) fetchSHA1HashedUDID;
#endif

+(NSString*) defaultDeviceID;
@end

@implementation TapadIdentifiers

#ifdef TAPAD_IDENTIFIER_ENABLE_OPENUDID
static NSString* kMETHOD_OPENUDID = @"OpenUDID";
static NSString* kTYPE_OPENUDID = @"0";

+ (BOOL) willSendOpenUDID {
    return [TapadPreferences willSendIdFor:kMETHOD_OPENUDID];
}

+ (void) sendOpenUDID:(BOOL)state {
    [TapadPreferences setSendIdFor:kMETHOD_OPENUDID to:state];
}

+ (NSString*) fetchOpenUDID {
    return [NSString stringWithFormat:@"%@:%@", kTYPE_OPENUDID, [OpenUDID value]];
}
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_MAC
static NSString* kMETHOD_MD5_HASHED_MAC = @"MD5 Hashed MAC";
static NSString* kTYPE_MD5_HASHED_MAC = @"1";

+ (BOOL) willSendMD5HashedMAC {
    return [TapadPreferences willSendIdFor:kMETHOD_MD5_HASHED_MAC];
}

+ (void) sendMD5HashedMAC:(BOOL)state {
    [TapadPreferences setSendIdFor:kMETHOD_MD5_HASHED_MAC to:state];
}

+ (NSString*) fetchMD5HashedMAC {
    // storage of mac addy bytes
    unsigned char macBuffer[6];
    // storage of md5 output bytes
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    if ([[UIDevice currentDevice] macaddressTo:macBuffer]) {
        // Create 16 byte MD5 hash value, store in buffer
        CC_MD5(macBuffer, 6, md5Buffer);
        
        // Convert MD5 value in the buffer to NSString of hex values
        NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02x",md5Buffer[i]];
        }
        return [NSString stringWithFormat:@"%@:%@", kTYPE_MD5_HASHED_MAC, output];
    }
    else {
        return [NSString stringWithFormat:@"%@:%@", kTYPE_MD5_HASHED_MAC, @"0"];
    }
}
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_MAC
static NSString* kMETHOD_SHA1_HASHED_MAC = @"SHA1 Hashed MAC";
static NSString* kTYPE_SHA1_HASHED_MAC = @"2";

+ (BOOL) willSendSHA1HashedMAC {
    return [TapadPreferences willSendIdFor:kMETHOD_SHA1_HASHED_MAC];
}

+ (void) sendSHA1HashedMAC:(BOOL)state {
    [TapadPreferences setSendIdFor:kMETHOD_SHA1_HASHED_MAC to:state];
}

+ (NSString*) fetchSHA1HashedMAC {
    // storage of mac addy bytes
    unsigned char macBuffer[6];
    // storage of sha1 output bytes
    unsigned char sha1Buffer[CC_SHA1_DIGEST_LENGTH];
    
    if ([[UIDevice currentDevice] macaddressTo:macBuffer]) {
        // Create 20 byte SHA1 hash value, store in buffer
        CC_SHA1(macBuffer, 6, sha1Buffer);
        
        // Convert SHA1 value in the buffer to NSString of hex values
        NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02x",sha1Buffer[i]];
        }
        return [NSString stringWithFormat:@"%@:%@", kTYPE_SHA1_HASHED_MAC, output];
    }
    else {
        return [NSString stringWithFormat:@"%@:%@", kTYPE_SHA1_HASHED_MAC, @"0"];
    }
}
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_UDID
static NSString* kMETHOD_MD5_HASHED_UDID = @"MD5 Hashed UDID";
static NSString* kTYPE_MD5_HASHED_UDID = @"3";

+ (BOOL) willSendMD5HashedUDID {
    return [TapadPreferences willSendIdFor:kMETHOD_MD5_HASHED_UDID];
}

+ (void) sendMD5HashedUDID:(BOOL)state {
    [TapadPreferences setSendIdFor:kMETHOD_MD5_HASHED_UDID to:state];
}

+ (NSString*) fetchMD5HashedUDID {
    if ([[UIDevice currentDevice] uniqueIdentifier] == NULL) {
        return [NSString stringWithFormat:@"%@:%@", kTYPE_MD5_HASHED_UDID, @"0"];
    }
    else {
        return [NSString stringWithFormat:@"%@:%@", kTYPE_MD5_HASHED_UDID, [[[UIDevice currentDevice] uniqueIdentifier] MD5]];
    }
}
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_UDID
static NSString* kMETHOD_SHA1_HASHED_UDID = @"SHA1 Hashed UDID";
static NSString* kTYPE_SHA1_HASHED_UDID = @"4";

+ (BOOL) willSendSHA1HashedUDID {
    return [TapadPreferences willSendIdFor:kMETHOD_SHA1_HASHED_UDID];
}

+ (void) sendSHA1HashedUDID:(BOOL)state {
    [TapadPreferences setSendIdFor:kMETHOD_SHA1_HASHED_UDID to:state];
}

+ (NSString*) fetchSHA1HashedUDID {
    if ([[UIDevice currentDevice] uniqueIdentifier] == NULL) {
        return [NSString stringWithFormat:@"%@:%@", kTYPE_SHA1_HASHED_UDID, @"0"];
    }
    else {
        return [NSString stringWithFormat:@"%@:%@", kTYPE_SHA1_HASHED_UDID, [[[UIDevice currentDevice] uniqueIdentifier] SHA1]];
    }
}
#endif

+ (NSString*) deviceID {
    NSMutableArray* ids = [NSMutableArray arrayWithCapacity:5]; // autoreleased

#ifdef TAPAD_IDENTIFIER_ENABLE_OPENUDID
    if ([TapadIdentifiers willSendOpenUDID]) {
      [ids addObject:[TapadIdentifiers fetchOpenUDID]];
    }
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_MAC
    if ([TapadIdentifiers willSendMD5HashedMAC]) {
        [ids addObject:[TapadIdentifiers fetchMD5HashedMAC]];
    }
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_MAC
    if ([TapadIdentifiers willSendSHA1HashedMAC]) {
        [ids addObject:[TapadIdentifiers fetchSHA1HashedMAC]];
    }
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_UDID
    if ([TapadIdentifiers willSendMD5HashedUDID]) {
        [ids addObject:[TapadIdentifiers fetchMD5HashedUDID]];
    }
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_UDID
    if ([TapadIdentifiers willSendSHA1HashedUDID]) {
        [ids addObject:[TapadIdentifiers fetchSHA1HashedUDID]];
    }
#endif

    if ([ids count] == 0) {
        return [TapadIdentifiers defaultDeviceID];
    }
    else {
        return [ids componentsJoinedByString:@","];
    }
}

+ (NSString*) defaultDeviceID {
    // by default, if nothing is explicitly enabled, we will send OpenUDID
    return [OpenUDID value];
}

@end
