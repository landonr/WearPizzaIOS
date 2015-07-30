//
//  Store.swift
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-29.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import SwiftyJSON

public class Store: NSObject {
    public var addressDescription : String = ""
    public var storeID : Int = -1
    
    public func initWithJSON(jsonData : JSON) -> Void
    {
        addressDescription = jsonData["AddressDescription"].stringValue
        storeID = jsonData["StoreID"].intValue
    }
}
