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
    let profilePicture: ProfilePicture
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

// MARK: - ProfilePicture
struct ProfilePicture: Codable {
    let displayImage: DisplayImage

    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

// MARK: - DisplayImage
struct DisplayImage: Codable {
    let elements: [ProfilePicElement]
}

// MARK: - Element
struct ProfilePicElement: Codable {
    let identifiers: [ProfilePicIdentifier]
}

// MARK: - Identifier
struct ProfilePicIdentifier: Codable {
    let identifier: String
}
