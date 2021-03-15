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
    let profilePicture: ProfilePicture?
}

struct ProfilePicture: Codable {
    let displayImage: DisplayImage?
    
    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

struct DisplayImage: Codable {
    let elements: [Elementt]
}

struct Elementt: Codable {
    let identifiers: [Identifier]
}

struct Identifier: Codable {
    let identifier: String
}

struct PreferredLocale: Codable {
    let country: String
    let language: String
}

// MARK: - StName
struct StName: Codable {
    let localized: Localized
    let preferredLocale: PreferredLocale
}

// MARK: - Localized
struct Localized: Codable {
    let enUS: String?
    let zhTW: String?

    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
        case zhTW = "zh_TW"
    }
}

