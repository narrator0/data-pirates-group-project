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
        var mentorID: String = ""
        var menteeIDs: [String] = []
        var requesteeIDs: [String] = []
        var mentees: [User] = []
        var requestees: [User] = []
    }
    
    private init(){
        guard let _ = MentorRequests.requests else {
               fatalError("Error - you must call update at least once")
           }
    }
        
    class func update(_ userID: String = "") {
        MentorRequests.requests?.mentees = []
        MentorRequests.requests?.requestees = []
        MentorRequests.requests?.menteeIDs = []
        MentorRequests.requests?.requesteeIDs = []
        var m: [String] = []
        var l = "the"
        let semaphore = DispatchSemaphore(value: 0)
        if (userID != "") {
            MentorRequests.requests?.mentorID = userID
        }
        let db = Firestore.firestore()
        db.collection("mentorStatus").whereField("mentorID", isEqualTo: MentorRequests.requests?.mentorID as Any).whereField("accepted", isEqualTo: true)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let documents = querySnapshot?.documents{
                        for document in documents {
                            if let menteeID = document.data()["menteeID"] as? String {
                             
                                User.get(menteeID) {
                                    userRecord in
                                    MentorRequests.requests?.mentees.append(userRecord)
                               
                                }
                            }
                        }
                        }
                     
            
                        
                    }
            }



    
        
        db.collection("mentorStatus").whereField("mentorID", isEqualTo: MentorRequests.requests?.mentorID as Any).whereField("accepted", isEqualTo: false)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let documents = querySnapshot?.documents{
                        for document in documents {
                            if let menteeID = document.data()["menteeID"] as? String {
                                User.get(menteeID) {
                                    userRecord in
                                    MentorRequests.requests?.requestees.append(userRecord)
                                }
                            }
                        }
                        }
                    }
            }
        

    }
    
    
    func deleteRequest(_ menteeID: String) {
        db.collection("mentorStatus").whereField("mentorID", isEqualTo: MentorRequests.requests?.mentorID as Any).whereField("menteeID", isEqualTo: menteeID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting document: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
        }
        
    }
    
    func getRequestsIDs() -> [String] {
        if let requests = MentorRequests.requests?.menteeIDs {
            return requests
        }
        else {
            return []
        }
    }
    
    func getID() -> String {
       
        if let mentorID = MentorRequests.requests?.mentorID {
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
