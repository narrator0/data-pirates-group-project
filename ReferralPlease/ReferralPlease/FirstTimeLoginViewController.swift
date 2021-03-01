//
//  FirstTimeLoginViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/26.
//

import UIKit

class FirstTimeLoginViewController: UIViewController {
    
    @IBOutlet weak var mentorButton: UIButton!
    @IBOutlet weak var menteeButton: UIButton!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for button shape
        self.mentorButton.layer.cornerRadius = 5
        self.menteeButton.layer.cornerRadius = 5
        // for button shadow
        mentorButton.layer.shadowColor = UIColor.black.cgColor
        mentorButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        mentorButton.layer.shadowRadius = 8
        mentorButton.layer.shadowOpacity = 0.5
        menteeButton.layer.shadowColor = UIColor.black.cgColor
        menteeButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        menteeButton.layer.shadowRadius = 8
        menteeButton.layer.shadowOpacity = 0.5
    }
    
    @IBAction func mentorButtonAction(_ sender: UIButton) {
        self.user?.update(field: "role", value: "mentor")
        self.goToHome()
    }
    
    @IBAction func menteeButtonAction(_ sender: UIButton) {
        self.user?.update(field: "role", value: "mentee")
        self.goToHome()
    }
    
    func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabController = storyboard.instantiateViewController(withIdentifier: "mainTabViewController") as? MainTabController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabController)
    }
}
