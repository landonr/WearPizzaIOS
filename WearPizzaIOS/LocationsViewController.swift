//
//  LocationsViewController
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-15.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var locationButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var addressScrollView: UIScrollView!
    @IBOutlet var addressScrollViewFrame: UIView!
    var addLocationView: AddLocationView!
    var locationViewShowing: Bool!
    var addressList: Array<Address>!
    var addressViewList: Array<AddressView>!
    
    var storeList: Array<Store>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.addressScrollViewFrame.layoutIfNeeded()
        
        var locationNib = UINib(nibName: "AddLocationView", bundle: nil).instantiateWithOwner(self, options: nil)
        self.addLocationView = locationNib[0] as! AddLocationView
        self.addLocationView.delegate = self
        self.addLocationView.fetchNewLocations()
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
            addLocationView.layoutIfNeeded()
            UIView.animateWithDuration(0.75,
                delay: NSTimeInterval(0),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .CurveEaseInOut,
                animations: {
                    self.addLocationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                },
                completion: {success in
                    //self.addLocationView.loadLocations()
            })
        }
        //self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func updateAddress(addresses: Array<Address>) {
        self.addressList = addresses;
        self.addressViewList[0].updateWithAddress(addresses[0])
    }
    
    func updateStores(stores: Array<Store>) {
        self.storeList = stores
        self.navigationBar.topItem?.title = stores[0].addressDescription
    }
}

