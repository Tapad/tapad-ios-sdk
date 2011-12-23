//
//  TapadAdSDK.h
//  TapadAdSDK
//
//  Created by Li Qiu on 11/11/11.
//  Copyright 2011 Tapad, Inc. All Rights Reserved.
//

#import "TapadAdRequest.h"

@interface TapadAdSDK : NSObject {}

/**
 * Get an ad request object with some default values
 */
+ (TapadAdRequest*) newAdRequest;

@end
