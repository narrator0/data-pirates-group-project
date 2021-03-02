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
    var avatarURL: String
    
    var company: String
    var position: String
    var about: String
    
    var role: String
    var db = Firestore.firestore()
    static var db = Firestore.firestore()
    
    static func currentUser(complete: @escaping (_ user: User) -> Void) -> Void {
        if Storage.currentUserID != nil {
            self.get(Storage.currentUserID ?? "") { user in
                complete(user)
            }
        } else {
            complete(User())
        }
    }
    
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
                let avatarURL = data?["avatarURL"] as? String
                let company = data?["company"] as? String
                let position = data?["position"] as? String
                let about = data?["about"] as? String
                
                let user = User()
                user.firstName = first ?? ""
                user.lastName = last ?? ""
                user.email = email ?? ""
                user.userID = userID ?? ""
                user.role = role ?? ""
                user.avatarURL = avatarURL ?? ""
                user.company = company ?? ""
                user.position = position ?? ""
                user.about = about ?? ""
                
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
        avatarURL = ""
        company = ""
        position = ""
        about = ""
    }
    
    init(_ userID: String, _ firstName: String, _ lastName: String, _ avatarURL: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = ""
        self.role = ""
        self.avatarURL = avatarURL
        self.company = ""
        self.position = ""
        self.about = ""
    }
    
    func save() -> Void {
        self.db.collection("users").document(self.userID).setData([
            "userID": self.userID,
            "first": self.firstName,
            "last": self.lastName,
            "email": self.email,
            "avatarURL": self.avatarURL
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
        case "role", "company", "position", "about":
            self.db.collection("users").document(self.userID).setData([field: value], merge: true) { err in
                if let err = err {
                    print("Error updating \(field) for: \(self.userID)")
                    print("Error message \(err)")
                } else {
                    print("Updated \(self.userID) \(field) to \(value)")
                }
            }
        default:
            return
        }
    }
    
}
