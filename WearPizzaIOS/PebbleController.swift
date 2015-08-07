//
//  PebbleController.swift
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-08-06.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit

public class PebbleController: NSObject {
    var connectedWatch : PBWatch?
    
    override init() {
        let pebble = PBPebbleCentral.defaultCentral()
        //pebble.delegate = self
        
        var uuidBytes = Array<UInt8>(count:16, repeatedValue:0)
        let uuid = NSUUID(UUIDString: "7c6e2316-31ad-4d10-a7dd-bd0148d3342d")
        uuid?.getUUIDBytes(&uuidBytes)
        pebble.appUUID = NSData(bytes: &uuidBytes, length: uuidBytes.count)
        
        self.connectedWatch = pebble.lastConnectedWatch()
    }
    
    func syncDataToPebble() {
        if (self.connectedWatch == nil) {
            NSLog("No Pebble Connected!")
            return
        }
        
        self.connectedWatch!.appMessagesLaunch { (_, error) -> Void in
            if (error == nil) {
                NSLog("Pebble App Launched")
                
                let update : Dictionary<NSObject, AnyObject> = [2 : "Test Order String"]
                self.connectedWatch!.appMessagesPushUpdate(update, onSent: { (watch, dictionary, error) -> Void in
                    if (error == nil) {
                        NSLog("Pebble App Message Sent")
                    }
                    else {
                        NSLog("Error Sending Pebble App Message")
                    }
                })
            }
            else {
                NSLog("Error Launching Pebble App")
            }
        }
    }
}
