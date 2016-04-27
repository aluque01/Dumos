//
//  CheckoutViewController.swift
//  Personal Space Keeper
//
//  Created by Ariel Luque on 4/14/16.
//  Copyright © 2016 Ariel Luque. All rights reserved.
//

import UIKit
import LocalAuthentication

class CheckoutViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton : UIButton!
    
    @IBOutlet weak var subTotalLabel : UILabel!
    @IBOutlet weak var taxLabel : UILabel!
    @IBOutlet weak var totalLabel : UILabel!
    
    @IBOutlet weak var subTotalStatic : UILabel!
    @IBOutlet weak var totalStatic : UILabel!
    @IBOutlet weak var taxStatic : UILabel!
    
    @IBOutlet weak var backView : UIView!
    
    @IBOutlet weak var checkoutLabel : UILabel!
    @IBOutlet weak var payLabel : UILabel!
    
    @IBOutlet weak var payButton : UIButton!
    
    
    var connectedBean: PTDBean?
    var manager: PTDBeanManager!
    
    
    var total : Double = 0.0
    var numberFormatter : NSNumberFormatter = NSNumberFormatter()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        payLabel.textColor = UIColor.whiteColor()
        checkoutLabel.textColor = UIColor.whiteColor()
        
        // Number formatter
        numberFormatter.numberStyle = .CurrencyStyle
        
        // Set up button
        cancelButton.addTarget(self, action: #selector(CheckoutViewController.cancelButtonPushed(_:)), forControlEvents: .TouchUpInside)
        
        
        // Set up the labels
        totalLabel.textAlignment = .Right
        subTotalLabel.textAlignment = .Right
        taxLabel.textAlignment = .Right
        checkoutLabel.textAlignment = .Center
        
        subTotalStatic.textColor = UIColor(red:0.61, green:0.61, blue:0.62, alpha:1.00)
        totalStatic.textColor = UIColor(red:0.61, green:0.61, blue:0.62, alpha:1.00)
        taxStatic.textColor = UIColor(red:0.61, green:0.61, blue:0.62, alpha:1.00)
        
        
        
        subTotalLabel.text = numberFormatter.stringFromNumber(total)!
        taxLabel.text = numberFormatter.stringFromNumber(total * 0.07)!
        totalLabel.text = numberFormatter.stringFromNumber(total * 1.07)!
        
        
        cancelButton.layer.cornerRadius = 4
        cancelButton.clipsToBounds = true
        cancelButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.596, blue: 0, alpha: 1)
        cancelButton.tintColor = UIColor.whiteColor()
        cancelButton.layer.shadowColor = UIColor(colorLiteralRed: 0.233, green: 0.233, blue: 0.233, alpha: 1).CGColor
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.shadowRadius = 8
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cancelButton.layer.masksToBounds = false;
        
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.588, blue: 0.533, alpha: 1)
        
        
        payButton.layer.cornerRadius = 40
        payButton.clipsToBounds = true
        payButton.backgroundColor = UIColor.whiteColor()
        payButton.tintColor = UIColor.whiteColor()
        payButton.layer.shadowColor = UIColor(colorLiteralRed: 0.233, green: 0.233, blue: 0.233, alpha: 1).CGColor
        payButton.layer.shadowOpacity = 0.5
        payButton.layer.shadowRadius = 8
        payButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        payButton.layer.masksToBounds = true;
        
        payButton.setBackgroundImage(UIImage(named: "touchID.png")!, forState: UIControlState.Normal)
        
        
        payButton.addTarget(self, action: #selector(CheckoutViewController.authenticateUser), forControlEvents: .TouchUpInside)
    
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticateUser() {
        // Get the local authentication context.
        let context : LAContext = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Authentication is needed to pay for your groceries."
        
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.manager.disconnectBean(self.connectedBean, error: nil)
                        
                        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                        
                    })
                    
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    
                    print(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                        
                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            
                            // DO stuff if authentication failed
                        })
                    }
                }
                
            })]
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func cancelButtonPushed(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: {})
    }

}
