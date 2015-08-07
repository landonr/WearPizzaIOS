//
//  DismisOrderCustomSegue.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-06.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit

class DismsiOrderCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        // Assign the source and destination views to local variables.
        var firstVCView = self.sourceViewController.view as UIView!
        var secondVCView = self.destinationViewController.view as UIView!

        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView.frame = CGRectMake(-screenWidth, 0.0, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        // Animate the transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, +screenWidth, 0)
            secondVCView.frame = CGRectOffset(secondVCView.frame, +screenWidth, 0)
            
            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController,
                    animated: false,
                    completion: nil)
        }
        
    }
}