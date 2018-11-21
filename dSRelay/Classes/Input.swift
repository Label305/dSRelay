//
//  Input.swift
//  dSRelay
//
//  Created by Mèir Noordermeer
//  Copyright © 2018 Label305 B.V. All rights reserved.
//

import Foundation
import then

extension Device {
    open func getInputStatus() -> Promise<[Bool]> {
        let payload: [UInt8] = [0x34, 0x01, 0x01]

        return Promise { resolve, reject in
            self.send(data: payload, expectedLength: 2)
                .then { data in
                    var status: [Bool] = Array<Bool>(repeating: false, count: 8)

                    let binaryString = data[1].toBits().pad(with: "0", toLength: 8)

                    var i = 0
                    for c in binaryString {
                        status[7 - i] = c == "1"
                        i += 1
                    }

                    resolve(status)
                }
                .onError { error in
                    reject(error)
            }
        }
    }

    open func getAnalogueInputStatus() -> Promise<[UInt16]> {
        let payload: [UInt8] = [0x35]

        return Promise { resolve, reject in
            self.send(data: payload, expectedLength: 16)
                .then { data in
                    var status: [UInt16] = Array<UInt16>(repeating: 0, count: 8)

                    for i in 0..<8 {
                        let dIndex1 = i * 2
                        let dIndex2 = (i + 1) * 2 - 1
                        
                        status[i] = (UInt16(data[dIndex1]) << 8) | UInt16(data[dIndex2])
                    }

                    resolve(status)
                }
                .onError { error in
                    reject(error)
            }
        }
    }
}
