//
//  MentorRequests.swift
//  ReferralPlease
//
//  Created by Justin Lim on 3/1/21.
//

import Foundation
import Firebase

class MentorRequests {
    // Singleton
    static let shared = MentorRequests()
    var db = Firestore.firestore()
    private static var requests:Requests? = Requests()
    
    struct Requests {
        var mentorID: String = ""
        var menteeIDs: [String] = []
    }
    
    private init(){
        guard let _ = MentorRequests.requests else {
               fatalError("Error - you must call setup before accessing MySingleton.shared")
           }
    }
        
    class func setup(_ userID: String) {
        MentorRequests.requests?.mentorID = userID
        let db = Firestore.firestore()
        db.collection("mentorStatus").whereField("mentorID", isEqualTo: MentorRequests.requests?.mentorID as Any)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let menteeID = document.data()["menteeID"] as? String {
                                MentorRequests.requests?.menteeIDs.append(menteeID)
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
    
    
    static func createStatus(_ mentorID: String, _ menteeID: String) {
        let db = Firestore.firestore()
        db.collection("mentorStatus").document().setData([
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
