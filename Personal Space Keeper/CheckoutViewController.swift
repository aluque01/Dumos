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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up button
        cancelButton.addTarget(self, action: #selector(CheckoutViewController.cancelButtonPushed(_:)), forControlEvents: .TouchUpInside)
    
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
