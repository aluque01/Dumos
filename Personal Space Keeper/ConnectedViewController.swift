//
//  ConnectedViewController.swift
//  Personal Space Keeper
//
//  Created by Ariel Luque on 3/6/16.
//  Copyright © 2016 Ariel Luque. All rights reserved.
//

import UIKit
import AudioToolbox

class ConnectedViewController: UIViewController, PTDBeanDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    // Hard coded databse for now
    
    class saleItem{
        
        var itemID : String
        var name : String
        var price : Double
        var image : UIImage
        
        init(itemID: String, name: String, price: Double, image: UIImage){
            self.itemID = itemID
            self.name = name
            self.price = price
            self.image = image
        }
    }
    
    
    let hover : saleItem = saleItem(itemID: "hover", name: "Lexus Hover Board", price: 15000.00, image: UIImage(named: "hover.png")!)
    
    let blueZone : saleItem = saleItem(itemID: "bluzone", name: "Helen's Bluezone", price: 15.00, image: UIImage(named: "drunk.jpg")!)
    
    let oculus : saleItem = saleItem(itemID: "oculuus", name: "Oculus Rift", price: 599.00, image: UIImage(named: "oculus.png")!)
    
    let drone : saleItem = saleItem(itemID: "drone", name: "DJI Phantom 3 4K", price: 999.00, image: UIImage(named: "phantom.png")!)
    
    var availableItems: NSMutableDictionary = NSMutableDictionary()
    
    // End database
    
    
    var connectedBean: PTDBean?
    var manager: PTDBeanManager!
    var curLimit = 0.5
    var curTotal = 0.00
    
    var curItems : NSMutableArray = NSMutableArray()
    var dupItems : NSMutableDictionary = NSMutableDictionary()
    
    
    @IBOutlet weak var itemsTableView : UITableView!
    @IBOutlet weak var BeanNameLabel: UILabel!
    @IBOutlet weak var totalLabel : UILabel!
    @IBOutlet weak var checkOutButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsTableView.delegate = self;
        itemsTableView.dataSource = self;
        
        //remove selection hightlighting
        itemsTableView.allowsSelection = false
        
        
        // Dictionary items to be removed later 
        availableItems.setObject(hover, forKey: "hover")
        availableItems.setObject(blueZone, forKey: "bluzone")
        availableItems.setObject(oculus, forKey: "oculuus")
        availableItems.setObject(drone, forKey: "drone")
        
        //Add button functions
        checkOutButton.addTarget(self, action: #selector(ConnectedViewController.checkoutButtonTapped(_:)), forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: #selector(ConnectedViewController.cancelButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        connectedBean?.readTemperature()
    }
    
    // MARK: Actions
    
    func updateAcc(){
        connectedBean?.readTemperature()
        connectedBean?.readAccelerationAxes()
    }
    
    // MARK: PTDBeanDelegate
    
    func bean(bean: PTDBean!, serialDataReceived data:NSData) {
        let theString:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        
        print(theString)
        
        if ((dupItems.objectForKey(theString)) != nil){
            
            let itemCount : Int = dupItems.objectForKey(theString) as! Int + 1
            
            // Increase the item count
            dupItems.setValue(itemCount, forKey: theString as String)
            
            print (itemCount)
            
            itemsTableView.reloadRowsAtIndexPaths(itemsTableView.indexPathsForVisibleRows!, withRowAnimation: .None)
            
            // Now increase price
            let currItem : saleItem = availableItems.objectForKey(theString) as! saleItem
            
            curTotal += currItem.price
            
            totalLabel.text = "Total: $" + String(format:"%.02f", curTotal)
            
            
        } else {
            
            dupItems.setValue(1, forKey: theString as String);

            self.curItems.addObject(theString)
            
            // Update Table Data
            self.itemsTableView.beginUpdates()
            self.itemsTableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow: self.curItems.count-1, inSection: 0)
                ], withRowAnimation: .Automatic)
            self.itemsTableView.endUpdates()
            
            // Now set price
            
            let currItem : saleItem = availableItems.objectForKey(theString) as! saleItem
            
            curTotal += currItem.price
            
            totalLabel.text = "Total: $" + String(format:"%.02f", curTotal)
            
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //MARK : table functions
    func numberOfRowsInTableView(aTableView: UITableView) -> Int
    {
        return curItems.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("Num rows in section: %i", curItems.count)
        return curItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "itemCell", forIndexPath: indexPath) as! DumosItemTableViewCell
        
        let itemID : String = curItems.objectAtIndex(indexPath.row) as! String
        
        let currItem : saleItem = availableItems.objectForKey(itemID) as! saleItem
        
        cell.nameLabel.text = currItem.name
        cell.countLabel.text = String(dupItems.objectForKey(itemID) as! Int)
        cell.priceLabel.text = "$" + String(format:"%.02f", currItem.price)
        cell.itemImage.image = currItem.image
        cell.itemID = currItem.itemID
        
        // FIx image view for cells 
        
        //cell.itemImage.contentMode = UIViewContentMode.ScaleAspectFill
        //cell.itemImage.clipsToBounds = true
        
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(ConnectedViewController.addButtontapped(_:)), forControlEvents: .TouchUpInside)
        
        cell.subButton.tag = indexPath.row
        cell.subButton.addTarget(self, action: #selector(ConnectedViewController.subButtontapped(_:)), forControlEvents: .TouchUpInside)
        
        
        print("about to return cell")
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let itemID : String = curItems.objectAtIndex(indexPath.row) as! String
            
            // Adjust the price
            
            let currItem : saleItem = availableItems.objectForKey(itemID) as! saleItem
            
            let count: Int = dupItems.objectForKey(itemID) as! Int
            
            curTotal -= currItem.price * Double(count)
            
            totalLabel.text = "Total: $" + String(format:"%.02f", curTotal)
            
            // Now remove the item
            
            curItems.removeObjectAtIndex(indexPath.row);
            dupItems.removeObjectForKey(itemID)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //MARK: Button Functions 
    
    func addButtontapped(sender: AnyObject){
        
        let itemID = curItems.objectAtIndex(sender.tag) as! String
        let count = dupItems.objectForKey(itemID) as! Int + 1
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        
        dupItems.setObject(count, forKey: itemID)
        
        itemsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        
        // Adjust the total
        
        let currItem : saleItem = availableItems.objectForKey(itemID) as! saleItem
        
        curTotal += currItem.price
        
        totalLabel.text = "Total: $" + String(format:"%.02f", curTotal)
    }
    
    func subButtontapped(sender: AnyObject){
        
        let itemID = curItems.objectAtIndex(sender.tag) as! String
        let count = dupItems.objectForKey(itemID) as! Int
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        if (count != 1) {
            dupItems.setObject(count - 1, forKey: itemID)
            itemsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            // Adjust the total 
            let currItem : saleItem = availableItems.objectForKey(itemID) as! saleItem
            
            curTotal -= currItem.price
            
            totalLabel.text = "Total: $" + String(format:"%.02f", curTotal)
        }
    }
    
    
    func checkoutButtonTapped(sender: AnyObject){
        print("Customer wants to check out")
        
        self.performSegueWithIdentifier("checkOutSegue", sender: self)
    }
    
    func cancelButtonPressed(sender: AnyObject){
        // Disconnect from bean and go back
        manager.disconnectBean(connectedBean, error: nil)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    
    // MARK: Helper
    
    
    
    
    func updateBean() {
        
        let hue = Double(arc4random() % 256) / 256.0
        let saturation = Double(arc4random() % 128) / 256.0 + 0.5
        let brightness = Double(arc4random() % 128) / 256.0 + 0.5
        let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
        
        
        
        connectedBean?.setLedColor(color)
    }
    
    
    
    
}
