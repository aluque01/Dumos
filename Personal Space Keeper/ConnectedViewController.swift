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
    
    var connectedBean: PTDBean?
    var curLimit = 0.5
    
    var curItems : NSMutableArray = NSMutableArray()
    var dupItems : NSMutableDictionary = NSMutableDictionary()
    
    
    @IBOutlet weak var itemsTableView : UITableView!
    
    @IBOutlet weak var BeanNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsTableView.delegate = self;
        itemsTableView.dataSource = self;
        
        //remove selection hightlighting
        itemsTableView.allowsSelection = false
        
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
            
            
        } else {
            
            dupItems.setValue(1, forKey: theString as String);

            self.curItems.addObject(theString)
            
            // Update Table Data
            self.itemsTableView.beginUpdates()
            self.itemsTableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow: self.curItems.count-1, inSection: 0)
                ], withRowAnimation: .Automatic)
            self.itemsTableView.endUpdates()
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
        
        cell.nameLabel.text = itemID
        cell.countLabel.text = String(dupItems.objectForKey(itemID) as! Int)
        cell.priceLabel.text = "300.00"
        
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
    }
    
    func subButtontapped(sender: AnyObject){
        
        let itemID = curItems.objectAtIndex(sender.tag) as! String
        let count = dupItems.objectForKey(itemID) as! Int
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        if (count != 1) {
            dupItems.setObject(count - 1, forKey: itemID)
            itemsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    // MARK: Helper
    
    func updatesonicView() {
        
        
    }
    
    func updateBean() {
        
        let hue = Double(arc4random() % 256) / 256.0
        let saturation = Double(arc4random() % 128) / 256.0 + 0.5
        let brightness = Double(arc4random() % 128) / 256.0 + 0.5
        let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
        
        
        
        connectedBean?.setLedColor(color)
    }
    
    
    
    
}
