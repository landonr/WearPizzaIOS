//
//  Address.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-02.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

public class Address: NSObject {
    public var city : String = ""
    public var postalCode : String = ""
    public var address : String = ""
    public var province : String = ""
    public var type : String = "Delivery"
    
    public func initWithJSON(jsonData : JSON) -> Void
    {
        city = jsonData["City"].stringValue
        postalCode = jsonData["postalCode"].stringValue
        address = jsonData["address"].stringValue
        province = jsonData["province"].stringValue
        type = jsonData["type"].stringValue
    }
    
    public func initWithCLPlacemark(placemark : CLPlacemark) -> Void
    {
        city = placemark.locality
        postalCode = placemark.postalCode
        address = placemark.thoroughfare
        province = placemark.administrativeArea
        type = "Delivery"
    }
    
    public func toDictionary() -> Dictionary<String, String>
    {
        var newDictionary:NSDictionary = [
            "city":         city,
            "postalCode":   postalCode,
            "address":      address,
            "province":     province,
            "type":         type]
        return newDictionary as! Dictionary<String, String>
    }
    
    public func toRequest() -> String
    {
        var newRequest = ""
        newRequest += "type="
        newRequest += type
        newRequest += "&c="
        newRequest += city
        newRequest += "%2C+"
        newRequest += province
        newRequest += "%2C+"
        newRequest += postalCode
        newRequest += "&s="
        newRequest += address

        var customAllowedSet =  NSCharacterSet(charactersInString:" ").invertedSet

        return newRequest.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
    }
}