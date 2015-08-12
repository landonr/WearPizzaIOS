//
//  PriceCheckViewController.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-10.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation

class PriceCheckViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var pizzaTable: UITableView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    var pizzas: Array<Pizza>!
    var address: Address!
    var store: Store!
    var amount: String!
    var orderViewController: OrderViewController!
    var toppingList: Array<Topping>!
    var returnColor: UIColor!
    override func viewDidLoad() {
        self.pizzaTable.reloadData()
        self.returnColor = self.priceLabel.textColor
        self.amount = "?"
        if self.pizzas == nil {
            self.pizzas = []
        } else {
            pza.priceOrder(self.store, address: self.address, pizzas: self.pizzas) { (amount: String) -> Void in
                self.priceLabel.text = "Save\n$" + amount
                self.amount = amount
            }
        }
        self.addressLabel.text = self.address.toString()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReturnToOrder" {
            self.orderViewController = segue.destinationViewController as! OrderViewController
            self.orderViewController.toppingList = self.toppingList
            self.orderViewController.address = self.address
            self.orderViewController.store = self.store
            self.orderViewController.pizzas = self.pizzas
        }
    }
}

// IBActions
extension PriceCheckViewController {
    @IBAction func orderPressed() {
        if(self.amount != "" && self.pizzas.count > 0)
        {
            pza.postOrder(self.store, address: self.address, pizzas: self.pizzas, amount:self.amount, callback: { (stuff: Bool) -> Void in
        
            })
        }
    }
    
    @IBAction func savePressedPressed() {
        if(self.pizzas.count > 0) {
            Order().savePizzasAndPrice(self.pizzas, price: self.amount)
        }
        self.priceLabel.alpha = 0
        
        UIView.animateWithDuration(1.25,
            delay: NSTimeInterval(0),
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.priceLabel.alpha = 1
            },
            completion: {success in
                self.priceLabel.userInteractionEnabled = true
        })
    }
}

// MARK: TABLE VIEW STUFF
extension PriceCheckViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var removeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.pizzas.removeAtIndex(indexPath.row)
            self.pizzaTable.reloadData()
        })
    
        return [removeAction]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var pizzaCell:PizzaCell = self.pizzaTable.dequeueReusableCellWithIdentifier("PizzaCell", forIndexPath: indexPath) as! PizzaCell
        
        let pizza:Pizza = self.pizzas[indexPath.row]
        pizzaCell.setPizza(pizza)
        return pizzaCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//MARK: PIZZA CELL
class PizzaCell: UITableViewCell, UITableViewDelegate {
    @IBOutlet var pizzaLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!

    func setPizza(pizza: Pizza) {
        self.sizeLabel.text = pizza.size
        self.pizzaLabel.text = pizza.toppingsToString()
    }
}