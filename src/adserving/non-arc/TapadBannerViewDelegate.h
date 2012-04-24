//
//  TapadAdViewDelegate.h
//  TapadAdSDK
//
//  Created by Li Qiu on 4/23/12.
//  Copyright 2012 Tapad, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TapadBannerView;

// Tapad's ads are displayed inside a TapadAdView instance, which handles                                                                                                                                                                       
// UI interactions and events.  It stores a pointer to an object that                                                                                                                                                                         
// adopts this delegate protocol, which is notified of important events                                                                                                                                                                       
// and handles interactions with the ad network.                                                                                                                                                                                              
@protocol TapadBannerViewDelegate <NSObject>

@required
// sent when the ad has been loaded from the server, and it is about to be                                                                                                                                                                    
// sent to the view for display onscreen                                                                                                                                                                                                      
-(void)adWillAppear:(TapadBannerView*)view;

// sent when an ad request has completed fetching an ad from the network                                                                                                                                                                      
- (void)didReceiveAd:(TapadBannerView *)view;

// sent when we could not fetch the ad                                                                                                                                                                                                        
- (void)didFailToReceiveAd:(TapadBannerView *)view withError:(NSError*)error;

@optional
// sent immediately before presenting a full screen ad view to the user                                                                                                                                                                       
// this let you gracefully stop other activities in the application                                                                                                                                                                           
- (void)willPresentScreen:(TapadBannerView *)adView;
- (void)willDismissScreen:(TapadBannerView *)adView;
- (void)didDismissScreen:(TapadBannerView *)adView;
- (void)willLeaveApplication:(TapadBannerView *)adView;

@end
