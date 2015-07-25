//
//  LocationsViewController
//  WearPizzaIOS
//
//  Created by Kale Baiton on 2015-07-15.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation
let locationManger:CLLocationManager = CLLocationManager()

class LocationsViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var locationButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    var addLocationView: AddLocationView!
    var locationViewShowing: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationViewShowing = false
        self.locationButton.image = self.locationButton.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        if(self.locationViewShowing == true) {
            self.addLocationView.removeFromSuperview()
            self.locationViewShowing = false
        } else {
            self.locationViewShowing = true
            var nib = UINib(nibName: "AddLocationView", bundle: nil).instantiateWithOwner(self, options: nil)
            
            self.addLocationView = nib[0] as! AddLocationView
            self.addLocationView.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(addLocationView)
            self.view.bringSubviewToFront(self.navigationBar)
            addLocationView.layoutIfNeeded()
            UIView.animateWithDuration(2.5,
                delay: NSTimeInterval(0),
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0,
                options: .CurveEaseInOut,
                animations: {
                    self.addLocationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                },
                completion: {success in
                    self.addLocationView.loadLocations()
            })
        }
        //self.presentViewController(vc, animated: true, completion: nil)
    }
}

