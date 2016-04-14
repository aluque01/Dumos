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
        
        self.itemImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.itemImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
