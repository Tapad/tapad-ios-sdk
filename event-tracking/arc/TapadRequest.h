//
//  TapadRequest.h
//
//  Created by gmack on 7/8/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Common request objects to Tapad contain certain parameters and characteristics
// that are a pain to specify each time we send something to the server. This
// class DRYs up the code. 

@class TapadEvent;

@interface TapadRequest : NSObject {}

// using its initialized state, makes a blocking GET request to the 
// server, and formats the resulting raw data into an UTF8 encoded string
// the returned string will be autoreleased
- (NSString*) getSynchronous; 

// returns autoreleased request object for event tracking such as install tracking
+ (TapadRequest*) requestForEvent:(TapadEvent*)event;

// in some cases you may want direct access to the request 
@property (nonatomic,retain) NSURLRequest* request;
@property (nonatomic,retain) NSError* lastError;
@property (nonatomic,retain) NSHTTPURLResponse* lastResponse;
@property (nonatomic) BOOL wrapsHTML; // if set to YES, it will automatically wrap the returned HTML with full html
@property (nonatomic) BOOL hasError; // if set to YES, it will automatically wrap the returned HTML with full html
@property (nonatomic) BOOL responseSuccess;  // YES only if status code is 200. if there were no serious error, we could still get 404's and what not.

// returns an autoreleased string with description of last status code
- (NSString*) responseStatusCodeDescription;


@end
