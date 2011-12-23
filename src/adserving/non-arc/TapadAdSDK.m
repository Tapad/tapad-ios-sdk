//
//  TapadAdSDK.m
//  TapadAdSDK
//
//  Created by Li Qiu on 11/11/11.
//  Copyright 2011 Tapad, Inc. All Rights Reserved.
//

#import "TapadAdRequest.h"
#import "TapadAdSDK.h"

@interface TapadAdSDK ()
@end

@implementation TapadAdSDK

+ (TapadAdRequest*) newAdRequest {
    TapadAdRequest* request = [[TapadAdRequest alloc] init];
    request.adServerUrl = @"http://swappit.tapad.com/swappit/ad";
    request.adSize = CGSizeMake(320, 50);
    request.publisherId = nil;
    request.propertyId = nil;
    request.placementId = nil;
    request.wrapHtml = false;
    return request;
}

- (void)dealloc {
    [super dealloc];
}

@end
