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

    @IBOutlet weak var menteesLabel: UILabel!
    @IBAction func settingButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier:"settingsViewController") as? SettingsViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentMenteesTableview.delegate = self
        self.currentMenteesTableview.dataSource = self
        self.pendingRequestsTableview.delegate = self
        self.pendingRequestsTableview.dataSource = self
        User.currentUser() {
            user in
            if user.role == "mentee" {
                self.menteesLabel.text = "Current mentor"
            }
        }
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
        if tableView == self.pendingRequestsTableview {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RequesteeTableCell else {return UITableViewCell()}
            cell.layer.cornerRadius = 5
            let user = self.requestees[indexPath.row]
            let firstname = user.firstName
            let lastname = user.lastName
          
            
            
            User.currentUser(){
                userRecord in
                cell.documentID = userRecord.userID + user.userID
                if userRecord.role == "mentor" {
                    cell.message.text = firstname + " " + lastname + " has sent you a mentorship request!"
                }
                else {
                    cell.message.text = "You have sent a request to " + firstname + " " + lastname 
                }
            }
            cell.profilePicture.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
            cell.profilePicture.clipsToBounds = true
            cell.view = self
            
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 10

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        self.pendingRequestsTableview.contentInset.bottom = -verticalPadding/2
        self.pendingRequestsTableview.contentInset.top = -verticalPadding/2
        self.currentMenteesTableview.contentInset.bottom = -verticalPadding/2
        self.currentMenteesTableview.contentInset.top = -verticalPadding/2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "profilePageViewController") as? ProfilePageViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        if tableView == currentMenteesTableview {
            vc.user = self.mentees[indexPath.row]
        }
        else {
            vc.user = self.requestees[indexPath.row]
        }
        vc.isPublic = true
        navigationController?.pushViewController(vc, animated: true)
    }


    func reloadData() {

        MentorRequests.update()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.mentees  = MentorRequests.shared.getMentees()
            self.requestees = MentorRequests.shared.getRequestees()

            self.currentMenteesTableview?.reloadData()
            self.pendingRequestsTableview?.reloadData()
    }
    
    }
}

