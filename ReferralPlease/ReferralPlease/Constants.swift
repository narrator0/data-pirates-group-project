//
//  Constants.swift
//  ReferralPlease
//
//  Created by Jessica Lo on 2/23/21.
//

import Foundation

struct LinkedInConstants {
    
    static let CLIENT_ID = "868ukbcl4ehxa1"
    static let CLIENT_SECRET = "••••••••••••••••"
    static let REDIRECT_URI = "https://data-pirates.linkedin.oauth/oauth"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}
