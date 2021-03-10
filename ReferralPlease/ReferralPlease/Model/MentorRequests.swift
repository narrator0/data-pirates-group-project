//
//  MentorRequests.swift
//  ReferralPlease
//
//  Created by Justin Lim on 3/1/21.
//

import Foundation
import Firebase

class MentorRequests {
    static let shared = MentorRequests()
    var db = Firestore.firestore()
    private static var requests:Requests? = Requests()
    
    struct Requests {
        var mentees: [User] = []
        var requestees: [User] = []
        var userID: String = ""
        var role: String = ""
        
    }
    
    private init(){
        guard let _ = MentorRequests.requests else {
               fatalError("Error - you must call update at least once")
           }
    }
        
    class func update() {
        MentorRequests.requests?.mentees = []
        MentorRequests.requests?.requestees = []
     
      
        User.currentUser() {
            userRecord in
            MentorRequests.requests?.userID = userRecord.userID
            MentorRequests.requests?.role = userRecord.role
        }
            if (MentorRequests.requests?.role == "mentor") {
                User.getAllStatus(MentorRequests.requests?.userID ?? "" , "mentorID", true ) {
            userRecords in
            print(userRecords)
            MentorRequests.requests?.mentees = userRecords
        }
        
                User.getAllStatus(MentorRequests.requests?.userID ?? "", "mentorID", false ) {
            userRecords in
            MentorRequests.requests?.requestees = userRecords
        }
        }
            else {
                User.getAllStatus(MentorRequests.requests?.userID ?? "" , "menteeID", true ) {
                    userRecords in
                    print(userRecords)
                    MentorRequests.requests?.mentees = userRecords
                }
                
                User.getAllStatus(MentorRequests.requests?.userID ?? "", "menteeID", false ) {
                    userRecords in
                    MentorRequests.requests?.requestees = userRecords
                }
            }
        }

    


    
    func deleteRequest(_ menteeID: String) {
        db.collection("mentorStatus").whereField("mentorID", isEqualTo: MentorRequests.requests?.userID as Any).whereField("menteeID", isEqualTo: menteeID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting document: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
        }
        
    }
    

    
    func getID() -> String {
       
        if let mentorID = MentorRequests.requests?.userID {
            return mentorID
        }
        else {
            return ""
        }
    }
    
    func getRequestees() -> [User] {
        if let requests = MentorRequests.requests?.requestees {
            return requests
        }
        else {
            return []
        }
    }
    
    
    func getMentees() -> [User] {
        if let requests = MentorRequests.requests?.mentees {
            return requests
        }
        else {
            return []
        }
    }
    
    
    static func createRequest(_ mentorID: String, _ menteeID: String) {
        let db = Firestore.firestore()
        db.collection("mentorStatus").document(mentorID + menteeID).setData([
            "menteeID": menteeID,
            "mentorID": mentorID,
            "accepted": false
        ], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
        
    }
    
}
