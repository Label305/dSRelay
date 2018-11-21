//
//  ViewController.swift
//  dSRelay
//
//  Created by meirbon on 11/12/2018.
//  Copyright (c) 2018 meirbon. All rights reserved.
//

import UIKit
import dSRelay

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let device = Device(ipaddress: "127.0.0.1", port: 17123) {
            // successfully connected to device
            device.getStatus().then { status in // asynchronously get info of device
            }

            if let status = device.getRelayStatus().value {// synchronously get info of device
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

