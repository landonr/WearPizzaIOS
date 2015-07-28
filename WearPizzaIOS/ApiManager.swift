import Foundation
import UIKit

var pza = ApiManager()

class ApiManager {
    
    let pza : String = "http://pizzaplanet.herokuapp.com"
    //let pza : String = "http://localhost:5000"

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
    
    func findStores(address: Dictionary<String, String>, callback : ()->Void) {
        var url = pza + "/findStore"
        url = queryDictionary(url, queryDictionary: address)
        let request = api.createGetRequest(NSURL(string: url)!)
        println(request)
        //queryDictionary(url, queryDictionary: address)
        
        api.makeRequestDictionary(request, callback:  { (result : Dictionary<String, AnyObject>) -> Void in
            println(result)
            callback()
        })
    }
}