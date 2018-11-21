# dSRelay

[![CI Status](https://img.shields.io/travis/meirbon/dSRelay.svg?style=flat)](https://travis-ci.org/meirbon/dSRelay)
[![Version](https://img.shields.io/cocoapods/v/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)
[![License](https://img.shields.io/cocoapods/l/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)
[![Platform](https://img.shields.io/cocoapods/p/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)

## Example

To run the example/tests project, clone the repo, and run `pod install` from the Example directory first.

To create a device:

``` swift
if let device = Device(ipaddress: <ipaddress>, port : 17123) {
    // do something
}

device.getStatus().then { status in // asynchronously get info of device
}

if let status = device.getRelayStatus().value // synchronously get info of device
```

## Installation

dSRelay is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'dSRelay'
```

## Author

meirbon, meirnoordermeer@me.com

## License

dSRelay is available under the Apache 2.0 license. See the LICENSE file for more info.
