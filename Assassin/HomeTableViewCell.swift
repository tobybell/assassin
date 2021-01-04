//
//  HomeTableViewCell.swift
//  Assassin
//
//  Created by Tobin Bell on 11/7/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView?.layer.cornerRadius = 7
        imageView?.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
