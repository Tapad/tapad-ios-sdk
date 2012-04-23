//
//  SimpleAdViewController.m
//  TapadAdSDKDemoApp-NonArc
//
//  Created by Li Qiu on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleAdViewController.h"
#import "TapadAdrequest.h"
#import "TapadBannerView.h"
#import "TApadAdSDK.h"

@interface SimpleAdViewController()

@property (retain) TapadBannerView* bannerView;

@end

@implementation SimpleAdViewController

@synthesize bannerView;

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"SimpleAdView Loading");
    self.view.backgroundColor = [UIColor colorWithRed:32 / 255.0f
                                                green:32 / 255.0f
                                                 blue:32 / 255.0f
                                                alpha:1.0];

    bannerView = [[TapadBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    bannerView.delegate = self;
    [self.view addSubview: bannerView];

    // Below would be code picked up from Tapad
    TapadAdRequest* adRequest = [TapadAdSDK newAdRequest];                                                                                                                                                                   
    //adRequest.publisherId = @"Your Publisher Id";
    //adRequest.propertyId = @"Your Property Id";
    adRequest.wrapHtml = true; // get rid of the margin
    
    // load the ad!!!
    [bannerView loadRequest:adRequest];

    [adRequest release];
}

- (void) dealloc
{
    [bannerView setDelegate:nil];
    [bannerView release];
	[super dealloc];
}

#pragma mark TapadBannerViewDelegate methods
-(void)adWillAppear:(TapadBannerView*)view {
    NSLog(@"ad will appear");
}

- (void)didReceiveAd:(TapadBannerView *)view {
    NSLog(@"ad received");
}

- (void)didFailToReceiveAd:(TapadBannerView *)view withError:(NSError*)error {
    NSLog(@"ad failed");
}

- (void)willLeaveApplication:(TapadBannerView *)adView {
    NSLog(@"leaving app");
}
@end
