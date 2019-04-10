//
//  dSRelay.swift
//  dSRelay
//
//  Created by Mèir Noordermeer on 12/11/2018.
//  Copyright © 2018 Label305 B.V. All rights reserved.
//

import Foundation
import SwiftSocket
import then

open class Device {
    let timeout: Int
    var ipaddress: String
    var port: Int32
    var connection: TCPClient?
    public var status: Dictionary<String, UInt>?

    public init?(ipaddress: String, port: UInt, timeout: Int = 5) {
        self.ipaddress = ipaddress
        self.port = Int32(port)
        self.timeout = timeout
        self.connection = nil

        let connection = self.connect().value
        if connection == nil {
            return nil
        }
    }

    public init(connection: TCPClient, timeout: Int = 5) {
        self.ipaddress = connection.address
        self.port = connection.port
        self.timeout = timeout
        self.connection = connection
    }

    deinit {
        if self.connection != nil {
            self.connection!.close()
        }
    }

    public func isConnected() -> Bool {
        return self.connection != nil
    }

    public func connect() -> Promise<TCPClient> {
        return Promise {resolve, reject in
            if let client = self.connection {
                resolve(client)
            } else {
                let client = TCPClient(address: self.ipaddress, port: self.port)

                switch client.connect(timeout: self.timeout) {
                case .success:
                    self.connection = client
                    self.getStatus().then { status in
                        self.status = status
                        resolve(client)
                    }
                case .failure(let error):
                    self.status = nil
                    self.connection = nil
                    client.close()
                    reject(error)
                }
            }
        }
    }

    open func send(data: [UInt8], expectedLength: Int) -> Promise<[Byte]> {
        return Promise { resolve, reject in
            self.connect()
                .then { client in
                    switch client.send(data: data) {
                    case .success:
                        if let data = client.read(expectedLength, timeout: self.timeout) {
                            resolve(data)
                        }
                    case .failure(let error):
                        reject(error)
                    }
                }.onError { error in
                    reject(error)
            }
        }
    }

    open func getStatus() -> Promise<Dictionary<String, UInt>> {
        let payload: [UInt8] = [0x30]

        return Promise { resolve, reject in
            self.send(data: payload, expectedLength: 8)
                .then { data in

                    if data.count < 8 {
                        reject(StatusError.MinimumResponseLengthNotSatisfiedError)
                    }


                    let status: Dictionary<String, UInt> = [
                        "moduleID": UInt(data[0]),
                        "systemFirmwareMajor": UInt(data[1]),
                        "systemFirmwareMinor": UInt(data[2]),
                        "appFirmwareMajor": UInt(data[3]),
                        "appFirmwareMinor": UInt(data[4]),
                        "volts": UInt(data[5]),
                        "internalTemperature": UInt((data[6] << 8) | data[7]) // 6th byte is high byte, 7th byte is low byte
                    ]

                    resolve(status)
                }.onError { error in
                    reject(error)
            }
        }
    }
}

public enum Status: UInt8 {
    case On = 0x01
    case Off = 0x00
}
