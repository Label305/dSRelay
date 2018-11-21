//
//  Counters.swift
//  dSRelay
//
//  Created by Mèir Noordermeer on 12/11/2018.
//  Copyright © 2018 Label305 B.V. All rights reserved.
//

import Foundation
import then

extension Device {
    /**
     * Returns a tuple of (counterValue, captureRegister)
     */
    open func getCounters() -> Promise<(UInt, UInt)> {
        let payload: [UInt8] = [0x36, 0x01]
        
        return Promise { resolve, reject in
            self.send(data: payload, expectedLength: 8)
                .then { data in
                    var counterValue: UInt = 0
                    var captureRegister: UInt = 0
                    
                    counterValue = counterValue | (UInt(data[0]) << 24)
                    counterValue = counterValue | (UInt(data[1]) << 16)
                    counterValue = counterValue | (UInt(data[2]) << 8)
                    counterValue = counterValue | UInt(data[3])
                    
                    captureRegister = captureRegister | (UInt(data[4]) << 24)
                    captureRegister = captureRegister | (UInt(data[5]) << 16)
                    captureRegister = captureRegister | (UInt(data[6]) << 8)
                    captureRegister = captureRegister | UInt(data[7])
                    
                    resolve((counterValue, captureRegister))
                }
                .onError { error in
                    reject(error)
            }
        }
    }
}
