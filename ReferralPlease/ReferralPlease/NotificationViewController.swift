//
//  NotificationViewController.swift
//  ReferralPlease
//
//  Created by Subin on 2021/02/26.
//

import UIKit
import FirebaseFirestore



class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var currentMenteesTableview: UITableView!
    @IBOutlet weak var pendingRequestsTableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MentorRequests.update()

        let mentees  = MentorRequests.shared.getMentees()
        let requestees = MentorRequests.shared.getRequestees()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currentMenteesCell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        cell.layer.cornerRadius = 5
        // cell.userName.text = "test user name"
        // cell.userDescription.text = "user description"
        cell.profileImage.image = UIImage(named: "image1")
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
            
        return cell
    }
    


    
        /*
        // for button shape
        declineButton.layer.cornerRadius = 5
        acceptButton.layer.cornerRadius = 5
        // for button shadow
        declineButton.layer.shadowColor = UIColor.black.cgColor
        declineButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        declineButton.layer.shadowRadius = 8
        declineButton.layer.shadowOpacity = 0.5
        acceptButton.layer.shadowColor = UIColor.black.cgColor
        acceptButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        acceptButton.layer.shadowRadius = 8
        acceptButton.layer.shadowOpacity = 0.5*/
        

}

