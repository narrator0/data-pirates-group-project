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
    var role: String
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
                let role = data?["role"] as? String
                
                let user = User()
                user.firstName = first ?? ""
                user.lastName = last ?? ""
                user.email = email ?? ""
                user.userID = userID ?? ""
                user.role = role ?? ""
                
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
        role = ""
    }
    
    init(_ userID: String, _ firstName: String, _ lastName: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = ""
        self.role = ""
    }
    
    func save() -> Void {
        self.db.collection("users").document(self.userID).setData([
            "userID": self.userID,
            "first": self.firstName,
            "last": self.lastName,
            "email": self.email
        ], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.userID)")
            }
        }
    }
    
    func update(field: String, value: String) -> Void {
        switch field {
        case "role":
            self.db.collection("users").document(self.userID).setData(["role": value], merge: true) { err in
                if let err = err {
                    print("Error updating role for: \(self.userID)")
                    print("Error message \(err)")
                } else {
                    print("Updated \(self.userID) to role \(value)")
                }
            }
        default:
            return
        }
    }
}
