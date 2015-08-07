//
//  FirstViewController.swift
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-15.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
let locationManger:CLLocationManager = CLLocationManager()

class AddLocationView: UIView, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    var localStores: [Store]
    var delegate: LocationsViewController!
    var fetchNewLocation: Bool

    override init(frame ourRect: CGRect)
    {
        self.localStores = []
        self.fetchNewLocation = false
        super.init(frame: ourRect)
    }
    
    override func awakeFromNib() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.localStores = []
        self.fetchNewLocation = false
        super.init(coder: aDecoder)
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        if(self.localStores.count > 0)
        {
            self.tableView.reloadData()
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    func loadLocations() {
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.findStores()
    }
}

// MARK: TABLE VIEW STUFF
extension AddLocationView {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localStores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nib = UINib(nibName: "StoreCell", bundle: nil).instantiateWithOwner(self, options: nil)
        var storeCell = nib[0] as! StoreCell
        var store = self.localStores[indexPath.row]
        storeCell.setStore(store)
        return storeCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var location = self.localStores[indexPath.row].coordinate
        var mapPoint = MKMapPointForCoordinate(location)
        var mapBox = MKMapRectMake(mapPoint.x, mapPoint.y, 10000, 10000)
        self.mapView.setVisibleMapRect(mapBox, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
}

// MARK: LOCATION MANAGER STUFF
extension AddLocationView {
    @IBAction func refreshLocations() {
        self.fetchNewLocation = true
        self.fetchNewLocations()
    }
    func fetchNewLocations() {
        if(self.delegate.storeList == nil) {
            self.fetchNewLocation = true
        }
        locationManger.delegate = self
        locationManger.startUpdatingLocation()
    }
    
    //reverse searches stores into gps coords
    func findCoordinates(stores: [Store], callback : ([Store])->Void) {
        var counter = stores.count
        var newStores = [Store]()
        for store in stores {
            var gc = CLGeocoder()
            gc.geocodeAddressString(store.addressDescription, completionHandler: {
                (location, error) -> Void in
                var newLocation = (location[0] as! CLPlacemark).location.coordinate
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = newLocation
                dropPin.title = store.addressDescription
                self.mapView.addAnnotation(dropPin)
                
                store.coordinate = newLocation
                
                newStores.append(store)
                counter--
                if counter == 0 {
                    callback(newStores)
                }
            })
        }
    }
    
    //called when gps gets new location
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 4000, 4000)
        
        mapView.setRegion(region, animated: true)
        
        locationManger.stopUpdatingLocation()
        
        //reverse searches geocode to rough address
        var gc = CLGeocoder()
        gc.reverseGeocodeLocation(newLocation, completionHandler: { (address, error) -> Void in
            let newAddress = address as? [CLPlacemark]
            if(newAddress!.count > 0) {
                var currentPlace: Address = Address()
                currentPlace.initWithCLPlacemark(newAddress![0])
                
                //checks for local stores
                if(self.fetchNewLocation) {
                    self.fetchNewLocation = false
                    self.delegate.updateAddress([currentPlace])
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(currentPlace.toDictionary(), forKey: "address")
                    userDefaults.synchronize()
                    
                    pza.findStores(currentPlace.toRequest(), callback: {(stores : [Store])->Void in
                        self.findCoordinates(stores, callback: { (stores) -> Void in
                            self.localStores = stores
                            self.delegate.updateStores(stores)
                        })
                    })
                }
            }
        })
    }
    
    func findStores()
    {
        self.tableView.reloadData()
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}

//MARK: STORE CELL
class StoreCell: UITableViewCell {
    @IBOutlet var addressLabel: UILabel!
    
    func setStore(store: Store) {
        self.addressLabel.text = store.addressDescription
    }
}