//
//  User.swift
//  ReferralPlease
//
//  Created by arfullight on 2/28/21.
//

import Foundation
import Firebase

class User {
    var userID: String
    var firstName: String
    var lastName: String
    var email: String
    private var db: Firestore?
    
    init() {
        userID = ""
        firstName = ""
        lastName = ""
        email = ""
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        self.db = Firestore.firestore()
    }
    
    init(_ userID: String, _ firstName: String, _ lastName: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = ""
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        self.db = Firestore.firestore()
    }
    
    func save() -> Void {
        self.db?.collection("users").document(self.userID).setData([
            "userID": self.userID,
            "first": self.firstName,
            "last": self.lastName,
            "email": self.email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.userID)")
            }
        }
    }
}
