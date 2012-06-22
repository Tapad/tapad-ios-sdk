//
//  TapadIdentifiers.h
//
//  Created by Li Qiu on 6/20/2012.
//  Copyright 2012 Tapad, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// edit this header file to enable identifiers allowed for your app
#import "MyEnabledTapadIdentifiers.h"

@interface TapadIdentifiers : NSObject {}

#ifdef TAPAD_IDENTIFIER_ENABLE_OPENUDID
+ (BOOL) willSendOpenUDID;
+ (void) sendOpenUDID:(BOOL)state;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_RAW_MAC
+ (BOOL) willSendMD5HashedRawMAC;
+ (void) sendMD5HashedRawMAC:(BOOL)state;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_RAW_MAC
+ (BOOL) willSendSHA1HashedRawMAC;
+ (void) sendSHA1HashedRawMAC:(BOOL)state;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_UDID
+ (BOOL) willSendMD5HashedUDID;
+ (void) sendMD5HashedUDID:(BOOL)state;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_UDID
+ (BOOL) willSendSHA1HashedUDID;
+ (void) sendSHA1HashedUDID:(BOOL)state;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_MD5_HASHED_MAC
+ (BOOL) willSendMD5HashedMAC;
+ (void) sendMD5HashedMAC:(BOOL)state;
#endif

#ifdef TAPAD_IDENTIFIER_ENABLE_SHA1_HASHED_MAC
+ (BOOL) willSendSHA1HashedMAC;
+ (void) sendSHA1HashedMAC:(BOOL)state;
#endif

+ (NSString*) deviceID;

@end
