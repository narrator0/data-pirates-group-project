//
//  NotificationViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/26.
//

import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MentorRequests.update()
        let requestIDs = MentorRequests.shared.getRequestsIDs()
    }
    

    func getRequesteeInfo() {
        
    }

}
