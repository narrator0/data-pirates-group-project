//
//  CreateAccountViewController.swift
//  ReferralPlease
//
//  Created by Jessica Lo on 2/21/21.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var labelCreatAccount: UILabel!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var againPassword: UITextField!
    @IBOutlet weak var clickLogin: UIButton!
    @IBOutlet weak var buttonGo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        againPassword.layer.shadowColor = UIColor.black.cgColor
        againPassword.layer.shadowOffset = CGSize(width: 5, height: 5)
        againPassword.layer.shadowRadius = 5
        againPassword.layer.shadowOpacity = 1.0
        
        
        //self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    


}
