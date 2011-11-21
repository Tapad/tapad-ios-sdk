//
//  TapadRequest.m
//
//  Created by gmack on 7/8/11.
//  Copyright 2011 Tapad, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+MD5.h"
#import "TapadEvent.h"
#import "TapadRequest.h"
#import "OpenUDID.h"

#pragma mark private protocol for internal stuff

@interface TapadRequest() 

    @property (nonatomic,copy) NSString* protocol;
    @property (nonatomic,copy) NSString* dns;
    @property (nonatomic,copy) NSString* port;
    @property (nonatomic,copy) NSString* partner;

- (void) initializeRequestFromRawUrl:(NSString*)rawUrlStr;
- (NSString*) stringWithDeviceParams;


- (id) initWithEvent:(TapadEvent *)event;


// both of these assume the properties have been set during request processing
- (BOOL) checkIfResponseSuccessful;
- (BOOL) checkForError;

+ (NSString*) deviceID;
+ (NSString*) visibleResponseStatusCode:(NSURLResponse *)response;


@end


@implementation TapadRequest

@synthesize protocol;
@synthesize dns;
@synthesize port;
@synthesize partner;


@synthesize request;
@synthesize lastError;
@synthesize lastResponse;
@synthesize wrapsHTML;
@synthesize hasError;
@synthesize responseSuccess;


// params understood by tapad
static NSString*const kuid           =@"device_id";

+ (TapadRequest*) requestForEvent:(TapadEvent*)event {
    TapadRequest* request = [[TapadRequest alloc] initWithEvent:event];
    return [request autorelease];
}

// Must always override super's designated initializer.
- (id)init {
    self = [super init];
    if (self) {
        protocol=@"http";
#ifdef TAPAD_DEBUG
        dns=@"rtb-test.dev.tapad.com";
        port=@":8080";
#else
        dns=@"tap.tapad.com";
        port=@"";
#endif        
        wrapsHTML=NO; // by default, YES
        hasError=NO;
        responseSuccess=NO;
    }
    return self;
}

- (id) initWithEvent:(TapadEvent*)event{
    self = [self init]; // note: not super init!
    if (self) {
        
        NSString *rawUrlStr = [NSString stringWithFormat:@"%@://%@%@/apps/action?action_id=%@&app_id=%@&%@",
                               protocol, dns, port,
                               event.name,
                               event.appId,
                               [self stringWithDeviceParams]
                               ];

        [self initializeRequestFromRawUrl:rawUrlStr];

    }
    return self;  
}

static const float kTimeout = 2.5;

-(void) initializeRequestFromRawUrl:(NSString*)rawUrlStr {
    
    NSString *urlString = [rawUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // autoreleased
    
    NSLog(@"raw request=[%@]",urlString);

    NSURL* url =  [[NSURL alloc] initWithString:urlString];
    
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeout]; // autoreleased=>retained

    [url release];
}



- (void)dealloc {
    [protocol release];
    [dns release];
    [port release];
    [partner release];

    // will release as necessary
    self.lastError=nil;
    self.lastResponse=nil;
    self.request =nil;

    [super dealloc];
}

// using the current request params, make a blocking call to the tapad server,
// and turn the raw data into a string (we expect it to be a chunk of html)
// the returned string will be marked for autorelease
- (NSString*) getSynchronous {
            
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
        
        
        if (self.wrapsHTML) {
            tapadResponseString = [NSString stringWithFormat:@"<html><body style=\"margin:0px;\">%@</body></html>",tapadResponseString];            
        } 
        
    }  // else there was an error! no response string!
    
        
    return tapadResponseString;
}



+ (NSString*) visibleResponseStatusCode:(NSURLResponse *)response {
    int statusCode = [(NSHTTPURLResponse*) response statusCode];
    return  [NSString stringWithFormat:@"Server response code=[code:%d \"%@\"]",statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode] ];
}

- (NSString*) responseStatusCodeDescription {
    return [TapadRequest visibleResponseStatusCode:self.lastResponse];
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
    
    return   self.responseSuccess;
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

-(NSString*) stringWithDeviceParams { // autoreleased 

    NSMutableArray* params = [NSMutableArray arrayWithCapacity:5]; // autoreleased

    [params addObject:[NSString stringWithFormat:@"%@=%@", kuid, [TapadRequest deviceID] ]];

    /* Add as needed
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];

    [params addObject:[NSString stringWithFormat:@"bundleID=%@"             ,[info objectForKey:@"CFBundleIdentifier"] ]];
    [params addObject:[NSString stringWithFormat:@"bundleName=%@"           ,[info objectForKey:@"CFBundleName"] ]];
    [params addObject:[NSString stringWithFormat:@"bundleDisplayName=%@"    ,[info objectForKey:@"CFBundleDisplayName"] ]];
    [params addObject:[NSString stringWithFormat:@"bundleExec=%@"           ,[info objectForKey:@"CFBundleExecutable"] ]];
    [params addObject:[NSString stringWithFormat:@"bundleSignature=%@"      ,[info objectForKey:@"CFBundleSignature"] ]];
    [params addObject:[NSString stringWithFormat:@"bundleVersion=%@"        ,[info objectForKey:@"CFBundleVersion"] ]];
    [params addObject:[NSString stringWithFormat:@"bundlePackage=%@"        ,[info objectForKey:@"CFBundlePackageType"] ]];
     */

    return [params componentsJoinedByString:@"&"];
}


#pragma mark class methods

// convenience method
+ (NSString*) deviceID {
    return [OpenUDID value];
}

@end
