//
//  AddressView.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-03.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation

class AddressView: UIView {
    @IBOutlet var addressField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var paymentField: UITextField!
    @IBOutlet var otherField: UITextField!

    override init(frame ourRect: CGRect) {
        super.init(frame: ourRect)
    }
    override func awakeFromNib() {
        addressField.attributedPlaceholder = NSAttributedString(string:"Address",
            attributes:[NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)])
        phoneField.attributedPlaceholder = NSAttributedString(string:"Phone",
            attributes:[NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)])
        paymentField.attributedPlaceholder = NSAttributedString(string:"Payment",
            attributes:[NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)])
        otherField.attributedPlaceholder = NSAttributedString(string:"Other",
            attributes:[NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)])
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateWithAddress(address: Address) {
        addressField.text = address.address
        phoneField.text = address.province
        paymentField.text = address.postalCode
        otherField.text = address.city
    }
}