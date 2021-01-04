//
//  EmailInputCell.swift
//  Assassin
//
//  Created by Tobin Bell on 11/8/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class EmailInputCell: InputCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        valueField.keyboardType = .EmailAddress
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
