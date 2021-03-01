//
//  LinkedInOAuth.swift
//  ReferralPlease
//
//  Created by arfullight on 2/28/21.
//

import Foundation

struct LinkedInOAuth {
    static func getSTName(data: StName) -> String {
        if data.preferredLocale.country == "US" {
            return data.localized.enUS ?? ""
        }
        else if data.preferredLocale.country == "TW" {
            return data.localized.zhTW ?? ""
        }
        
        return ""
    }
    
    static func getUserEmail(token: String, user: User, complete: @escaping (_ user: User) -> Void) -> Void {
        let tokenURLFull = (
            "https://api.linkedin.com/v2/emailAddress?" +
            "q=members&projection=(elements*(handle~))&" +
            "oauth2_access_token=\(token)"
        ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let verify: NSURL = NSURL(string: tokenURLFull ?? "") else {
            print("Invalid NSURL")
            return
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                guard let jsonData = data else {
                    print("No data found")
                    return
                }
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: jsonData)

                // LinkedIn Email
                let email = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                user.email = email ?? ""
                
                DispatchQueue.main.async {
                    complete(user)
                }
            }
        }
        task.resume()
    }
    
    static func getUserProfile(token: String, complete: @escaping (_ user: User) -> Void) -> Void {
        let tokenURLFull = (
            "https://api.linkedin.com/v2/me?" +
            "projection=(id,firstName,lastName,profilePicture,emailAddress(displayImage~:playableStreams))&" +
            "oauth2_access_token=\(token)"
        ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let verify: NSURL = NSURL(string: tokenURLFull ?? "") else {
            print("Invalid URL")
            return
        }

        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                guard let jsonData = data else {
                    print("No data found")
                    return
                }
                
                do {
                    let linkedInProfileModel = try JSONDecoder().decode(LinkedInProfileModel.self, from: jsonData)
                    let firstName = self.getSTName(data: linkedInProfileModel.firstName)
                    let lastName = self.getSTName(data: linkedInProfileModel.lastName)
                    let userID = linkedInProfileModel.id
                    
                    Storage.currentUserID = userID
                    
                    let user = User(userID, firstName, lastName)
                    
                    self.getUserEmail(token: token, user: user, complete: complete)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
        task.resume()
    }
    
    static func getAccessToken(code: String, complete: @escaping (_ token: String) -> Void) -> Void {

        // Set the POST parameters.
        let postParams = (
            "grant_type=authorization_code&code=\(code)&" +
            "redirect_uri=\(LinkedInConstants.REDIRECT_URI)&" +
            "client_id=\(LinkedInConstants.CLIENT_ID)&" +
            "client_secret=\(LinkedInConstants.CLIENT_SECRET)"
        ).data(using: .utf8)

        if let url = URL(string: LinkedInConstants.TOKENURL) {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postParams
            request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                do {
                    let response = response as? HTTPURLResponse
                    let statusCode = response?.statusCode
                    if statusCode == 200 {
                        if let jsonData = data {
                            let results = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [AnyHashable: Any]

                            let accessToken = results?["access_token"] as? String
                            print("accessToken is: \(accessToken ?? "")")

                            // Get user's id, first name, last name, profile pic url
                            if let accessToken = accessToken {
                                Storage.currentUserToken = accessToken
                                DispatchQueue.main.async {
                                    complete(accessToken)
                                }
                            }
                            else {
                                print("Invalid access token")
                            }
                        }
                    }
                }
                catch {
                    print("Session Error")
                }
            }
            task.resume()
        }
        else {
            print("Invalid URL")
        }
    }
}
