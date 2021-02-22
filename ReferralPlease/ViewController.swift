//
//  ViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 2/18/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var clickRegister: UIButton!
    @IBOutlet weak var clickResetPass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // button design
        self.buttonGo.layer.cornerRadius = 5
        
        // textfield shadow
        textEmail.layer.shadowColor = UIColor.black.cgColor
        textEmail.layer.shadowOffset = CGSize(width: 5, height: 5)
        textEmail.layer.shadowRadius = 5
        textEmail.layer.shadowOpacity = 1.0
        textPassword.layer.shadowColor = UIColor.black.cgColor
        textPassword.layer.shadowOffset = CGSize(width: 5, height: 5)
        textPassword.layer.shadowRadius = 5
        textPassword.layer.shadowOpacity = 1.0
        
        
        textEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textEmail.frame.height))
        textEmail.leftViewMode = .always
        textPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textPassword.frame.height))
        textPassword.leftViewMode = .always
    }
    
    
    @IBAction func clickCreateAccountLabel(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let createAccountVC = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as? CreateAccountViewController else{
            assertionFailure("couldn't find vc")
            return
        }
        if let nav = self.navigationController {
            nav.pushViewController(createAccountVC, animated: true)
        } else {
            assertionFailure("no nav controller")
        }
    }
    

}

