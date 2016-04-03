//
//  ConnectedViewController.swift
//  Personal Space Keeper
//
//  Created by Ariel Luque on 3/6/16.
//  Copyright © 2016 Ariel Luque. All rights reserved.
//

import UIKit
import AudioToolbox

class ConnectedViewController: UIViewController, PTDBeanDelegate {

    var connectedBean: PTDBean?
    var curLimit = 0.5
    
    // MARK: Lifecycle
    
    @IBOutlet weak var BeanNameLabel: UILabel!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var LimitLabel: UILabel!
    
    @IBOutlet weak var ProgressBar: UIProgressView!
  
    @IBOutlet weak var OneMeter: UIButton!
    @IBOutlet weak var TwoMeter: UIButton!
    @IBOutlet weak var ThreeMeter: UIButton!
    @IBOutlet weak var FourMeter: UIButton!
    @IBOutlet weak var FiveMeter: UIButton!
    

    
    
    @IBAction func buttonPressed(sender: AnyObject){
        switch sender.tag{
        case 1:
            curLimit = 0.1
            LimitLabel.text = "Current Limit: 0.1 meters"
        case 2:
            curLimit = 0.2
            LimitLabel.text = "Current Limit: 0.2 meters"
        case 3:
            curLimit = 0.3
            LimitLabel.text = "Current Limit: 0.3 meters"
        case 4:
            curLimit = 0.4
            LimitLabel.text = "Current Limit: 0.4 meters"
        case 5:
            curLimit = 0.5
            LimitLabel.text = "Current Limit: 0.5 meters"
        default:
            curLimit = 0.5
            LimitLabel.text = "Current Limit: 0.5 meters"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressBar.transform = CGAffineTransformScale(ProgressBar.transform, 1, 40)
        
        // Update the name label.
        BeanNameLabel.text = connectedBean?.name
        let buttons = [OneMeter, TwoMeter, ThreeMeter, FourMeter, FiveMeter]
        
        
        for button in buttons{
            button.backgroundColor = UIColor.clearColor()
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = self.view.tintColor.CGColor
        }
        
        
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
        let theString:NSString = NSString(data: data, encoding: NSASCIIStringEncoding)!
        let distFloat = theString.floatValue * 340.0 / 2 / 1e6
        
        DistanceLabel.text = "Distance: " + distFloat.description + "meters"
        
        ProgressBar.progress = distFloat * 2.0
        
        if(Double(distFloat) < curLimit){
            
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            ProgressBar.tintColor = UIColor.redColor()
        } else {
            ProgressBar.tintColor = UIColor.greenColor()
        }
        
        print(theString)
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
