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
    public var firstName: String = ""
    public var lastName: String = ""
    public var email: String = ""
    public var phone: String = ""
    
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
            "type":         type,
            "firstName":    firstName,
            "lastName":     lastName,
            "email":        email,
            "phone":        phone]
        return newDictionary as! Dictionary<String, String>
    }
    
    public func toRequestDictionary() -> Dictionary<String, String>
    {
        var newDictionary:NSDictionary = [
            "City":         city,
            "PostalCode":   postalCode.stringByReplacingOccurrencesOfString(" ", withString: ""),
            "Street":      address,
            "Region":     "SASKATCHEWAN",
            "type":         "HOUSE"]
        return newDictionary as! Dictionary<String, String>
    }
    
    public func genericToDictionary(addressDictionary:Dictionary<String, String>) -> Address
    {
        var newAddress = Address()
        newAddress.city = addressDictionary["city"]!
        newAddress.postalCode = addressDictionary["postalCode"]!
        newAddress.address = addressDictionary["address"]!
        newAddress.province = addressDictionary["province"]!
        newAddress.type = addressDictionary["type"]!
        newAddress.firstName = addressDictionary["firstName"]!
        newAddress.lastName = addressDictionary["lastName"]!
        newAddress.email = addressDictionary["email"]!
        newAddress.phone = addressDictionary["phone"]!
        return newAddress
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
