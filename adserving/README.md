Ad Serving
===========

Sample Application
------------------

This SDK comes with a sample application that demonstrates requesting ads from the Tapad Ad Server.

To build and run the sample application with Xcode (4.2 with ARC disabled):

* Open the included Xcode Project File by selecting _File_->_Open..._ and selecting adserving/TapadAdSDKDemoApp-NonArc/TapadAdSDKDemoApp-NonArc.xcodeproj.

* Select _Product_->_Build_ and then _Product_->_Run_.

* On launch, the app will load a 300x50 ad unit into a 50 pxl high web view.

Integrate With Your Own Application
-----------------------------------

To integrate the Tapad Ad Serving capability into an existing application, follow these steps:

* Copy the Tapad Ad SDK into your Xcode project:
  * In Xcode, select _File_->_Open..._ and select adserving/non-arc/TapadAdSDK.xcodeproj.
  * With your own application project open in Xcode, create a group called TapadAdSDK and drag and drop the contents of the "TapadAdSDK" group from the TapadAdSDK project into the group in your own application project.
  * With your own application project open in Xcode, create a group called OpenUDID in TapadAdSDK and drag and drop the contents of the "TapadAdSDK/OpenUDID" group from the TapadAdSDK project into the group in your own application project.
  * Include the TapadAdSDK headers in your code:

        \#import "TapadAdSDK.h"
        \#import "TapadAdRequest.h"

  * You should now be able to compile your project successfully.

Usage
-----

Preparing the Ad Request
-----------------------

Sample code with parameters for your organization will be provided upon registration with Tapad.  To experiment on your own, follow these steps:

* Fetch a new ad request object with
        \TapadAdRequest* adRequest = [TapadAdSDK newAdRequest]

* Configure the ad server url with
        \adRequest.adServerUrl =

* Configure your organization id with
        \adRequest.publisherId =

* Configure your application id with
        \adRequest.propertyId =

* Configure your ad context id with
        \adRequest.placementId =

* Request an ad of a particular size with
        \adRequest.adSize =

Loading the Ad Unit
-------------------

Once an ad request has been prepared, it is reusuable for fetching ads with the same configuration.
The ads can be loaded in the following ways:

* Letting an UIWebView load the ad unit
  * Allocate a UIWebView with the appropriate dimensions
  * Load the prepared request with \[webView loadRequest:[adRequest getRequest]]

* Synchronously load the markup data
  * Load the markup data synchronously as a string with \NSString *adData = [adRequest getAd]
  * Insert the markup data into a UIWebView with \[webView loadHTMLString:adData baseURL:nil]
