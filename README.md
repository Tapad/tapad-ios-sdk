Tapad iOS SDK
===========================

This open source iOS library allows you to integrate Tapad features into your iOS application include iPhone, iPad and iPod touch.

Except as otherwise noted, the Tapad iOS SDK is licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html)

Getting Started
===============

The SDK has a dependency on OpenUDID (https://github.com/ylechelle/OpenUDID). The source code of OpenUDID is included in this project and will be kept up-to-date on a weekly basis.

Setup Your Environment
----------------------

* If you haven't already done so, set up your iPhone development environment by following the [iPhone Dev Center Getting Started Documents](https://developer.apple.com/iphone/index.action).

* The projects were created with Xcode 4.2 with ARC enabled.

* Install [Git](http://git-scm.com/).

* Pull this SDK from GitHub:

       git clone git://github.com/Tapad/tapad-ios-sdk.git

Sample Applications
-------------------

This SDK comes with a sample application that demonstrates launch event tracking.

To build and run the sample application with Xcode (4.2 with ARC enabled):

* Open the included Xcode Project File by selecting _File_->_Open..._ and selecting DemoApp/DemoApp.xcodeproj.

* Specify your Tapad AppId in DemoAppAppDelegate.m if available.

* Select _Product_->_Build_ and then _Product_->_Run_.

* Check the output console for logging indicating that the launch tracking event was successfully sent and received.

* The launch tracking event is sent only on the first app launch.  Update the preferences or _Reset Content and Settings..._ in the iOS Simulator to enable the demo app to send it again.

Integrate With Your Own Application
-----------------------------------

To integrate the Tapad Event Tracking capability into an existing application, follow these steps:

* Copy the Tapad SDK into your Xcode project:
  * In Xcode, select _File_->_Open..._ and select src/event-tracking/TapadEvent.xcodeproj.
  * With your own application project open in Xcode, create a group called TapadEvent and drag and drop the contents of the "TapadEvent/TapadEvent" group from the TapadEvent project into the group in your own application project.
  * With your own application project open in Xcode, create a group called OpenUDID and drag and drop the contents of the "TapadEvent/OpenUDID" group from the TapadEvent project into the group in your own application project.
  * Include the TapadEvent headers in your code:

        \#import "TapadEvent.h"

  * You should now be able to compile your project successfully.

Usage
-----

With the iOS SDK, you can do two main things:

* Track application install events.

* Track arbitrary events.

Initialization
--------------

Register the Tapad application ID, if available, by calling:

        [TapadEvent registerAppWithId:appId];

Where _appId_ is your Tapad application ID string.

If not registered, the application ID on the events sent will default to CFBundleName.

Tracking Application Install Events
-----------------------------------

In "- (void)applicationDidFinishLaunching:(UIApplication *)application" of the main application delegate, add the following code:

        [TapadEvent applicationDidFinishLaunching:application];

Tracking Arbitrary Events
-------------------------

In the appropriate location, add the following code:

        [TapadEvent send:eventName];

Where _eventName_ is the event type string you wish to track.

Disabling ARC Support
---------------------

If your Xcode project is compiling without ARC support, please take a look at the non-ARC version of the SDK and DemoApp as provided in src/non-arc.  All usages described above remain the same.
