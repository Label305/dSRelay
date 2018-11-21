# dSRelay

[![CI Status](https://travis-ci.com/Label305/dSRelay.svg?branch=master)](https://travis-ci.com/Label305/dSRelay)
[![Version](https://img.shields.io/cocoapods/v/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)
[![License](https://img.shields.io/cocoapods/l/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)
[![Platform](https://img.shields.io/cocoapods/p/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)

dSRelay is a small library to connect with Robot Electronics network
relay devices. This library implements all binary commands specified
by Robot Electronics' documentation.

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

## Sending Commands

The binary command set documented by Robot Electronics is implemented
in this library.

### Get Status

``` swift
device.getStatus.then { status in
    // status is a Dictionary<String, UInt> with the following keys:
    // moduleID
    // systemFirmwareMajor
    // systemFirmwareMinor
    // appFirmwareMajor
    // appFirmwareMinor
    // volts
    // internalTemperature
}
```

### Set a Relay

``` swift
// set a relay on/off
device.setRelay(relayNr: 1, set: Status.On).then { result in
    // result is a boolean inidicating whether the command succeeded
}

// set a relay on for a certain duration (in ms)
device.setRelay(relayNr: 1, pulseTime: 1000).then { result in
    // result is a boolean inidicating whether the command succeeded
}
```

###

### Get Status of Relays

``` swift
device.getRelayStatus().then { statuses in
    // statuses is an array of 32 (virtual) relays
}
```

### Get Input

``` swift
device.getInputStatus().then { inputs in
    // array of 8 booleans for each input's status (on/off)
}

device.getAnalogueInputStatus().then { inputs in
    // array of 8 UInt16s indicating the analogue input's status
}
```

### Get Counters

``` swift
device.getCounters().then { counters in
    // counters is a tuple of (counterValue: UInt, captureRegister: UInt)
}
```

## Installation

dSRelay is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'dSRelay'
```

## License

dSRelay is available under the Apache 2.0 license. See the LICENSE file for more info.
