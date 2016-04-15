//
//  CheckoutViewController.swift
//  Personal Space Keeper
//
//  Created by Ariel Luque on 4/14/16.
//  Copyright © 2016 Ariel Luque. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var totalLabel : UILabel!
    
    var total : Double = 0.0
    var numberFormatter : NSNumberFormatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Number formatter
        numberFormatter.numberStyle = .CurrencyStyle
        
        // Set up button
        cancelButton.addTarget(self, action: #selector(CheckoutViewController.cancelButtonPushed(_:)), forControlEvents: .TouchUpInside)
        
        
        // Set up the label 
        totalLabel.textAlignment = .Center
        totalLabel.text = numberFormatter.stringFromNumber(total)!
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
