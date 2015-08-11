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
    
    public func toRequestDictionary(count: Int, index: Int) -> Dictionary<String, Dictionary<String, String>>
    {
        var ratio = String(index) + "/" + String(count)
        var new = [code: [ratio: "1"]]
        return new
    }
    
    public func toDictionary() -> Dictionary<String, String>
    {
        var newDictionary:Dictionary<String, String> = [
            "code":      code,
            "name":      name];
        return newDictionary
    }
    
    public func arrayToGeneric(toppingArray: Array<Topping>) -> Array<Dictionary<String, String>>
    {
        var newArray:Array<Dictionary<String, String>> = []
        for topping in toppingArray {
            var newDictionary:Dictionary = topping.toDictionary()
            newArray.append(newDictionary)
        }
        
        return newArray
    }
    
    public func genericToArray(toppingArray: Array<Dictionary<String, String>>) -> Array<Topping>
    {
        var newArray: Array<Topping> = []
        for topping in toppingArray {
            var newTopping = Topping()
            newTopping.code = topping["code"]!
            newTopping.name = topping["name"]!
            newArray.append(newTopping)
        }
        
        return newArray
    }
}

public class Pizza: NSObject {
    public var toppings: [Topping] = []
    public var size: String = "12"
    
    public func toppingsToString() -> String
    {
        var returnString = ""
        if self.toppings.count == 0 {
            returnString += "Cheese"
        } else {
            for var i = 0; i < self.toppings.count; i++ {
                if( i > 0) {
                    if i == self.toppings.count - 1 {
                        returnString += ", and "
                    } else {
                        returnString += ", "
                    }
                }
                returnString += self.toppings[i].name
            }
        }
        return returnString
    }
    
    public func toDisplayString() -> String {
        var returnString = self.size + "\" " + self.toppingsToString()
        return returnString
    }
    
    public func initWithToppingsAndSize(newToppings : [Topping], newSize: String) -> Void
    {
        toppings = newToppings
        size = newSize + "\""
    }
}
