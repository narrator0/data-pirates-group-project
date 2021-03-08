//
//  SettingsViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/27/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for button design
        updateBtn.layer.cornerRadius = 5
        updateBtn.layer.shadowOpacity = 0.5
        updateBtn.layer.shadowRadius = 5
        updateBtn.layer.shadowOffset = .zero
        
        // change the color of the navigation back button
        self.navigationController?.navigationBar.tintColor = .orange
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
