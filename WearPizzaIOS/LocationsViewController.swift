//
//  LocationsViewController
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-15.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, UITableViewDelegate {
    @IBOutlet var locationButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var addressScrollView: UIScrollView!
    @IBOutlet var addressScrollViewFrame: UIView!
    @IBOutlet var newOrderView: UIView!
    @IBOutlet var newOrderLabelVerticalOffset: NSLayoutConstraint!
    @IBOutlet var orderTable: UITableView!
    var addLocationView: AddLocationView!
    var locationViewShowing: Bool!
    var addressList: Array<Address>!
    var addressViewList: Array<AddressView>!
    var toppingList: Array<Topping>!
    var orderList: Array<Dictionary<String, AnyObject>>!
    var storeList: Array<Store>!
    var orderViewController: OrderViewController!
    var pebbleController : PebbleController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userDefaults = NSUserDefaults(suiteName: "group.wearpizza")!
        if let storeArray: AnyObject = userDefaults.valueForKey("storeArray") {
            var s = storeArray as! Array<Dictionary<String, String>>
            var stores = Store().genericToArray(s)
            self.updateStores(stores)
        }
        
        if let toppingArray: AnyObject = userDefaults.valueForKey("toppingArray") {
            var t = toppingArray as! Array<Dictionary<String, String>>
            var toppings = Topping().genericToArray(t)
            self.toppingList = toppings
        }
        
        if let orderArray: AnyObject = userDefaults.valueForKey("orderArray") {
            var orders = orderArray as! Array<Dictionary<String, AnyObject>>
            self.orderList = orders
        }
        
        
        locationManger.delegate = self
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.NotDetermined){
            locationManger.requestWhenInUseAuthorization()
        }
        
        self.locationViewShowing = false
        self.addressViewList = []
        
        self.locationButton.image = self.locationButton.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.addressScrollView.contentSize = self.addressScrollViewFrame.frame.size
        var addressNib = UINib(nibName: "AddressView", bundle: nil).instantiateWithOwner(self, options: nil)
        
        var addressView = addressNib[0] as! AddressView
        addressView.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        addressView.frame.origin = CGPoint(x:(self.view.frame.width)/2,y:15)
        addressView.layoutIfNeeded()
        
        self.addressScrollView.addSubview(addressView)
        self.addressViewList.append(addressView)
        if let address: AnyObject = userDefaults.valueForKey("address") {
            var a = address as! Dictionary<String, String>
            var newAddress = Address().genericToDictionary(a)
            self.updateAddress([newAddress])
        }
        self.addressScrollViewFrame.layoutIfNeeded()
        
        var locationNib = UINib(nibName: "AddLocationView", bundle: nil).instantiateWithOwner(self, options: nil)
        self.addLocationView = locationNib[0] as! AddLocationView
        self.addLocationView.delegate = self
        if(self.storeList != nil) {
            self.addLocationView.localStores = self.storeList
            self.addLocationView.tableView.reloadData()
        } else {
            self.addLocationView.loadStoresWithAddress(self.addressList[0])
        }
        self.addLocationView.fetchNewLocations()
        self.view.bringSubviewToFront(self.navigationBar)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.addLocationView.fetchNewLocations()
        } else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        if(self.locationViewShowing == true) {
            UIView.animateWithDuration(0.75,
                delay: NSTimeInterval(0),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .CurveEaseInOut,
                animations: {
                    self.addLocationView.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
                },
                completion: {success in
                    self.addLocationView.removeFromSuperview()
                    self.locationViewShowing = false
            })
        } else {
            self.locationViewShowing = true
            
            self.addLocationView.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(addLocationView)
            self.view.bringSubviewToFront(self.navigationBar)
            self.addLocationView.layoutIfNeeded()
            self.addLocationView.findStores()
            UIView.animateWithDuration(0.75,
                delay: NSTimeInterval(0),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .CurveEaseInOut,
                animations: {
                    self.addLocationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                },
                completion: {success in
            })
        }
        //self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func newOrderButtonPressed(sender: AnyObject) {

    }
    
    @IBAction func syncToPebbleButtonPressed(sender: AnyObject) {
        self.pebbleController = PebbleController();
        self.pebbleController.syncDataToPebble();
    }
    
    func updateAddress(addresses: Array<Address>) {
        self.addressList = addresses;
        self.addressViewList[0].updateWithAddress(addresses[0])
    }
    
    func updateStores(stores: Array<Store>) {
        self.storeList = stores
        self.navigationBar.topItem?.title = stores[0].addressDescription
    }
    
    func getMenu(store: Store)
    {
        pza.findMenu(String(store.storeID), callback: { (toppings) -> Void in
            self.toppingList = toppings
            if(self.orderViewController != nil){
                self.orderViewController.toppingList = self.toppingList
                self.orderViewController.toppingTable.reloadData()
            }
            println("g2g")
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewOrder" {
            self.orderViewController = segue.destinationViewController as! OrderViewController
            self.orderViewController.toppingList = self.toppingList
            self.orderViewController.address = self.addressList[0]
            self.orderViewController.store = self.storeList[0]
        }
    }
}

// MARK: TABLE VIEW STUFF
extension LocationsViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.orderList != nil) {
            return self.orderList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var orderCell:OrderCell = self.orderTable.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
        
        let orderData:Dictionary<String, AnyObject> = self.orderList[indexPath.row]
        let order = Order().genericToOrder(orderData)
        orderCell.setOrder(order)
        return orderCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
}

//MARK: ODER CELL
class OrderCell: UITableViewCell, UITableViewDelegate {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    func setOrder(order: Order) {
        self.descriptionLabel.text = ""
        for var i = 0; i < order.pizzas.count; i++ {
            var pizza = order.pizzas[i]
            if(order.pizzas.count > 1 && i < order.pizzas.count && i > 0) {
                self.descriptionLabel.text = self.descriptionLabel.text! + ", "
            }
            self.descriptionLabel.text = self.descriptionLabel.text! + pizza.toDisplayString()
        }
        self.priceLabel.text = order.price
    }
}