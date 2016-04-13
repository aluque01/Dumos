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
    
    
    @IBOutlet weak var itemsTableView : UITableView!
    
    @IBOutlet weak var BeanNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsTableView.delegate = self;
        itemsTableView.dataSource = self;
        
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
        

            self.curItems.addObject(theString)
            
            // Update Table Data
            self.itemsTableView.beginUpdates()
            self.itemsTableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow: self.curItems.count-1, inSection: 0)
                ], withRowAnimation: .Automatic)
            self.itemsTableView.endUpdates()

        
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
        let cell = tableView.dequeueReusableCellWithIdentifier( "itemCell", forIndexPath: indexPath)
        cell.textLabel!.text = self.curItems[indexPath.row] as? String
        
        print("about to return cell")
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            curItems.removeObjectAtIndex(indexPath.row);
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
