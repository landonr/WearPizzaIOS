//
//  Store.swift
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-29.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

public class Store: NSObject {
    public var addressDescription : String = ""
    public var storeID : Int = -1
    public var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    public func initWithJSON(jsonData : JSON) -> Void
    {
        addressDescription = jsonData["AddressDescription"].stringValue
        storeID = jsonData["StoreID"].intValue
    }
    
    public func toDictionary() -> Dictionary<String, String>
    {
        var newDictionary:NSDictionary = [
            "addressDescription":         addressDescription,
            "storeID":   String(storeID)]
        return newDictionary as! Dictionary<String, String>
    }
    
    public func arrayToGeneric(storeArray: Array<Store>) -> Array<Dictionary<String, String>>
    {
        var newArray:Array<Dictionary<String, String>> = []
        for store in storeArray {
            var newDictionary:Dictionary = store.toDictionary()
            newArray.append(newDictionary)
        }
        
        return newArray
    }
    
    public func genericToArray(storeArray: Array<Dictionary<String, String>>) -> Array<Store>
    {
        var newArray: Array<Store> = []
        for store in storeArray {
            var newStore = Store()
            newStore.addressDescription = store["addressDescription"]!
            newStore.storeID = store["storeID"]!.toInt()!
            newArray.append(newStore)
        }
        
        return newArray
    }
}