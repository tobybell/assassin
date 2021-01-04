//
//  PhoneInputCell.swift
//  Assassin
//
//  Created by Tobin Bell on 11/8/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class PhoneInputCell: InputCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let phonePadToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "closePhonePad")
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        phonePadToolbar.tintColor = kAssassinRedColor
        phonePadToolbar.setItems([spacer, doneButton], animated: false)
        
        valueField.inputAccessoryView = phonePadToolbar
        valueField.keyboardType = .NumberPad
        valueField.addTarget(self, action: "formatPhoneText", forControlEvents: .EditingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func closePhonePad() {
        formatPhoneText()
        valueField.resignFirstResponder()
    }
    
    func formatPhoneText() {
        guard var phoneNumber = valueField.text?.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("") else {
            return
        }
        
        let length = phoneNumber.characters.count
        let startIndex = phoneNumber.startIndex
        
        if length <= 11 {
            if phoneNumber.characters.first == "1" {
                if length > 7 {
                    phoneNumber.insert("-", atIndex: startIndex.advancedBy(7))
                }
                if length > 4 {
                    phoneNumber.insert(" ", atIndex: startIndex.advancedBy(4))
                    phoneNumber.insert(")", atIndex: startIndex.advancedBy(4))
                }
                if length > 1 {
                    phoneNumber.insert("(", atIndex: startIndex.advancedBy(1))
                    phoneNumber.insert(" ", atIndex: startIndex.advancedBy(1))
                    phoneNumber.insert("+", atIndex: startIndex)
                }
            } else {
                if length > 7 {
                    phoneNumber.insert("-", atIndex: startIndex.advancedBy(6))
                    phoneNumber.insert(" ", atIndex: startIndex.advancedBy(3))
                    phoneNumber.insert(")", atIndex: startIndex.advancedBy(3))
                    phoneNumber.insert("(", atIndex: startIndex)
                } else if length > 3 {
                    phoneNumber.insert("-", atIndex: startIndex.advancedBy(3))
                }
            }
        }
        
        valueField.text = phoneNumber
    }

}
