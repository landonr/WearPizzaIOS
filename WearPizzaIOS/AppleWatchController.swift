//
//  AppleWatchController.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-11.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import WatchKit
import Foundation
class AppleWatchController: WKInterfaceController  {
    @IBOutlet var orderTable: WKInterfaceTable!
    var orderList: Array<Dictionary<String, AnyObject>>!
    var address: Address!
    var store: Store!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
        
        if let orderArray: AnyObject = userDefaults.valueForKey("orderArray") {
            var orders = orderArray as! Array<Dictionary<String, AnyObject>>
            self.orderList = orders
            //println(orders)
        }
        
        if let address: AnyObject = userDefaults.valueForKey("address") {
            var a = address as! Dictionary<String, String>
            var newAddress = Address().genericToDictionary(a)
            self.address = newAddress
        }
        
        if let orderArray: AnyObject = userDefaults.valueForKey("orderArray") {
            var orders = orderArray as! Array<Dictionary<String, AnyObject>>
            self.orderList = orders
        }
        if let storeArray: AnyObject = userDefaults.valueForKey("storeArray") {
            var s = storeArray as! Array<Dictionary<String, String>>
            var stores = Store().genericToArray(s)
            self.store = stores[0]
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        orderTable.setNumberOfRows(self.orderList.count, withRowType: "OrderRow")
        
        for (index, orderData) in enumerate(self.orderList) {

            if let row = orderTable.rowControllerAtIndex(index) as? OrderRow {
                let order = Order().genericToOrder(orderData)
                row.priceLabel.setText(order.price)
                var description = ""
                for var i = 0; i < order.pizzas.count; i++ {
                    var pizza = order.pizzas[i]
                    if(order.pizzas.count > 1 && i < order.pizzas.count && i > 0) {
                        description = description + ", "
                    }
                    description = description + pizza.toDisplayString()
                }
                row.detailLabel.setText(description)
            }
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func update() {
        
    }
    
    func reloadTable() {
        // 1
        orderTable.setNumberOfRows(10, withRowType: "OrderRow")
        /*
        for (index, pizza) in enumerate() {
            // 2
            if let row = coinTable.rowControllerAtIndex(index) as? CoinRow {
                // 3
                row.titleLabel.setText(coin.name)
                row.detailLabel.setText("\(coin.price)")
            }
        }
        */
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
            return ["order": self.orderList[rowIndex]]
    }
}

class PlaceOrderController: WKInterfaceController {
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    @IBOutlet weak var addressLabel: WKInterfaceLabel!

    var address: Address!
    var store: Store!
    var orderDict: Dictionary<String, AnyObject>!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var orderData = (context as! NSDictionary)["order"] as! Dictionary<String, AnyObject>
        let order = Order().genericToOrder(orderData)
        self.orderDict = orderData
        self.priceLabel.setText(order.price)

        var description = ""
        for var i = 0; i < order.pizzas.count; i++ {
            var pizza = order.pizzas[i]
            if(order.pizzas.count > 1 && i < order.pizzas.count && i > 0) {
                description = description + ", "
            }
            description = description + pizza.toDisplayString()
        }
        self.detailLabel.setText(description)
        
        let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
        if let address: AnyObject = userDefaults.valueForKey("address") {
            var a = address as! Dictionary<String, String>
            var newAddress = Address().genericToDictionary(a)
            self.address = newAddress
        }

        if let storeArray: AnyObject = userDefaults.valueForKey("storeArray") {
            var s = storeArray as! Array<Dictionary<String, String>>
            var stores = Store().genericToArray(s)
            self.store = stores[0]
        }
        
        self.addressLabel.setText(self.address.toString())
    }
    
    @IBAction func orderPressed() {
        WKInterfaceController.openParentApplication(["order": self.orderDict],
            reply: { (replyInfo, error) -> Void in
                if let status = replyInfo["Status"] as? Bool {
                    if(status == true) {
                    //success
                    } else {
                        //failure
                    }
                } else {
                    //failure
                }
                println(replyInfo)
        })
    }
}

class OrderRow: NSObject {
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
}