//
//  TapadIdentifiers.h
//
//  Created by Li Qiu on 6/20/2012.
//  Copyright 2012 Tapad, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TapadIdentifiers : NSObject {}

+ (BOOL) willSendOpenUDID;
+ (void) sendOpenUDID:(BOOL)state;
+ (BOOL) willSendMD5HashedMAC;
+ (void) sendMD5HashedMAC:(BOOL)state;
+ (BOOL) willSendSHA1HashedMAC;
+ (void) sendSHA1HashedMAC:(BOOL)state;

+ (NSString*) deviceID;

@end
