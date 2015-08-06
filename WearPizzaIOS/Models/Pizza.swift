//
//  Topping.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-04.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

public class Topping: NSObject {
    public var code : String = ""
    public var name : String = ""
    public var size : String = ""
    
    public func initWithJSON(jsonData : JSON) -> Void
    {
        code = jsonData["Code"].stringValue
        name = jsonData["Name"].stringValue
        if jsonData["Size"] {
            size = jsonData["Size"].stringValue
        } else {
            size = "1"
        }
    }
    
    public func toDictionary(count: Int, index: Int) -> Dictionary<String, Dictionary<String, String>>
    {
        var ratio = String(index) + "/" + String(count)
        var new = [code: [ratio: size]]
        return new
    }
}

public class Pizza: NSObject {
    public var toppings: [Topping] = []
    public var size: String = "12"
    
    public func initWithToppingsAndSize(newToppings : [Topping], newSize: String) -> Void
    {
        toppings = newToppings
        size = newSize
    }
}
