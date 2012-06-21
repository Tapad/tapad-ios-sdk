//
//  TapadBannerView.m
//  TapadAdSDK
//
//  Created by Li Qiu on 4/23/12.
//  Copyright 2012 Tapad, Inc. All rights reserved.
//

#import "TapadBannerView.h"

@implementation TapadBannerView

@synthesize delegate;
@synthesize rootViewController;
@synthesize htmlAdView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.htmlAdView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
        [self.htmlAdView setDelegate:self];
        [self addSubview:self.htmlAdView];
    }
    
    return self;
}


- (void)dealloc
{
    if ([self.htmlAdView isLoading]) {
        [self.htmlAdView stopLoading];
    }
    [self.htmlAdView setDelegate:nil];
    self.htmlAdView = nil;
    self.delegate=nil; 
    [super dealloc];
}


- (void)loadRequest:(TapadAdRequest *)request { 
    [self loadRequestAsynch:request];
}


- (void)loadRequestAsynch:(TapadAdRequest *)request {
    [self retain];
    if ([self.htmlAdView isLoading]) {
        [self.htmlAdView stopLoading];
    }
    [self.htmlAdView loadRequest:request.getRequest]; // off you go! just tell me when it borks
    [self release];
}


- (void)loadRequestSynch:(TapadAdRequest *)request { 
    NSString *bidResponse = [request getAd]; //  autoreleased

    [self retain];
    // now command the webview to load the ad html 
    if ([self.htmlAdView isLoading]) {
        [self.htmlAdView stopLoading];
    }
    [self.htmlAdView loadHTMLString:bidResponse baseURL:nil];
    [self release];
}


#pragma mark uiwebview delegate

/**
 for reference:
 enum {
 UIWebViewNavigationTypeLinkClicked,
 UIWebViewNavigationTypeFormSubmitted,
 UIWebViewNavigationTypeBackForward,
 UIWebViewNavigationTypeReload,
 UIWebViewNavigationTypeFormResubmitted,
 UIWebViewNavigationTypeOther
 };
 
 */


/** 
 * This callback function, invoked after a click (e.g.), allows us to intercept the start of the loading of the request. We can choose to short-circuit that, 
 * and do something else, like load another application via its registered URL scheme.  This is where an external instance of mobile safari is launched 
 * and screen-swapped.  The same applies to itunes urls, etc.  If in fact an application already exists on the device, and has a URL scheme, then a 
 * link in the ad could even invoke that other application.  Call it app-landing links.  @gpmack 
 */
-(BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"shouldStartLoadWithRequest [%@]",[request URL]);
    
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = request.URL;
        if (self.delegate && [self.delegate respondsToSelector:@selector(willLeaveApplication:)]) {
            [self.delegate willLeaveApplication:self];
            NSLog(@"%@:bannerViewDelegate has been notified of ad clicked and leaving app",[self.delegate class]);
        }
        else {
            NSLog(@"no delegate to notify");
        }
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    else {
        return YES; // means go on with normal behavior
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    // beginning of load process
    NSLog(@"webViewDidStartLoad");
    if (self.delegate) {
        [self.delegate adWillAppear:self];
    }
    [self retain];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // content's already loaded, so we should notify the adwhirl as well as the tapad delegate
    NSLog(@"webViewDidFinishLoad for URL:%@",[[webView request] URL]);
    
    if (self.delegate) {
        [self.delegate didReceiveAd:self];
        NSLog(@"%@:bannerViewDelegate has been notified of receivedAd",[self.delegate class]);
    }
    else {
        NSLog(@"no delegate to notify");
    }
    [self release];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView:didFailLoadWithError. URL was [%@] with error: %@",[[webView request]URL], error);
    
    if (self.delegate) {
        [self.delegate didFailToReceiveAd:self withError:error];
        NSLog(@"%@:bannerViewDelegate has been notified of failure to load Ad",[self.delegate class]);
    }
    else {
        NSLog(@"no delegate to notify");
    }
    [self release];
}


@end
