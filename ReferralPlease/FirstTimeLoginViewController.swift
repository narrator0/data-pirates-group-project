//
//  FirstTimeLoginViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/26.
//

import UIKit

class FirstTimeLoginViewController:

    UIViewController {
    
    @IBOutlet weak var mentorButton: UIButton!
    @IBOutlet weak var menteeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mentorButton.layer.cornerRadius = 5
        self.menteeButton.layer.cornerRadius = 5
    }
    
}
