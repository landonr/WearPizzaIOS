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
    var toppingList: Array<Topping>!
    var pizzas: Array<Pizza>!
    override func viewDidLoad() {
        self.toppingTable.reloadData()
        self.pizzas = []
    }
}

// IBActions
extension OrderViewController {
    @IBAction func addPizzaButtonPressed(sender: AnyObject) {
        var selectedToppingIndex = self.toppingTable.indexPathsForSelectedRows()
        var selectedPizzaSize = (self.sizeSelector.selectedSegmentIndex * 2) + 10
        var selectedToppings:[Topping] = []
        for index in selectedToppingIndex! {
            var indexPath = index as! NSIndexPath
            selectedToppings.append(toppingList[indexPath.row])
        }
        var newPizza:Pizza = Pizza()
        newPizza.initWithToppingsAndSize(selectedToppings, newSize: String(selectedPizzaSize))
        self.pizzas.append(newPizza)
        self.pizzaCountLabel.text = String(self.pizzas.count) + " Pizzas"
    }
}

// MARK: TABLE VIEW STUFF
extension OrderViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.toppingList != nil) {
            return self.toppingList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var toppingCell:ToppingCell = self.toppingTable.dequeueReusableCellWithIdentifier("ToppingCell", forIndexPath: indexPath) as! ToppingCell
        toppingCell.setTopping(self.toppingList[indexPath.row])
        return toppingCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:ToppingCell = tableView.cellForRowAtIndexPath(indexPath) as! ToppingCell
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        selectedCell.toppingLabel.textColor = UIColor.redColor()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:ToppingCell = tableView.cellForRowAtIndexPath(indexPath) as! ToppingCell
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