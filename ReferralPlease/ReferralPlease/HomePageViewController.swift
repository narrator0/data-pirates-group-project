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

class HomePageViewController: UIViewController, UITableViewDataSource {
    
    var db: Firestore?
    var currentUsers: [User] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        tableView.dataSource = self
        print("home page view called")
        
        // dispatch queue
        User.getAll(complete: { response in
            self.currentUsers = response
        })
        
        tableView.reloadData()
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
        
//        let docRef = self.db.collection("users").document(userID)

//        currUsersIDs[indexPath.row]
        
        
        cell.layer.cornerRadius = 5
        let firstname = String(currentUsers[indexPath.row].firstName)
        let lastname = String(currentUsers[indexPath.row].lastName)
        cell.userName.text = firstname + " " + lastname
//            cell.userName.text = "name"
        cell.userDescription.text = "user description"
        cell.profileImage.image = UIImage(named: "image1")
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
        
        self.tableView.reloadData()

        return cell
    }

}
