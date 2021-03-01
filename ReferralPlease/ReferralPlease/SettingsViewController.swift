//
//  SettingsViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/27/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var updateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBtn.layer.cornerRadius = 5
        updateBtn.layer.shadowOpacity = 0.5
        updateBtn.layer.shadowRadius = 5
        updateBtn.layer.shadowOffset = .zero
        
    }
    

}
