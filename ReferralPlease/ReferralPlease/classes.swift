//
//  classes.swift
//  ReferralPlease
//
//  Created by Jessica Lo on 2/28/21.
//

import Foundation

struct UserData {
    static var currentUserToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentUserToken")
        }
        
        set(currentUserToken) {
            UserDefaults.standard.set(currentUserToken, forKey: "currentUserToken")
            print("Saving the currentUserToken: \(UserDefaults.standard.synchronize())")
        }
    }
    
    static var currentUserID: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentUserID")
        }
        
        set(currentUserID) {
            UserDefaults.standard.set(currentUserID, forKey: "currentUserID")
            print("Saving the currentUserID: \(UserDefaults.standard.synchronize())")
        }
    }
    
}
