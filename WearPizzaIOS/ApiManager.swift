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
            
            callback(storeArray)
        })
    }
    
    func findMenu(storeID: String, callback : ([Store])->Void) {
        var url = pza + "store/"
        url += storeID as String
        url += "/menu?lang=en&structured=true"
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
            
            callback(storeArray)
        })
    }
}