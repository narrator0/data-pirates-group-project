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
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
