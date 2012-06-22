# Tapad iOS Event Tracking API
This API allows for app installation tracking (and attribution) as well as tracking other, arbitrary
events which then can be analyzed and visualized in the Tapad reporting dashboards.

## Configuring the available identifiers

This API allows for the collection of several different identifiers so as to support more accurate attributions with a variety of Ad SDKs. To enable the identifiers in a way that works best with evolving privacy standards, the SDK is coded in such a way that the ability to collect and send each identifier is controlled with a pre-compiler flag.

The developer should add to their project a header file called `MyEnabledTapadIdentifiers.h`. A sample copy of this with a list of all available flags commented out is provided with this project. The developer should enable any identifiers that they wish to use by uncommenting the flag for each. By leaving the flag commented out, all related functions used to retrieve the identifier will be excluded from the compiled app.

In addition, the app will need to be configured to send the identifier by calling the appropriate method on `TapadIdentifiers`. For example:

```objective-c
  [TapadIdentifiers sendOpenUDID:YES];
```

The full list of identifiers is exercised in the provided demo app. The developer is encouraged to view it for reference.

## Initialization and install tracking

In `- (void)applicationDidFinishLaunching:(UIApplication *)application` of the main application delegate, add the following code:

```objective-c
  // register the Tapad Given Application Identifier
  [TapadEvent registerAppWithId:@"Tapad_Provided_App_Id"];

  // enable any identifiers that are to be used
  [TapadIdentifiers sendOpenUDID:YES];
  [TapadIdentifiers sendMD5HashedMAC:YES];
  [TapadIdentifiers sendSHA1HashedMAC:YES];
  ...

  // trigger the application install tracking
  [TapadEvent applicationDidFinishLaunching:application];
```

This will send the conversion events, `install` to Tapad servers the first time a user runs the application.

## Custom event tracking
To track other events, such as a sign-up or an in-app purchase, place the following line of code after the event has happened:

```objective-c
  [TapadEvent send:@"some-event"];
```
