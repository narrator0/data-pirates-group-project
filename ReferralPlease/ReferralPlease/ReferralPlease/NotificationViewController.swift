//
//  NotificationViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/26.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for button shape
        self.declineButton.layer.cornerRadius = 5
        self.acceptButton.layer.cornerRadius = 5
        // for button shadow
        declineButton.layer.shadowColor = UIColor.black.cgColor
        declineButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        declineButton.layer.shadowRadius = 8
        declineButton.layer.shadowOpacity = 0.5
        acceptButton.layer.shadowColor = UIColor.black.cgColor
        acceptButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        acceptButton.layer.shadowRadius = 8
        acceptButton.layer.shadowOpacity = 0.5

    }
    
}
