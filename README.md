# dSRelay

[![CI Status](https://travis-ci.com/Label305/dSRelay.svg?branch=master)](https://travis-ci.com/Label305/dSRelay)
[![Version](https://img.shields.io/cocoapods/v/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)
[![License](https://img.shields.io/cocoapods/l/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)
[![Platform](https://img.shields.io/cocoapods/p/dSRelay.svg?style=flat)](https://cocoapods.org/pods/dSRelay)

dSRelay is a small library to connect with Robot Electronics network
relay devices. This library implements all binary commands specified
by Robot Electronics' documentation.

To run the example/tests project, clone the repo, and run `pod install` from the Example directory first.

This library was tested on the [dS282](https://robot-electronics.co.uk/ds2824-24-x-16a-ethernet-relay.html)

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

The binary commands documented by Robot Electronics are implemented
in this library. [The original documentation can be found here](https://robot-electronics.co.uk/dscript.html).

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

Note: the order of relay status indicated in the bytes returned was changed between firmware versions 2 and 3.
This library takes this difference into account and thus should work with any device with any firmware.

For reference:

- [Documentation of firmware v2.20 (see page 33)](http://www.robot-electronics.co.uk/files/dS2824.pdf)

- [Documentation of firmware v3.01 (see page 38)](https://www.robotshop.com/media/files/pdf2/ds2824_-_v3.01.pdf)

``` swift
device.getRelayStatus().then { statuses in
    // statuses is an array of 32 (virtual) relays, 0 = status for relay 1 .. 31 = status for (virtual) relay 32
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
