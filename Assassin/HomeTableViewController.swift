//
//  HomeTableViewController.swift
//  Assassin
//
//  Created by Tobin Bell on 11/7/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var homeLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        homeLogo.layer.cornerRadius = 63
        homeLogo.layer.masksToBounds = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
