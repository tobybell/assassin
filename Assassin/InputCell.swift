//
//  InputCell.swift
//  Assassin
//
//  Created by Tobin Bell on 11/7/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {
    
    var keyButton = UIButton()
    var valueField = UITextField()
    
    var key: String? {
        get {
            return keyButton.titleForState(.Normal)
        }
        set(newKey) {
            keyButton.setTitle(newKey, forState: .Normal)
            valueField.placeholder = newKey
        }
    }
    
    var value: String? {
        get {
            return valueField.text
        }
        set(newValue) {
            valueField.text = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        keyButton.translatesAutoresizingMaskIntoConstraints = false
        keyButton.setTitleColor(kAssassinRedColor, forState: .Normal)
        keyButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        keyButton.contentHorizontalAlignment = .Right
        keyButton.addTarget(valueField, action: "becomeFirstResponder", forControlEvents: .TouchUpInside)

        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.font = UIFont.systemFontOfSize(16)
        valueField.borderStyle = .None
        valueField.returnKeyType = .Done
        valueField.addTarget(valueField, action: "resignFirstResponder", forControlEvents: .PrimaryActionTriggered)
        
        contentView.addSubview(keyButton)
        contentView.addSubview(valueField)
        
        updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        // Key button
        contentView.addConstraint(NSLayoutConstraint(
            item: keyButton,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Leading,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: keyButton,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: keyButton,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 60))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: keyButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Height,
            multiplier: 1,
            constant: 0))
        
        // Value field
        contentView.addConstraint(NSLayoutConstraint(
            item: valueField,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Leading,
            multiplier: 1,
            constant: 68))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: valueField,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: valueField,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: valueField,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Height,
            multiplier: 1,
            constant: 0))
    }
}
