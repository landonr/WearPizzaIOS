//
//  LoadAddressViewController.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-08.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LoadAddressViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var provinceField: UITextField!
    @IBOutlet var postalCodeField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var locationTopConstraint: NSLayoutConstraint!
    @IBOutlet var continueButton: UIButton!
    var userAddress: Address!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.continueButton.alpha = 0.2
        self.continueButton.userInteractionEnabled = false
        
        self.locationTopConstraint.constant = -1000
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let address: AnyObject = userDefaults.valueForKey("address") {
            self.performSegueWithIdentifier("LoadApp", sender: nil)
        } else {
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            
            let authstate = CLLocationManager.authorizationStatus()
            if(authstate == CLAuthorizationStatus.NotDetermined){
                locationManger.requestWhenInUseAuthorization()
            }
        }
    }
    
    func checkIfContinue()
    {
        if  count(self.firstNameField.text) > 0 &&
            count(self.lastNameField.text) > 0 &&
            count(self.addressField.text) > 0 &&
            count(self.cityField.text) > 0 &&
            count(self.provinceField.text) > 0 &&
            count(self.postalCodeField.text) > 0 &&
            count(self.phoneField.text) > 0 &&
            count(self.emailField.text) > 0 {
                var newAddress: Address = Address()
                newAddress.firstName = self.firstNameField.text
                newAddress.lastName = self.lastNameField.text
                newAddress.address = self.addressField.text
                newAddress.city = self.cityField.text
                newAddress.province = self.provinceField.text
                newAddress.postalCode = self.postalCodeField.text
                newAddress.phone = self.phoneField.text
                newAddress.email = self.emailField.text
                self.continueButton.alpha = 1.0
                self.continueButton.userInteractionEnabled = true
                self.userAddress = newAddress
        }
    }
    
    @IBAction func didTapContinue() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(self.userAddress.toDictionary(), forKey: "address")
        userDefaults.synchronize()
        self.performSegueWithIdentifier("LoadApp", sender: nil)
    }
    
    func showRoughAddress(currentPlace: Address)
    {
        self.addressField.text = currentPlace.address
        self.cityField.text = currentPlace.city
        self.provinceField.text = currentPlace.province
        self.postalCodeField.text = currentPlace.postalCode
        
        self.locationTopConstraint.constant = -30
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(1.0,
            delay: NSTimeInterval(0),
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: {success in
        })
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManger.startUpdatingLocation()
        } else {
            self.showRoughAddress(Address())
        }
    }
    
    //called when gps gets new location
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        locationManger.stopUpdatingLocation()
        
        //reverse searches geocode to rough address
        var gc = CLGeocoder()
        gc.reverseGeocodeLocation(newLocation, completionHandler: { (address, error) -> Void in
            let newAddress = address as? [CLPlacemark]
            if(newAddress!.count > 0) {
                var currentPlace: Address = Address()
                currentPlace.initWithCLPlacemark(newAddress![0])
                self.showRoughAddress(currentPlace)
            }
        })
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.checkIfContinue()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.firstNameField {
            self.lastNameField.becomeFirstResponder()
        } else if textField == self.lastNameField {
            self.addressField.becomeFirstResponder()
        } else if textField == self.addressField {
            self.cityField.becomeFirstResponder()
        } else if textField == self.cityField {
            self.provinceField.becomeFirstResponder()
        } else if textField == self.provinceField {
            self.postalCodeField.becomeFirstResponder()
        } else if textField == self.postalCodeField {
            self.phoneField.becomeFirstResponder()
        } else if textField == self.phoneField {
            self.emailField.becomeFirstResponder()
        } else if textField == self.emailField {
            self.emailField.resignFirstResponder()
            self.locationTopConstraint.constant = -30
        }
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.5,
            delay: NSTimeInterval(0),
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: {success in
        })
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.firstNameField {
            self.locationTopConstraint.constant = -30
        } else if textField == self.lastNameField {
            self.locationTopConstraint.constant = -30
        } else if textField == self.addressField {
            self.locationTopConstraint.constant = -30
        } else if textField == self.cityField {
            self.locationTopConstraint.constant = -30
        } else if textField == self.provinceField {
            self.locationTopConstraint.constant = -30
        } else if textField == self.postalCodeField {
            self.locationTopConstraint.constant = 40
        } else if textField == self.phoneField {
            self.locationTopConstraint.constant = 110
        } else if textField == self.emailField {
            self.locationTopConstraint.constant = 200
        }
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.5,
            delay: NSTimeInterval(0),
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: {success in
        })
    }
}