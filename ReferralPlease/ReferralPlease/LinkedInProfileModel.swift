//
//  LinkedInProfileModel.swift
//  ReferralPlease
//
//  Created by Jessica Lo on 2/23/21.
//

import Foundation

// MARK: - LinkedInProfileModel
struct LinkedInProfileModel: Codable {
    let firstName, lastName: StName
    let id: String
}

// MARK: - StName
struct StName: Codable {
    let localized: Localized
}

// MARK: - Localized
struct Localized: Codable {
    let enUS: String

    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
    }
}


