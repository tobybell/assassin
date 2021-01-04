//
//  NewGameOptionsViewController.swift
//  Assassin
//
//  Created by Tobin Bell on 11/20/15.
//  Copyright © 2015 Tobin Bell. All rights reserved.
//

import UIKit

class NewGameOptionsViewController: UITableViewController {

    @IBOutlet weak var gameNameCell: TextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Focus the game name field.
        gameNameCell.textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
