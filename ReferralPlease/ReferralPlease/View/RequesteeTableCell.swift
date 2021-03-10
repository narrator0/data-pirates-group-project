//
//  RequesteeTableCell.swift
//  ReferralPlease
//
//  Created by Justin Lim on 3/7/21.
//

import UIKit
import FirebaseFirestore

class RequesteeTableCell: UITableViewCell {


    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    var view: NotificationViewController = NotificationViewController()
    var documentID = ""
    let db = Firestore.firestore()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        User.currentUser() {
            user in
            if user.role == "mentee" {
                self.declineButton.isHidden = true
                self.acceptButton.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func acceptRequest() {
        db.collection("mentorStatus").document(self.documentID).setData([
            "accepted": true
        ], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
                self.view.reloadData()
            }
        }
        
    }
    @IBAction func declineRequest(_ sender: Any) {
        db.collection("mentorStatus").document(self.documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.view.reloadData()
            }
        }
        
    }
}
