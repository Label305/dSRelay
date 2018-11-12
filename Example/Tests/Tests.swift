import Quick
import Nimble
import dSRelay
import SwiftSocket
import InstantMock
import then

class DeviceInitTests : QuickSpec {
    override func spec() {
        describe("creating a device") {
            it("will return nil when connecting fails") {
                expect(Device(ipaddress: "127.0.0.1", port: 17123, timeout: 5) == nil) == true
            }
        }
    }
}

class CounterTests : QuickSpec {
    override func spec() {
        describe("counter commands") {
            it("should return correct counter statuses for device") {
                let dev = DeviceMock()
                
                dev.setExpectedValues(returnData: Array<UInt8>(repeating: 0x0F, count: 8))
                dev.getCounters(counterNr: 1).then { statusObject in
                    expect(statusObject.0 == UInt(0b00001111000011110000111100001111)) == true
                }
            }
        }
    }
}

class RelayTests : QuickSpec {
    override func spec() {
        describe("relay commands") {
            it("should set a relay") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [0x00])
                dev.setRelay(relayNr: 1, set: Status.On).then { result in
                    expect(result) == true
                }
                dev.setExpectedValues(returnData: [0x01])
                dev.setRelay(relayNr: 1, set: Status.On).then { result in
                    expect(result) == false
                }
            }

            it("should set a relay with status") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [0x00])
                dev.setRelay(relayNr: 1, pulseTime: 1000).then { result in
                    expect(result) == true
                }
                dev.setExpectedValues(returnData: [0x01])
                dev.setRelay(relayNr: 1, pulseTime: 1000).then { result in
                    expect(result) == false
                }
            }

            it("should get correct relay statuses with firmware >=3") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [0x00, 0xFF, 0x00, 0xFF, 0x00])
                dev.setFirmwareVersion(versionMajor: 4)
                dev.getRelayStatus().then { statuses in
                    for i in 0..<8 {
                        expect(statuses[i] == false) == true
                    }

                    for i in 8..<16 {
                        expect(statuses[i]) == true
                    }

                    for i in 16..<24 {
                        expect(statuses[i] == false) == true
                    }

                    for i in 24..<32 {
                        expect(statuses[i]) == true
                    }
                }
            }

            it("should get correct relay statuses with firmware <3") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [0x00, 0xFF, 0x00, 0xFF, 0x00])
                dev.setFirmwareVersion(versionMajor: 2)
                dev.getRelayStatus().then { statuses in
                    for i in 0..<8 {
                        expect(statuses[i]) == true
                    }

                    for i in 8..<16 {
                        expect(statuses[i] == false) == true
                    }

                    for i in 16..<24 {
                        expect(statuses[i]) == true
                    }

                    for i in 24..<32 {
                        expect(statuses[i] == false) == true
                    }
                }
            }
        }
    }
}

class OutputTests : QuickSpec {
    override func spec() {
        describe("output commands") {
            it("should set an output") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [0x00])
                dev.setOutput(ioNumber: 1, set: Status.On).then { value in
                    expect(value) == true
                }

                dev.setExpectedValues(returnData: [0x01])
                dev.setOutput(ioNumber: 1, set: Status.On).then { value in
                    expect(value) == false
                }
            }
        }
    }
}

class InputTests : QuickSpec {
    override func spec() {
        describe("input commands") {
            it("should get input statues") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [0x00, 0b01010101])
                dev.getInputStatus().then { values in
                    for i in 0..<8 {
                        expect(values[i] == (i % 2 == 1)) == true
                    }
                }
            }

            it("should get analogue input statuses") {
                let dev = DeviceMock()
                dev.setExpectedValues(returnData: [
                    0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF,
                    0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00
                ])

                dev.getAnalogueInputStatus().then { values in
                    for i in 0..<4 {
                        expect(values[i] == UInt16(0x00FF)) == true
                    }
                    
                    for i in 4..<8 {
                        expect(values[i] == UInt16(0xFF00)) == true
                    }
                }
            }
        }
    }
}

class DeviceMock : Device, MockDelegate {
    private let mock = Mock()
    private var returnData: [Byte] = []
    
    var it: Mock {
        return mock
    }
    
    init() {
        super.init(connection: TCPClient(address: "127.0.0.1", port: 80), timeout: 0)
    }
    
    public func setFirmwareVersion(versionMajor: UInt8) {
        self.status = ["appFirmwareMajor": UInt(versionMajor)]
    }
    
    public func setExpectedValues(returnData: [UInt8]) {
        self.returnData = returnData
    }
    
    override func send(data: [UInt8], expectedLength: Int) -> Promise<[UInt8]> {
        return Promise { resolve, reject in
            resolve(self.returnData)
        }
    }
}
