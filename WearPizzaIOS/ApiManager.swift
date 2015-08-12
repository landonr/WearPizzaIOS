import Foundation
import UIKit
import SwiftyJSON

var pza = ApiManager()

class ApiManager {
    
    let pza : String = "https://order.dominos.ca/power/"

    func queryDictionary(url: String, queryDictionary: Dictionary<String, String>) -> String
    {
        var components = NSURLComponents(string: url)
        var queryItems = NSMutableArray();
        for (key, value) in queryDictionary {
            queryItems.addObject(NSURLQueryItem(name: key, value: value))
        }
        components?.queryItems = queryItems as [AnyObject]
        return components!.string!
    }
    
    func findStores(request: String, callback : ([Store])->Void) {
        var url = pza + "store-locator?"
        url += request as String
        let request = api.createGetRequest(NSURL(string: url)!)
        println(request)
        //queryDictionary(url, queryDictionary: address)
        
        api.makeRequestDictionary(request, callback:  { (result : Dictionary<String, AnyObject>) -> Void in
            var json = JSON(result)
            var storeJson : JSON = json["Stores"]
            var storeArray : [Store] = [Store]()
            for (key: String, subJson: JSON) in storeJson {
                var newStore : Store = Store()
                newStore.initWithJSON(subJson)
                storeArray.append(newStore)
            }
            let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
            userDefaults.setValue(Store().arrayToGeneric(storeArray), forKey: "storeArray")
            userDefaults.synchronize()
            callback(storeArray)
        })
    }
    
    func findMenu(storeID: String, callback : ([Topping])->Void) {
        var url = pza + "store/"
        url += storeID as String
        url += "/menu?lang=en&structured=true"
        let request = api.createGetRequest(NSURL(string: url)!)
        println(request)
        //queryDictionary(url, queryDictionary: address)
        
        api.makeRequestDictionary(request, callback:  { (result : Dictionary<String, AnyObject>) -> Void in
            var json = JSON(result)
            var toppingJson : JSON = json["Toppings"]["Pizza"]
            var toppingArray : [Topping] = [Topping]()
            for (key: String, subJson: JSON) in toppingJson {
                var newTopping : Topping = Topping()
                newTopping.initWithJSON(subJson)
                if newTopping.code != "X" && newTopping.code != "C" {
                    toppingArray.append(newTopping)
                }
            }
            let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
            userDefaults.setValue(Topping().arrayToGeneric(toppingArray), forKey: "toppingArray")
            userDefaults.synchronize()
            callback(toppingArray)
        })
    }
    
    func priceOrder(store: Store, address: Address, pizzas: [Pizza], callback : (String)->Void) {
        var order = Order().initWithAddressAndPizzaAndStore(address, pizzas: pizzas, store:store)
        var asData = NSJSONSerialization.dataWithJSONObject(order, options:NSJSONWritingOptions(0), error: nil)
        var jsonString = NSString(data: asData!, encoding: NSUTF8StringEncoding)
        var fixedString = jsonString!.stringByReplacingOccurrencesOfString("\\", withString: "")
        println(fixedString)
        
        
        var url = pza + "price-order"
        let request = api.createPostRequest(NSURL(string: url)!, data: order)
        //println(request)
        //queryDictionary(url, queryDictionary: address)
        
        api.makeRequestDictionary(request, callback:  { (result : Dictionary<String, AnyObject>) -> Void in
            var json = JSON(result)
            var amount = "0"
            if json["Order"]["AmountsBreakdown"]["Customer"] != nil {
                amount = json["Order"]["AmountsBreakdown"]["Customer"].stringValue
            }
            callback(amount)
        })
    }
    
    func postOrder(store: Store, address: Address, pizzas: [Pizza], amount: String, callback : (Bool)->Void) {
        var order = Order().initWithAddressAndPizzaAndStoreAndPrice(address, pizzas: pizzas, store:store, price:amount)
        var asData = NSJSONSerialization.dataWithJSONObject(order, options:NSJSONWritingOptions(0), error: nil)
        var jsonString = NSString(data: asData!, encoding: NSUTF8StringEncoding)
        var fixedString = jsonString!.stringByReplacingOccurrencesOfString("\\", withString: "")
        println(fixedString)
        
        
        var url = pza + "place-order"
        let request = api.createPostRequest(NSURL(string: url)!, data: order)
        //println(request)
        //queryDictionary(url, queryDictionary: address)
        println(request)
        
        api.makeRequestDictionary(request, callback:  { (result : Dictionary<String, AnyObject>) -> Void in
            var json = JSON(result)
            var status = json["Status"]
            if(status == "1"){
                callback(true)
            } else {
                callback(false)
            }
        })
        
    }
}