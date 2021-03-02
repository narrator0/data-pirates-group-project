//
//  NotificationViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/26.
//

import UIKit
import FirebaseFirestore

class NotificationViewController: UIViewController {
    var user = User()
    let db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        MentorRequests.update()

        let mentees  = MentorRequests.shared.getMentees()
        let requestees = MentorRequests.shared.getRequestees()
        
    }
    


}
