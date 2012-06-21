//
//  NSString+MD5.m
//  AdWhirlSDK2_Sample
//
//  Created by gmack on 6/30/11.
//  Copyright 2011 Gerald MacKenzie . All rights reserved.
//

#import "NSString+MD5.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MD5)


- (NSString*)MD5 {

    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);

    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }

    return output;
    
}

- (NSString*)SHA1 {
    
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char sha1Buffer[CC_SHA1_DIGEST_LENGTH];
    
    // Create 20 byte SHA1 hash value, store in buffer
    CC_SHA1(ptr, strlen(ptr), sha1Buffer);
    
    // Convert SHA1 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",sha1Buffer[i]];
    }
    
    return output;
    
}
@end
