//
//  TextFieldCell.swift
//  Assassin
//
//  Created by Tobin Bell on 11/20/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    var textField: UITextField
    
    @IBInspectable var placeholder: String? {
        get {
            return textField.placeholder
        }
        set(newPlaceholder) {
            textField.placeholder = newPlaceholder
        }
    }
    
    private let leftTextInset: CGFloat = 16
    
    required init?(coder aDecoder: NSCoder) {
        textField = UITextField()
        
        super.init(coder: aDecoder)
        
        textField.frame = bounds
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftTextInset, height: bounds.height))
        textField.leftViewMode = .Always
        addSubview(textField)
    }
    
}
