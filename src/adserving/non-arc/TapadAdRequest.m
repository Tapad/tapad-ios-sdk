//
//  TapadAdRequest.m
//
//  Created by gmack on 7/8/11.
//  Copyright 2011 Tapad, Inc. All Rights Reserved.
//

#import "NSString+MD5.h"
#import "TapadAdRequest.h"
#import "OpenUDID.h"

#pragma mark private protocol for internal stuff

@interface TapadAdRequest() 

- (void) initializeRequest;
- (NSString*) stringWithTapadParams;

@property (retain) NSURLRequest* request;

- (BOOL) checkIfResponseSuccessful;
- (BOOL) checkForError;

+ (NSString*) visibleResponseStatusCode:(NSURLResponse *)response;
+ (NSString*) deviceId;
+ (NSString*) hashedDeviceId;

@end


@implementation TapadAdRequest

@synthesize adServerUrl;
@synthesize adSize;
@synthesize publisherId;
@synthesize propertyId;
@synthesize placementId;
@synthesize wrapHtml;

@synthesize request;

@synthesize lastError;
@synthesize lastResponse;
@synthesize hasError;
@synthesize responseSuccess;


// params understood by tapad
static NSString*const kuid           =@"uid";
static NSString*const kadSize        =@"adSize";
static NSString*const kcontextType   =@"contextType";
static NSString*const kpublisher     =@"pub";
static NSString*const kproperty      =@"prop";
static NSString*const kplacement     =@"placement";
static NSString*const kwrapHtml      =@"wrapHtml";

static const float kTimeout = 2.5;

// Must always override super's designated initializer.
- (id)init {
    self = [super init];
    return self;
}

- (void) initializeRequest{
    NSString *rawUrlStr = [NSString stringWithFormat:@"%@?%@",
                           self.adServerUrl,
                           [self stringWithTapadParams]
                           ]; // autoreleased

    NSString *urlString = [rawUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // autoreleased
    
    NSLog(@"raw request=[%@]",urlString);

    NSURL* url = [[NSURL alloc] initWithString:urlString];
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeout]; // autoreleased=>retained
    [url release];
}

- (void)dealloc {
    self.adServerUrl = nil;
    self.publisherId = nil;
    self.propertyId = nil;
    self.placementId = nil;

    self.request = nil;
    
    [super dealloc];
}

- (NSURLRequest*) getRequest {
    [self initializeRequest];
    return self.request;
}

// using the current request params, make a blocking call to the tapad server,
// and turn the raw data into a string (we expect it to be a chunk of html)
// the returned string will be marked for autorelease
- (NSString*) getAd {

    NSError* synchronousError=nil;
    NSHTTPURLResponse* synchronousResponse=nil;

    NSData* madData = [NSURLConnection sendSynchronousRequest:self.request 
                                            returningResponse:&synchronousResponse 
                                                        error:&synchronousError];
    
    self.lastResponse=synchronousResponse;
    self.lastError=synchronousError;

    NSString *tapadResponseString = @"";

    if ([self checkForError]) {
        tapadResponseString = [self.lastError localizedDescription];
    } else if ([self checkIfResponseSuccessful]) {

        tapadResponseString = [[[NSString alloc] initWithBytes:[madData bytes]
                                                        length:[madData length] 
                                                      encoding:NSUTF8StringEncoding] autorelease];
    }  // else there was an error! no response string!

    return tapadResponseString;
}

+ (NSString*) visibleResponseStatusCode:(NSURLResponse *)response {
    int statusCode = [(NSHTTPURLResponse*) response statusCode];
    return  [NSString stringWithFormat:@"Server response code=[code:%d \"%@\"]",statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode] ];
}

- (NSString*) responseStatusCodeDescription {
    return [TapadAdRequest visibleResponseStatusCode:self.lastResponse];
}

- (BOOL) checkIfResponseSuccessful {

    if(self.lastResponse==nil) {
        NSLog(@"[WARNING] response was nil!");
        self.responseSuccess=NO;
    }
    else if ([self.lastResponse isKindOfClass: [NSHTTPURLResponse class]]) {

        int statusCode = [self.lastResponse statusCode];
        NSLog(@"%@:status code=%d",[self class],statusCode); 

        switch (statusCode) {
            case 200:
                self.responseSuccess=YES;
                break;

            default:
                NSLog(@"%@",[self responseStatusCodeDescription]);
                self.responseSuccess=NO;
                break;
        }
    }

    return self.responseSuccess;
}

- (BOOL) checkForError {
    if (self.lastError) {
        NSLog(@"[ERROR] %@",[self.lastError localizedDescription]);
        self.hasError=YES;
    } else {
        self.hasError=NO;
    }
    return self.hasError;
}

#pragma mark param utilities

- (NSString*) stringWithTapadParams { // autoreleased 
    
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:12]; // autoreleased

    // anonymized device id
    [params addObject:[NSString stringWithFormat:@"%@=%@", kuid, [TapadAdRequest hashedDeviceId] ]]; 
    [params addObject:[NSString stringWithFormat:@"%@=%@", kadSize, [NSString stringWithFormat:@"%0.0fx%0.0f", self.adSize.width, self.adSize.height] ]];
    [params addObject:[NSString stringWithFormat:@"%@=%@", kcontextType, @"app" ]];
    if (self.publisherId != nil)
        [params addObject:[NSString stringWithFormat:@"%@=%@", kpublisher, self.publisherId ]];
    if (self.propertyId != nil)
        [params addObject:[NSString stringWithFormat:@"%@=%@", kproperty, self.propertyId ]];
    if (self.placementId != nil)
        [params addObject:[NSString stringWithFormat:@"%@=%@", kplacement, self.placementId ]];
    [params addObject:[NSString stringWithFormat:@"%@=%@", kwrapHtml, self.wrapHtml ? @"true" : @"false" ]];

    return [params componentsJoinedByString:@"&"];
}


#pragma mark class methods

// convenience methods
+ (NSString*) deviceId {
    return [OpenUDID value];
}

+ (NSString*) hashedDeviceId {
    return [[self deviceId] MD5];
}

@end
