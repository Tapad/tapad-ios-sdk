# Tapad iOS Event Tracking API Demo App
This application exercises the full range of identifiers collectable by the SDK. [MyEnabledTapadIdentifiers.h](MyEnabledTapadIdentifiers.h) enables all of the pre-complier flags. [DemoAppAppDelegate.m](Classes/DemoAppAppDelegate.m) demonstrate the enabling and disabling of each via config. Please note that if you choose to not enable the pre-compiler flag for a given identifier, the config method for the identifier will not be available (i.e. XCode will warn you that the method is not available).

## iOS 6 Advertising Identifier
iOS 6 introduced -[ASIdentifierManager advertisingIdentifier] which is now supported by this SDK. The SDK respects the user's intent by first checking -[ASIdentifierManager isAdvertisingTrackingEnabled].  Please run this application with iOS 6 simulator as well as iOS 4 or 5 simulators to see the difference in behavior when the API is not available.

## iOS 6 Identifier For Vendor
iOS 6 introduced -[UIDevice identifierForVendor] which is now supported by this SDK. The value in this property remains the same while the app (or another app from the same vendor) is installed on the iOS device. The value changes when the user deletes all of that vendor’s apps from the device and subsequently reinstalls one or more of them. Please run this application with iOS 6 simulator as well as iOS 4 or 5 simulators to see the difference in behavior when the API is not available.
