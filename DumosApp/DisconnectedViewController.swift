//
//  DisconnectedViewController.swift
//  Personal Space Keeper
//
//  Created by Ariel Luque on 3/6/16.
//  Copyright © 2016 Ariel Luque. All rights reserved.
//

import UIKit

class DisconnectedViewController: UIViewController, PTDBeanManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let connectedViewControllerSegueIdentifier = "ViewConnection"
    var beanArray : [PTDBean] = [PTDBean]()
    
    var manager: PTDBeanManager!
    var connectedBean: PTDBean? {
        didSet {
            if connectedBean == nil {
                beanManagerDidUpdateState(manager)
            } else {
                performSegueWithIdentifier(connectedViewControllerSegueIdentifier, sender: self)
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var beanTableView: UITableView!
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = PTDBeanManager(delegate: self)
        beanTableView.delegate = self
        beanTableView.dataSource = self
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == connectedViewControllerSegueIdentifier {
            let vc = segue.destinationViewController as! ConnectedViewController
            vc.connectedBean = connectedBean
            vc.connectedBean?.delegate = vc
        }
    }
    
    // MARK: PTDBeanManagerDelegate
    
    func beanManagerDidUpdateState(beanManager: PTDBeanManager!) {
        switch beanManager.state {
        case .Unsupported:
            let alertController = UIAlertController(title: "Error", message: "This device is unsupported", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        case .PoweredOff:
            let alertController = UIAlertController(title: "Error", message: "Please turn on Bluetooth", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        case .PoweredOn:
            beanManager.startScanningForBeans_error(nil);
        default:
            break
        }
    }
    
    func beanManager(beanManager: PTDBeanManager!, didDiscoverBean bean: PTDBean!, error: NSError!) {
        print("DISCOVERED BEAN \nName: \(bean.name), UUID: \(bean.identifier) RSSI: \(bean.RSSI)")
        if connectedBean == nil {
            if bean.state == .Discovered {
                //manager.connectToBean(bean, error: nil)
                beanArray.append(bean)
                beanTableView.reloadData()
            }
        }
    }
    
    func BeanManager(beanManager: PTDBeanManager!, didConnectToBean bean: PTDBean!, error: NSError!) {
        print("CONNECTED BEAN \nName: \(bean.name), UUID: \(bean.identifier) RSSI: \(bean.RSSI)")
        if connectedBean == nil {
            connectedBean = bean
        }
    }
    
    func beanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: NSError!) {
        print("DISCONNECTED BEAN \nName: \(bean.name), UUID: \(bean.identifier) RSSI: \(bean.RSSI)")
        
        // Dismiss any modal view controllers.
        presentedViewController?.dismissViewControllerAnimated(true, completion: {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        self.connectedBean = nil
    }
    
    // * * * THE FOLLOWING 4 FUNCTIONS are really important for dynamically loading cells. We should copy and change this in ConnectedViewController where we add the dynamic cells that show each item and price (and the data that we feed that can be grabbed to calculate the total at the bottom).
    // * * * Also, beanArray is the array of beans we can connect to; we're going to need to change this to an array of itemStructs (defined in ConnectedViewController). To do this requires connecting to the bean and seeing what the serial input of the IDs looks like.
    
    // MARK: table functions
    func numberOfRowsInTableView(aTableView: UITableView) -> Int
    {
        let numberOfRows:Int = beanArray.count
        NSLog("Num rows: %i", numberOfRows)
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("Num rows in section: %i", beanArray.count)
        return beanArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "aCell", forIndexPath: indexPath)
        cell.textLabel!.text = self.beanArray[indexPath.row].name
        
        print("about to return cell")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row: " + String(indexPath.row))
        manager.connectToBean(self.beanArray[indexPath.row], error: nil)
        activityIndicator.startAnimating()
    }


}
