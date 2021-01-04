//
//  ProfileTableViewPrimaryCell.swift
//  Assassin
//
//  Created by Tobin Bell on 11/7/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    var profileImageView = UIImageView(image: UIImage(named: "ProfileImage"))
    var labelsStackView = UIStackView()
    var nameField = UITextField()
    
    var name: String? {
        get {
            return nameField.text
        }
        set(newName) {
            nameField.text = newName
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        nameField.font = UIFont.systemFontOfSize(22)
        nameField.borderStyle = .None
        nameField.returnKeyType = .Done
        nameField.addTarget(nameField, action: "resignFirstResponder", forControlEvents: .PrimaryActionTriggered)
        
        let assassinLabel = UILabel()
        assassinLabel.text = "Master Assassin"
        assassinLabel.font = UIFont.systemFontOfSize(12)
        assassinLabel.textColor = kAssassinRedColor
        
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .Vertical
        labelsStackView.addArrangedSubview(nameField)
        labelsStackView.addArrangedSubview(assassinLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(labelsStackView)
        
        updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        // Profile image view
        contentView.addConstraint(NSLayoutConstraint(
            item: profileImageView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Leading,
            multiplier: 1,
            constant: 15))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: profileImageView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0))
        
        profileImageView.addConstraint(NSLayoutConstraint(
            item: profileImageView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 60))
        
        profileImageView.addConstraint(NSLayoutConstraint(
            item: profileImageView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 60))
        
        // Labels stack
        contentView.addConstraint(NSLayoutConstraint(
            item: labelsStackView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: profileImageView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 15))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: labelsStackView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(
            item: labelsStackView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0))
    }

}
