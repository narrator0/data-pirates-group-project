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
    
    var db: Firestore?
    var currentUsers: [User] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // dispatch queue
        User.getAll() { mentors in
            self.currentUsers = mentors
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        
        cell.layer.cornerRadius = 5
        let user = currentUsers[indexPath.row]
        let firstname = user.firstName
        let lastname = user.lastName
        cell.userName.text = firstname + " " + lastname
        cell.userDescription.text = user.company
        cell.profileImage.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
        cell.userPosition.text = user.position

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
}
