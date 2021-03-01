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
    var db = Firestore.firestore()
    static var db = Firestore.firestore()
    
    static func get(_ userID: String, complete: @escaping (_ user: User) -> Void) -> Void {
        let docRef = self.db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let first = data?["first"] as? String
                let last = data?["last"] as? String
                let email = data?["email"] as? String
                let userID = data?["userID"] as? String
                
                let user = User()
                user.firstName = first ?? ""
                user.lastName = last ?? ""
                user.email = email ?? ""
                user.userID = userID ?? ""
                
                print(user.userID)
                
                DispatchQueue.main.async {
                    complete(user)
                }
            } else {
                print("Document does not exist")
                
                DispatchQueue.main.async {
                    complete(User())
                }
            }
        }
    }
    
    init() {
        userID = ""
        firstName = ""
        lastName = ""
        email = ""
    }
    
    init(_ userID: String, _ firstName: String, _ lastName: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = ""
    }
    
    func save() -> Void {
        self.db.collection("users").document(self.userID).setData([
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
