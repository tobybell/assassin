//
//  EditProfileViewController.swift
//  Assassin
//
//  Created by Tobin Bell on 11/7/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit
import CloudKit

class EditProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userBirthdayField: UITextField!
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPhoneField: UITextField!
    
    let imagePickerController = UIImagePickerController()
    var birthdayPickerView = UIDatePicker()
    let loadingView = UIView()
    
    var user: User?
    
    var profilePhoneNumber: String {
        get {
            guard var string = userPhoneField.text?.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("") else {
                return ""
            }
            
            if string.characters.first == "1" {
                string.removeAtIndex(string.startIndex)
            }
            
            return string
        }
        set(newPhoneNumber) {
            userPhoneField.text = newPhoneNumber
            formatPhoneText(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the User Image look round (instead of square).
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.layer.masksToBounds = true
        
        // Configure the Image Picker Controller.
        imagePickerController.delegate = self
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.allowsEditing = true
        
        // Configure the Birthday Field (with its date picker view)
        birthdayPickerView.datePickerMode = .Date
        birthdayPickerView.addTarget(self, action: "formatBirthdayText:", forControlEvents: .ValueChanged)
        let birthdayPickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let birthdayPickerDone = UIBarButtonItem(barButtonSystemItem: .Done, target: userBirthdayField, action: "resignFirstResponder")
        birthdayPickerDone.tintColor = kAssassinRedColor
        birthdayPickerToolbar.items = [spacer, birthdayPickerDone]
        
        userBirthdayField.inputView = birthdayPickerView
        userBirthdayField.inputAccessoryView = birthdayPickerToolbar
        
        
        let phonePickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let phonePickerDone = UIBarButtonItem(barButtonSystemItem: .Done, target: userPhoneField, action: "resignFirstResponder")
        phonePickerDone.tintColor = kAssassinRedColor
        phonePickerToolbar.items = [spacer, phonePickerDone]
        userPhoneField.inputAccessoryView = phonePickerToolbar
        
        // Configure the loading view.
        // This view covers the screen while loading the data from iCloud.
        var contentFrame = view.frame
        contentFrame.size.height -= 64
        loadingView.frame = contentFrame
        loadingView.backgroundColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 244.0/255, alpha: 1)
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingIndicator.color = kAssassinRedColor
        loadingIndicator.startAnimating()
        loadingView.addSubview(loadingIndicator)
        // Center the indicator
        loadingIndicator.center = CGPoint(x: contentFrame.midX, y: contentFrame.midY)
        
        // Load data from iCloud
        self.showLoadingView(animated: false)
        User.currentUser { (user) in
            if user != nil {
                self.user = user
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.loadUserData(user!)
                    self.hideLoadingView(animated: true)
                }
            }
        }
    }
    

    
    // MARK: - Loading view
    
    func showLoadingView(animated animated: Bool) {
        if animated {
            CATransaction.begin()
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.fromValue = 0
                animation.duration = 0.25
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                loadingView.layer.addAnimation(animation, forKey: "fadeIn")
            CATransaction.commit()
        }
        
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        loadingView.layer.opacity = 1
    }
    
    func hideLoadingView(animated animated: Bool) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.loadingView.removeFromSuperview()
            }
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1
            animation.duration = 0.25
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            loadingView.layer.addAnimation(animation, forKey: "fadeIn")
            CATransaction.commit()
        }
        
        loadingView.layer.opacity = 0
    }
    
    // MARK: - Field select behaviors
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // "Choose a new picture" button pressed
        if indexPath.section == 0 && indexPath.row == 1 {
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        // "Remove picture" button pressed
        if indexPath.section == 0 && indexPath.row == 2 {
            user?.image = nil
            userImageView.image = user?.image
        }
    }
    
    // MARK: - Field completion behaviors.
    // The following code deals with updating fields of the User object.
    
    // Triggered by "Done" button on Name and Email fields.
    @IBAction func endEditing(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func saveAndDismiss(sender: AnyObject) {
        view.endEditing(true)
        
        showLoadingView(animated: true)
        view.userInteractionEnabled = false
        
        if let user = self.user {
            user.save { (success) in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
    }
    
    // MARK: Formatting data
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        user?.image = image
        userImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func formatBirthdayText(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, YYYY"
        
        if sender as? EditProfileViewController != self {
            user?.birthday = birthdayPickerView.date
        }
        
        userBirthdayField.text = formatter.stringFromDate(birthdayPickerView.date)
    }
    
    @IBAction func nameChanged(sender: AnyObject) {
        user?.name = userNameField.text!
    }
    
    @IBAction func emailChanged(sender: AnyObject) {
        user?.email = userEmailField.text!
    }
    
    @IBAction func formatPhoneText(sender: AnyObject) {
        
        guard var phoneNumber = userPhoneField.text?.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("") else {
            return
        }
        
        if sender as? EditProfileViewController != self {
            user?.phone = phoneNumber
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
        
        userPhoneField.text = phoneNumber
    }
    
    func loadUserData(user: User) {
        userImageView.image = user.image
        userNameField.text = user.name
        userEmailField.text = user.email
        userPhoneField.text = user.phone
        birthdayPickerView.date = user.birthday
        
        formatBirthdayText(self)
        formatPhoneText(self)
    }

}
