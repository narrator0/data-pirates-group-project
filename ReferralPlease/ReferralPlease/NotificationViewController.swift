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
    var mentees: [User] = []
    var requestees: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentMenteesTableview.delegate = self
        self.currentMenteesTableview.dataSource = self
        self.pendingRequestsTableview.delegate = self
        self.pendingRequestsTableview.dataSource = self
        self.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.pendingRequestsTableview {
            return self.requestees.count
        }
        else {
            return self.mentees.count
        }
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("what")
        if tableView == self.pendingRequestsTableview {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RequesteeTableCell else {return UITableViewCell()}
            cell.layer.cornerRadius = 5
            let user = self.requestees[indexPath.row]
            let firstname = user.firstName
            let lastname = user.lastName
            cell.message.text = firstname + " " + lastname + " has sent you a mentorship request!"
            User.currentUser(){
                userRecord in
                cell.documentID = userRecord.userID + user.userID
            }
            cell.profilePicture.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
            cell.profilePicture.clipsToBounds = true
            
            return cell
        }
        else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenteeTableViewCell else {return UITableViewCell()}
            
            cell.layer.cornerRadius = 5
            let user = self.mentees[indexPath.row]
            let firstname = user.firstName
            let lastname = user.lastName
            cell.menteeName.text = firstname + " " + lastname
            cell.profilePicture.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
            cell.profilePicture.clipsToBounds = true
            return cell
        }
    }
    

    func reloadData() {

        MentorRequests.update()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.mentees  = MentorRequests.shared.getMentees()
            self.requestees = MentorRequests.shared.getRequestees()
            print(self.mentees)
            self.currentMenteesTableview.reloadData()
            self.pendingRequestsTableview.reloadData()
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
    


}

