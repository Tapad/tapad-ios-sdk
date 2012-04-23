//
//  TapadBannerView.h
//  TapadAdSDK
//
//  Created by Li Qiu on 4/23/12.
//  Copyright 2012 Tapad, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapadAdRequest.h"
#import "TapadBannerViewDelegate.h"

@interface TapadBannerView : UIView<UIWebViewDelegate>

@property (nonatomic, assign) NSObject<TapadBannerViewDelegate> *delegate;
@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, retain) UIWebView *htmlAdView;

- (void)loadRequest:(TapadAdRequest *)request; // calls loadRequestAsynch
- (void)loadRequestAsynch:(TapadAdRequest *)request;
- (void)loadRequestSynch:(TapadAdRequest *)request;
@end
