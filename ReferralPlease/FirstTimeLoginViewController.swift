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
        
        // go to home vc
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as? HomePageViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    
    @IBAction func menteeButtonAction(_ sender: UIButton) {
        
        // go to home vc
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as? HomePageViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
}
