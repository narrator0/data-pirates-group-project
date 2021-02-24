//
//  ResetPasswordViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/21.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var clickRegister: UIButton!
    @IBOutlet weak var clickLogin: UIButton!
    @IBOutlet weak var buttonSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button design
        self.buttonSend.layer.cornerRadius = 5
        
        // textfield shadow
        textEmail.layer.shadowColor = UIColor.black.cgColor
        textEmail.layer.shadowOffset = CGSize(width: 5, height: 5)
        textEmail.layer.shadowRadius = 5
        textEmail.layer.shadowOpacity = 1.0
    }
    

}
