//
//  OrderViewController.swift
//  WearPizzaIOS
//
//  Created by Landon Rohatensky on 2015-08-05.
//  Copyright (c) 2015 Kale Baiton. All rights reserved.
//

import UIKit
import CoreLocation

class OrderViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var toppingTable: UITableView!
    @IBOutlet var addPizzaButton: UIButton!
    @IBOutlet var pizzaCountLabel: UILabel!
    @IBOutlet var sizeSelector: UISegmentedControl!
    var priceCheckViewController: PriceCheckViewController!
    var toppingList: Array<Topping>!
    var pizzas: Array<Pizza>!
    var address: Address!
    var store: Store!
    
    override func viewDidLoad() {
        self.toppingTable.reloadData()
        if self.pizzas == nil {
            self.pizzas = []
        }
        self.pizzaCountLabel.text = String(self.pizzas.count) + " Pizzas"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PriceCheck" {
            self.priceCheckViewController = segue.destinationViewController as! PriceCheckViewController
            self.priceCheckViewController.orderViewController = self
            self.priceCheckViewController.pizzas = self.pizzas
            self.priceCheckViewController.store = self.store
            self.priceCheckViewController.address = self.address
            self.priceCheckViewController.toppingList = self.toppingList
            //self.orderViewController = segue.destinationViewController as! OrderViewController
            //self.orderViewController.toppingList = self.toppingList
        }
    }
}

// IBActions
extension OrderViewController {
    @IBAction func addPizzaButtonPressed(sender: AnyObject) {
        var selectedToppingIndex = self.toppingTable.indexPathsForSelectedRows()
        var selectedPizzaSize = (self.sizeSelector.selectedSegmentIndex * 2) + 10
        var selectedToppings:[Topping] = []
        if selectedToppingIndex != nil {
            for index in selectedToppingIndex! {
                var indexPath = index as! NSIndexPath
                selectedToppings.append(toppingList[indexPath.row])
            }
        }
        var newPizza:Pizza = Pizza()
        newPizza.initWithToppingsAndSize(selectedToppings, newSize: String(selectedPizzaSize))
        self.pizzas.append(newPizza)
        self.pizzaCountLabel.text = String(self.pizzas.count) + " Pizzas"
        deselectAll()
    }
}

// MARK: TABLE VIEW STUFF
extension OrderViewController {
    
    func deselectAll() {
        var selectedToppingIndex = self.toppingTable.indexPathsForSelectedRows()
        if selectedToppingIndex != nil {
            for indexPath in selectedToppingIndex as! Array<NSIndexPath> {
                self.toppingTable.deselectRowAtIndexPath(indexPath, animated: false)
                self.toppingTable.reloadData()
            }
        }
    }
    
    func checkIfSelected(index: NSIndexPath) -> Bool {
        var selectedToppingIndex = self.toppingTable.indexPathsForSelectedRows()
        if selectedToppingIndex != nil {
            for indexPath in selectedToppingIndex as! Array<NSIndexPath> {
                if index == indexPath {
                    return true
                }
            }
        }
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.toppingList != nil) {
            return self.toppingList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var toppingCell:ToppingCell = self.toppingTable.dequeueReusableCellWithIdentifier("ToppingCell", forIndexPath: indexPath) as! ToppingCell
        if (checkIfSelected(indexPath)) {
            toppingCell.contentView.backgroundColor = UIColor.whiteColor()
            toppingCell.toppingLabel.textColor = UIColor(red: 0.678, green: 0, blue: 0, alpha: 1.0)
        } else {
            toppingCell.contentView.backgroundColor = UIColor(red: 0.678, green: 0, blue: 0, alpha: 1.0)
            toppingCell.toppingLabel.textColor = UIColor.whiteColor()
        }
        toppingCell.setTopping(self.toppingList[indexPath.row])
        return toppingCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:ToppingCell = tableView.cellForRowAtIndexPath(indexPath) as! ToppingCell
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        selectedCell.toppingLabel.textColor = UIColor(red: 0.678, green: 0, blue: 0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:ToppingCell = tableView.cellForRowAtIndexPath(indexPath) as! ToppingCell
        selectedCell.contentView.backgroundColor = UIColor(red: 0.678, green: 0, blue: 0, alpha: 1.0)
        selectedCell.toppingLabel.textColor = UIColor.whiteColor()
    }
}

//MARK: TOPPING CELL
class ToppingCell: UITableViewCell, UITableViewDelegate {
    @IBOutlet var toppingLabel: UILabel!

    func setTopping(topping: Topping) {
        self.toppingLabel.text = topping.name
    }
}