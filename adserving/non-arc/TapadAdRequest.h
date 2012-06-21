//
//  TapadAdRequest.h
//
//  Created by gmack on 7/8/11.
//  Copyright 2011 Tapad, Inc. All Rights Reserved.
//

// Common request objects to Tapad contain certain parameters and characteristics
// that are a pain to specify each time we send something to the server. This
// class DRYs up the code. 

@interface TapadAdRequest : NSObject {}

/**
 * Ad Server Location
 */
@property (retain) NSString* adServerUrl;

/**
 * Size of the ad being requested
 */
@property CGSize adSize;

/**
 * Top level id - assigned to publishing partner
 */
@property (retain) NSString* publisherId;

/**
 * Mid level id - assigned to app
 */
@property (retain) NSString* propertyId;

/**
 * Fine grained id - assigned to specific ad display location in app
 */
@property (retain) NSString* placementId;

/**
 * Ads will be returned with html and body tag wrapped (and margin 0)
 */
@property (assign) BOOL wrapHtml;

@property (nonatomic,retain) NSError* lastError;
@property (nonatomic,retain) NSHTTPURLResponse* lastResponse;
@property (nonatomic) BOOL hasError;
@property (nonatomic) BOOL responseSuccess;  // YES only if status code is 200. if there were no serious error, we could still get 404's and what not.

/**
 * Get the repared request
 */
- (NSURLRequest*) getRequest;

/**
 * Get the ad html (synchronous call)
 */
- (NSString*) getAd;

@end
