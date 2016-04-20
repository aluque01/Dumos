//
//  DumosItemTableViewCell.swift
//  Personal Space Keeper
//
//  Created by Ariel Luque on 4/13/16.
//  Copyright © 2016 Ariel Luque. All rights reserved.
//

import UIKit

class DumosItemTableViewCell: UITableViewCell {
    
    var itemName : String = ""
    var itemCount : Int = 0
    var price : Double = 0.0
    var itemID : String = ""
    
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var countLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var itemImage : UIImageView!
    @IBOutlet weak var addButton : UIButton!
    @IBOutlet weak var subButton : UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
        // Image setup
        self.itemImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.itemImage.clipsToBounds = true
        self.itemImage.layer.cornerRadius = 10.0
        
        
        // Set up design 
        
        priceLabel.textColor = UIColor(colorLiteralRed: 0.447, green: 0.447, blue: 0.447, alpha: 1)
        countLabel.textColor = UIColor(colorLiteralRed: 0.447, green: 0.447, blue: 0.447, alpha: 1)

        
        // Button setup and rounding
        addButton.layer.cornerRadius = 15
        addButton.clipsToBounds = true
        addButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.596, blue: 0, alpha: 1)
        addButton.tintColor = UIColor.whiteColor()
        addButton.layer.shadowColor = UIColor(colorLiteralRed: 0.233, green: 0.233, blue: 0.233, alpha: 1).CGColor
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowRadius = 1
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        addButton.layer.masksToBounds = false;
        
        subButton.layer.cornerRadius = 15
        subButton.clipsToBounds = true
        subButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.596, blue: 0, alpha: 1)
        subButton.tintColor = UIColor.whiteColor()
        subButton.layer.shadowColor = UIColor(colorLiteralRed: 0.233, green: 0.233, blue: 0.233, alpha: 1).CGColor
        subButton.layer.shadowOpacity = 0.3
        subButton.layer.shadowRadius = 1
        subButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        subButton.layer.masksToBounds = false;
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
