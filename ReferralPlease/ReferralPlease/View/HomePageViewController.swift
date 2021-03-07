//
//  HomePageViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/24/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import SDWebImage

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    

    var user: User?
    var db: Firestore?
    var currentUsers: [User] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        print("home page view called")
        self.tableView.dataSource = self
        self.tableView.delegate = self

        User.currentUser(){
            userRecord in
            MentorRequests.update(userRecord.userID)
        }
        
        
        // dispatch queue
        User.getAll() { mentors in
            self.currentUsers = mentors
            self.tableView.reloadData()
            
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentUsers.count
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        
//        cell.layer.cornerRadius = 5
        let user = self.currentUsers[indexPath.row]
        let firstname = user.firstName
        let lastname = user.lastName
        cell.userName.text = firstname + " " + lastname
        cell.userDescription.text = user.company
        cell.profileImage.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
        cell.userPosition.text = user.position
        cell.layer.cornerRadius = 10
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowRadius = 7.0
        cell.layer.shadowOffset = CGSize(width: 0, height: 6.0)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "profilePageViewController") as? ProfilePageViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        
        vc.user = self.currentUsers[indexPath.row]
        vc.isPublic = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 20

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        self.tableView.contentInset.bottom = -verticalPadding/2
        self.tableView.contentInset.top = -verticalPadding/2
    }
}

