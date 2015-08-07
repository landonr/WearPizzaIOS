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
    var payments = [    "Amount": "",
                        "CardType": "",
                        "Expiration": "",
                        "Number": "",
                        "PostalCode": "",
                        "SecurityCode": "",
                        "Type": "DoorDebit"]
    
    func initWithAddressAndPizzaAndStore(userAddress: Address, pizzas: [Pizza], store: Store) -> Dictionary<String, AnyObject>
    {
        var address = userAddress.toRequestDictionary ()
        
        var pizzaList:Array<AnyObject> = []
        for pizza in pizzas
        {
            var pizzaCode = String(pizza.size) + "SCREEN"
            
            var pizzaToppings:Dictionary<String, Dictionary<String, String>> = ["C": ["1/1": "1"]]
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
}