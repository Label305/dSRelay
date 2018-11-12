//
//  Output.swift
//  dSRelay
//
//  Created by Mèir Noordermeer
//  Copyright © 2018 Label305 B.V. All rights reserved.
//

import Foundation
import then

extension Device {
    open func setOutput(ioNumber: UInt8, set: Status) -> Promise<Bool> {
        let payload: [UInt8] = [0x32, ioNumber, set.rawValue]
        
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

}
