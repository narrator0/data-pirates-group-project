//
//  ViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 2/18/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var clickSignUp: UIButton!
    @IBOutlet weak var clickResetPassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonGo.layer.cornerRadius = 5
    }


}

