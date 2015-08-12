//
//  Order.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-06.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import SwiftyJSON

public class Order: NSObject {
    public var pizzas : [Pizza] = []
    public var price : String = ""
    
    var payments = [    "Amount": "",
                        "CardType": "",
                        "Expiration": "",
                        "Number": "",
                        "PostalCode": "",
                        "SecurityCode": "",
                        "Type": "DoorDebit"]
    
    func savePizzasAndPrice(pizzas: [Pizza], price: String)
    {
        //saves order
        let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
        if let orderArray: AnyObject = userDefaults.valueForKey("orderArray") {
            var orders = orderArray as! Array<Dictionary<String, AnyObject>>
            var newOrder = [    "pizzas": Pizza().arrayToGeneric(pizzas),
                                "price": price]
            orders.append(newOrder as! Dictionary<String, AnyObject>)
            //orders.append(Order().initWithAddressAndPizzaAndStore(self.address, pizzas: self.pizzas, store: self.store))
            userDefaults.setValue(orders, forKey: "orderArray")
        } else {
            var newOrder = [    "pizzas": Pizza().arrayToGeneric(pizzas),
                "price": price]
            userDefaults.setValue([newOrder as! Dictionary<String, AnyObject>], forKey: "orderArray")
        }
        userDefaults.synchronize()
    }
    
    public func genericToOrder(orderArray: Dictionary<String, AnyObject>) -> Order
    {
        self.price = orderArray["price"] as! String
        self.pizzas = Pizza().genericToArray(orderArray["pizzas"] as! Array<Dictionary<String, AnyObject>>)
        return self
    }
    
    func initWithAddressAndPizzaAndStore(userAddress: Address, pizzas: [Pizza], store: Store) -> Dictionary<String, AnyObject>
    {
        var address = userAddress.toRequestDictionary ()
        
        var pizzaList:Array<AnyObject> = []
        for pizza in pizzas
        {
            var pizzaCode = "12SCREEN"
            
            var pizzaToppings:Dictionary<String, Dictionary<String, String>> = ["C": ["1/1": "1"], "X": ["1/1": "1"]]
            var count = pizza.toppings.count
            var index = 1
            for topping in pizza.toppings {
                //        "Options": {C: {1/1: "1"}, P: {1/1: "1"}, X: {1/1: "1"}},
                pizzaToppings.updateValue(["1/1": "1"], forKey: topping.code)
            }
            
            var product = [ "Code": pizzaCode,
                "ID": 1,
                "Instructions": "",
                "Qty": 1,
                "Options": pizzaToppings,
                "isNew": false]
            pizzaList.append(product)
        }
        
        var emptyDict = Dictionary<String, String>()
        
        var order = ["Order":[   "Address": address,
                        "Coupons": [],
                        "Products": pizzaList,
                        "CustomerID":"",
                        "Email": userAddress.email,
                        "Extension":"",
                        "FirstName": userAddress.firstName,
                        "LastName": userAddress.lastName,
                        "LanguageCode":"en",
                        "OrderChannel":"OLO",
                        "OrderID":"",
                        "OrderMethod":"Web",
                        "OrderTaker":"null",
                        "Payments":[],
                        "Phone": userAddress.phone,
                        "ServiceMethod":"Delivery",
                        "SourceOrganizationURI":"order.dominos.ca",
                        "StoreID":10155,
                        "Tags":emptyDict,
                        "Version":"1.0",
                        "NoCombine":"true",
                        "Partners":emptyDict]]
        return order
    }
    
    func initWithAddressAndPizzaAndStoreAndPrice(userAddress: Address, pizzas: [Pizza], store: Store, price: String) -> Dictionary<String, AnyObject>
    {
        var address = userAddress.toRequestDictionary ()
        
        var pizzaList:Array<AnyObject> = []
        for pizza in pizzas
        {
            var pizzaCode = "12SCREEN"
            
            var pizzaToppings:Dictionary<String, Dictionary<String, String>> = ["C": ["1/1": "1"], "X": ["1/1": "1"]]
            var count = pizza.toppings.count
            var index = 1
            for topping in pizza.toppings {
                //        "Options": {C: {1/1: "1"}, P: {1/1: "1"}, X: {1/1: "1"}},
                pizzaToppings.updateValue(["1/1": "1"], forKey: topping.code)
            }
            
            var product = [ "Code": pizzaCode,
                "ID": 1,
                "Instructions": "",
                "Qty": 1,
                "Options": pizzaToppings,
                "isNew": false]
            pizzaList.append(product)
        }
        
        var emptyDict = Dictionary<String, String>()
        
        var newPayment = self.payments
        newPayment.updateValue(price, forKey: "Amount")
        
        var order = ["Order":[   "Address": address,
            "Coupons": [],
            "Products": pizzaList,
            "CustomerID":"",
            "Email": userAddress.email,
            "Extension":"",
            "FirstName": userAddress.firstName,
            "LastName": userAddress.lastName,
            "LanguageCode":"en",
            "OrderChannel":"OLO",
            "OrderID":"",
            "OrderMethod":"Web",
            "OrderTaker":"null",
            "Payments": newPayment,
            "Phone": userAddress.phone,
            "ServiceMethod":"Delivery",
            "SourceOrganizationURI":"order.dominos.ca",
            "StoreID":10155,
            "Tags":emptyDict,
            "Version":"1.0",
            "NoCombine":"true",
            "Partners":emptyDict]]
        return order
    }
}