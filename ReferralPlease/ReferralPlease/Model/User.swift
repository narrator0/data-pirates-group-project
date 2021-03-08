//
//  User.swift
//  ReferralPlease
//
//  Created by arfullight on 2/28/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class User {
    var userID: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var avatarURL: String = ""
    
    var company: String = ""
    var position: String = ""
    var about: String = ""
    var race: String = ""
    var gender: String = ""
    var years: String = ""
    
    var companyPreference: String = ""
    var racePreference: String = ""
    var genderPreference: String = ""
    var yearsPreference: String = ""
    
    var role: String = ""
    
    var db = Firestore.firestore()
    static var db = Firestore.firestore()
    
    static func getAll(complete: @escaping (_ currUsers: [User]) -> Void) -> Void {
        // dispatch queue
        var mentors: [User] = []
        db.collection("users").whereField("role", isEqualTo: "mentor").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting doc on user: \(err)")
                
                DispatchQueue.main.async {
                    complete([])
                }
            } else {
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let user = User()
                        user.firstName = data["first"] as? String ?? ""
                        user.lastName = data["last"] as? String ?? ""
                        user.userID = data["userID"] as? String ?? ""
                        user.role = data["role"] as? String ?? ""
                        user.email = data["email"] as? String ?? ""
                        user.company = data["company"] as? String ?? ""
                        user.position = data["position"] as? String ?? ""
                        user.about = data["about"] as? String ?? ""
                        user.avatarURL = data["avatarURL"] as? String ?? ""
                        user.race = data["race"] as? String ?? ""
                        user.gender = data["gender"] as? String ?? ""
                        user.years = data["years"] as? String ?? ""
                        
                        user.companyPreference = data["companyPreference"] as? String ?? ""
                        user.racePreference = data["racePreference"] as? String ?? ""
                        user.genderPreference = data["genderPreference"] as? String ?? ""
                        user.yearsPreference = data["yearsPreference"] as? String ?? ""
                        
                        mentors.append(user)
                    }
                }
                
                DispatchQueue.main.async {
                    complete(mentors)
                }
            }
        }
    }

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
                let user = User()
                user.firstName = data?["first"] as? String ?? ""
                user.lastName = data?["last"] as? String ?? ""
                user.userID = data?["userID"] as? String ?? ""
                user.role = data?["role"] as? String ?? ""
                user.email = data?["email"] as? String ?? ""
                user.company = data?["company"] as? String ?? ""
                user.position = data?["position"] as? String ?? ""
                user.about = data?["about"] as? String ?? ""
                user.avatarURL = data?["avatarURL"] as? String ?? ""
                user.race = data?["race"] as? String ?? ""
                user.gender = data?["gender"] as? String ?? ""
                user.years = data?["years"] as? String ?? ""
                
                user.companyPreference = data?["companyPreference"] as? String ?? ""
                user.racePreference = data?["racePreference"] as? String ?? ""
                user.genderPreference = data?["genderPreference"] as? String ?? ""
                user.yearsPreference = data?["yearsPreference"] as? String ?? ""
                
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
    }
    
    init(_ userID: String, _ firstName: String, _ lastName: String, _ avatarURL: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
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
        case "role", "company", "position", "about", "race", "gender", "years", "companyPreference", "racePreference", "genderPreference", "yearsPreference":
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
    
    func matchMentor(complete: @escaping (_ mentor: User) -> Void) -> Void {
        User.getAll() { mentors in
            var found = false
            for mentor in mentors {
                if (
                    self.companyPreference == mentor.company &&
                    self.racePreference == mentor.race &&
                    self.genderPreference == mentor.gender &&
                    self.yearsPreference == mentor.years
                ) {
                    found = true
                    DispatchQueue.main.async {
                        complete(mentor)
                    }
                    break
                }
            }
            
            if !found {
                let mentor = mentors[Int.random(in: 0..<(mentors.count))]
                DispatchQueue.main.async {
                    complete(mentor)
                }
            }
        }
    }
}
