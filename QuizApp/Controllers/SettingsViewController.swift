//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logoutPressed(_ sender: Any) {
        Authorization.logoutUser()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchToLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        
        logoutButton.layer.cornerRadius = 23
        logoutButton.setTitleColor(Colors.red, for: .normal)
        
        if let username = Authorization.getUsername(){
            usernameLabel.text =  username
        } else {
            usernameLabel.text =  "ERROR NO USERNAME FOUND"
        }
    }
}
