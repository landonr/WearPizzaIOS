//
//  AppDelegate.swift
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-15.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import WatchKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
            
            if let userInfo = userInfo, orderData = userInfo["order"] as? Dictionary<String, AnyObject> {
                println(orderData)
                var address = Address()
                var store = Store()
                
                let order = Order().genericToOrder(orderData)
                
                let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
                if let addressData: AnyObject = userDefaults.valueForKey("address") {
                    var a = addressData as! Dictionary<String, String>
                    var newAddress = Address().genericToDictionary(a)
                    address = newAddress
                }
                
                if let storeArray: AnyObject = userDefaults.valueForKey("storeArray") {
                    var s = storeArray as! Array<Dictionary<String, String>>
                    var stores = Store().genericToArray(s)
                    store = stores[0]
                }
                pza.postOrder(store, address: address, pizzas: order.pizzas, amount: order.price, callback: { (response: Bool) -> Void in
                    
                    reply(["status":response])
                })
            }
            
        reply(["status":false])
    }
}

