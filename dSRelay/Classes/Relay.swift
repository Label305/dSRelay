//
//  Relay.swift
//  dSRelay
//
//  Created by Mèir Noordermeer
//  Copyright © 2018 Label305 B.V. All rights reserved.
//

import Foundation
import then

extension Device {
    /**
     * Sets a relay to the specified state
     */
    open func setRelay(relayNr: UInt8, set: Status) -> Promise<Bool> {
        let payload: [UInt8] = [0x31, relayNr, set.rawValue, 0x00, 0x00, 0x00, 0x000] // command byte
        
        return Promise { resolve, reject in
            self.send(data: payload, expectedLength: 1)
                .then { data in
                    resolve(data[0] == 0)
                }
                .onError { error in
                    reject(error)
            }
        }
    }
    
    /**
     * @param pulseTime: time to stay turned on in milliseconds
     */
    open func setRelay(relayNr: UInt8, pulseTime: UInt) -> Promise<Bool> {
        let payload: [UInt8] = [
            0x31,
            0x00,
            0x01,
            UInt8((pulseTime >> 24) & 0xFF),
            UInt8((pulseTime >> 16) & 0xFF),
            UInt8((pulseTime >> 8) & 0xFF),
            UInt8(pulseTime & 0xFF)
        ]
        
        return Promise { resolve, reject in
            self.send(data: payload, expectedLength: 1)
                .then { data in
                    resolve(data[0] == 0)
                }
                .onError { error in
                    reject(error)
            }
        }
    }
    /**
     * For major version < 3:
     * byte 0 contains the state of the requested relay (but ignored in this function)
     * byte 1 contains the states of relays 24 - 17
     * byte 2 contains the states of relays 16 - 9
     * byte 3 contains the states of relays 8 - 1
     * byte 4 contains the states of relays 32 - 25
     *
     * For version >=3:
     * byte 0 contains the state of the requested relay (but ignored in this function)
     * byte 1 contains the states of relays 32 - 25
     * byte 2 contains the states of relays 24 - 17
     * byte 3 contains the states of relays 16 - 9
     * byte 4 contains the states of relays 8 - 1
     */
    open func getRelayStatus() -> Promise<[Bool]> {
        let payload: [UInt8] = [0x33, 0x01]
        
        if self.status!["appFirmwareMajor"]! >= UInt(3) {
            return Promise { resolve, reject in
                self.send(data: payload, expectedLength: 32)
                    .then { data in
                        var status: [Bool] = Array<Bool>(repeating: false, count: 32)

                        var binaryString = String();
                        for i in 0..<4 {
                            binaryString += data[i + 1].toBits().pad(with: "0", toLength: 8)
                        }

                        var i = 31
                        for c in binaryString {
                            status[i] = c == "1"
                            i -= 1
                        }

                        resolve(status)
                    }.onError { error in
                        reject(error)
                }
            }
        } else {
            return Promise { resolve, reject in
                self.send(data: payload, expectedLength: 5)
                    .then { data in
                        var status: [Bool] = Array<Bool>(repeating: false, count: 32)
                        
                        var binaryString = String()
                        for i in 0...3 {
                            binaryString += data[i + 1].toBits().pad(with: "0", toLength: 8)
                        }
                        
                        var i = 23
                        for c in binaryString {
                            status[i] = c == "1"
                            
                            i -= 1
                            
                            if (i == -1) {
                                i = 31
                            }
                        }
                        
                        resolve(status)
                    }
                    .onError { error in
                        reject(error)
                }
            }
        }
    }
}

/**
 * Extension to String to pad a string to a specified length with a specified character
 */
extension String {
    public func pad(with padding: Character, toLength length: Int) -> String {
        let paddingWidth = length - self.count
        guard 0 < paddingWidth else { return self }
        
        return String(repeating: padding, count: paddingWidth) + self
    }
}

/**
 * Extension to UInt8 to turn the int into a String representing its values per bit
 * Used for reading values send back from the relay device
 */
extension UInt8 {
    public func toBits() -> String
    {
        let a = String( self, radix : 2 )
        let b = a.pad(with: "0", toLength: 8)
        return b
    }
}
