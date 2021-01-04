//
//  User.swift
//  Assassin
//
//  Created by Tobin Bell on 11/9/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit
import CloudKit

class User: NSObject {
    
    static let defaultImage = UIImage(named: "UserDefaultImage")!.imageWithRenderingMode(.AlwaysTemplate)
    
    private static var currentUser: User?
    
    private struct Modifications: OptionSetType {
        var rawValue: Int
        static let Image    = Modifications(rawValue: 1)
        static let Name     = Modifications(rawValue: 2)
        static let Birthday = Modifications(rawValue: 4)
        static let Email    = Modifications(rawValue: 8)
        static let Phone    = Modifications(rawValue: 16)
    }
    
    // CloudKit record
    private var record: CKRecord
    
    // Track modifications
    private var modifications: Modifications = []
    
    private var rawImage: UIImage?
    var image: UIImage! {
        get {
            if let image = self.rawImage {
                return image
            } else {
                return User.defaultImage
            }
        }
        set(newImage) {
            modifications.unionInPlace(.Image)
            rawImage = newImage
        }
    }
    
    var name = "" {
        didSet {
            modifications.unionInPlace(.Name)
        }
    }
    
    var birthday = NSDate() {
        didSet {
            modifications.unionInPlace(.Birthday)
        }
    }
    
    var email = "" {
        didSet {
            modifications.unionInPlace(.Email)
        }
    }
    
    var phone = "" {
        didSet {
            modifications.unionInPlace(.Phone)
        }
    }
    
    init(record: CKRecord) {
        self.record = record
        
        if let imageAsset = record["image"] as! CKAsset? {
            rawImage = UIImage(contentsOfFile: imageAsset.fileURL.path!)
        }
        
        if let name = record["name"] as! String? {
            self.name = name
        }
        
        if let birthday = record["birthday"] as! NSDate? {
            self.birthday = birthday
        }
        
        if let email = record["email"] as! String? {
            self.email = email
        }
        
        if let phone = record["phone"] as! String? {
            self.phone = phone
        }
        
    }
    
    class func currentUser(completionBlock: (User?) -> Void) {
        if let currentUser = self.currentUser {
            completionBlock(currentUser)
        } else {
            let userRecordFetch = CKFetchRecordsOperation.fetchCurrentUserRecordOperation()
            userRecordFetch.database = CKContainer.defaultContainer().publicCloudDatabase
            userRecordFetch.queuePriority = .VeryHigh
            userRecordFetch.qualityOfService = .Utility
            userRecordFetch.perRecordCompletionBlock = { (possibleUserRecord, _, error) in
                
                guard let userRecord = possibleUserRecord else {
                    completionBlock(nil)
                    return
                }
                
                guard error == nil else {
                    completionBlock(nil)
                    return
                }
                
                self.currentUser = User(record: userRecord)
                completionBlock(currentUser)
            }
            userRecordFetch.start()
        }
    }
    
    class func userWithRecordID(recordID: CKRecordID, completionBlock: (User?) -> Void) {
        CKContainer.defaultContainer().publicCloudDatabase.fetchRecordWithID(recordID) {
            let (possibleUserRecord, error) = $0
            
            guard let userRecord = possibleUserRecord else {
                completionBlock(nil)
                return
            }
            
            guard error == nil else {
                completionBlock(nil)
                return
            }
            
            completionBlock(User(record: userRecord))
        }
    }
    
    func save(completionBlock: (Bool) -> Void) {
        
        // Compute the location to save the image for CKAsset upload.
        let temporaryDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        let fileURL = temporaryDirectoryURL.URLByAppendingPathComponent("ProfileImage").URLByAppendingPathExtension("jpg")
        
        // Save only needed changes.
        if modifications.contains(.Image) {
            if let image = rawImage {
                UIImageJPEGRepresentation(image, 1)?.writeToURL(fileURL, atomically: true)
                record["image"] = CKAsset(fileURL: fileURL)
            } else {
                record["image"] = nil
            }
        }
        
        if modifications.contains(.Name) {
            record["name"] = name
        }
        
        if modifications.contains(.Birthday) {
            record["birthday"] = birthday
        }
        
        if modifications.contains(.Email) {
            record["email"] = email
        }
        
        if modifications.contains(.Phone) {
            record["phone"] = phone
        }
        
        modifications = []
        
        let saveOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        saveOperation.database = CKContainer.defaultContainer().publicCloudDatabase
        saveOperation.qualityOfService = .UserInitiated
        saveOperation.savePolicy = .ChangedKeys
        saveOperation.perRecordCompletionBlock = { (savedRecord, error) in
            do {
                try NSFileManager.defaultManager().removeItemAtURL(fileURL)
            } catch _ {}
            
            if error == nil {
                self.record = savedRecord!
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
        
        saveOperation.start()
    }

}
