//
//  SimpleAdViewController.m
//  TapadAdSDKDemoApp-NonArc
//
//  Created by Li Qiu on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleAdViewController.h"
#import "TapadAdrequest.h"
#import "TApadAdSDK.h"


@implementation SimpleAdViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"SimpleAdView Loading");
    self.view.backgroundColor = [UIColor colorWithRed:32 / 255.0f
                                                green:32 / 255.0f
                                                 blue:32 / 255.0f
                                                alpha:1.0];

    UIWebView* htmlAdView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    htmlAdView.delegate = self;
    [self.view addSubview: htmlAdView];

    // Below would be code picked up from Tapad
    TapadAdRequest* adRequest = [TapadAdSDK newAdRequest];                                                                                                                                                                   
    //adRequest.publisherId = @"Your Publisher Id";
    //adRequest.propertyId = @"Your Property Id";
    adRequest.wrapHtml = true; // get rid of the margin
    
    // load the ad!!!
    [htmlAdView loadRequest:[adRequest getRequest]];

    [adRequest release];
    [htmlAdView release];
}

- (void) dealloc
{
	[super dealloc];
}

#pragma mark webview delegate

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
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    } else {
        return YES; // means go on with normal behavior
    }
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    // beginning of load process
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // content's already loaded, so we should notify the adwhirl as well as the tapad delegate
    NSLog(@"webViewDidFinishLoad for URL:%@",[[webView request] URL]);    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView:didFailLoadWithError. URL was [%@] with error: %@",[[webView request]URL], error);
}
@end
