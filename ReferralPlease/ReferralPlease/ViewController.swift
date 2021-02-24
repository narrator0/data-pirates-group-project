//
//  ViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 2/18/21.
//

import UIKit
import WebKit
import Firebase
import FirebaseCore
import FirebaseFirestore


class ViewController: UIViewController {

    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var clickRegister: UIButton!
    
    @IBOutlet weak var clickResetPass: UIButton!
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        self.navigationController?.navigationBar.isHidden = true
        self.buttonGo.layer.cornerRadius = 5
        textPhoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textPhoneNumber.frame.height))
        textPhoneNumber.leftViewMode = .always
        textPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textPassword.frame.height))
        textPassword.leftViewMode = .always
    }
    
    
    @IBAction func clickCreateAccountLabel(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let createAccountVC = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as? CreateAccountViewController else{
            assertionFailure("couldn't find vc")
            return
        }
        if let nav = self.navigationController {
            nav.pushViewController(createAccountVC, animated: true)
        } else {
            assertionFailure("no nav controller")
        }
    }
    
    
    @IBAction func linkedInLoginBtnAction(_ sender: Any) {
        linkedInAuthVC()
    }
    
    
    var webView = WKWebView()
    func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
            ])

        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"

        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI

        if let url = URL.init(string: authURLFull){
            let urlRequest = URLRequest.init(url: url)
            webView.load(urlRequest)
        }
        else {
            print("Invalid URL")
        }

        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical

        self.present(navController, animated: true, completion: nil)
    }

    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func refreshAction() {
        self.webView.reload()
    }


}

extension ViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }

    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        if let requestURLString = (request.url?.absoluteString) {
            if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
                if requestURLString.contains("?code=") {
                    if let range = requestURLString.range(of: "=") {
                        let linkedinCode = requestURLString[range.upperBound...]
                        if let range = linkedinCode.range(of: "&state=") {
                            let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                            handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                        }
                    }
                }
            }
        }
        else {
            print("Invalid Callback URL")
        }
        

    }

    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }

    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"

        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        if let url = URL(string: LinkedInConstants.TOKENURL) {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postData
            request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                do {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if statusCode == 200 {
                    if let jsonData = data{
                    let results = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [AnyHashable: Any]

                    let accessToken = results?["access_token"] as? String
                        print("accessToken is: \(accessToken ?? "")")

                    let expiresIn = results?["expires_in"] as? Int
                        print("expires in: \(expiresIn ?? nil)")

                    // Get user's id, first name, last name, profile pic url
                        if let access = accessToken{
                    self.fetchLinkedInUserProfile(accessToken: access)
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
    
    func fetchLinkedInUserProfile(accessToken: String) {
            let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                guard let verify: NSURL = NSURL(string: tokenURLFull ?? "") else {
                    print("Invalid URL")
                    return}
   
            let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error == nil {
                    guard let jsonData = data else {
                        print("No data found")
                        return
                    }
                    let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: jsonData)
                    
                    
                    var ref: DocumentReference? = nil
                    ref = self.db?.collection("users").addDocument(data: [
                        "userID": linkedInProfileModel?.id,
                        "first": linkedInProfileModel?.firstName.localized.enUS,
                        "last": linkedInProfileModel?.lastName.localized.enUS
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID")
                        }
                    }

                    
                    //AccessToken
                    print("LinkedIn Access Token: \(accessToken)")
                    
//                    // LinkedIn Id
//                    let linkedinId: String! = linkedInProfileModel?.id
//                    print("LinkedIn Id: \(linkedinId ?? "")")
//
//                    // LinkedIn First Name
//                    let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
//                    print("LinkedIn First Name: \(linkedinFirstName ?? "")")
//
//                    // LinkedIn Last Name
//                    let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
//                    print("LinkedIn Last Name: \(linkedinLastName ?? "")")
//
//                    // LinkedIn Profile Picture URL
//                    let linkedinProfilePic: String!

                    /*
                     Change row of the 'elements' array to get diffrent size of the profile url
                     elements[0] = 100x100
                     elements[1] = 200x200
                     elements[2] = 400x400
                     elements[3] = 800x800
                    */
//                    if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
//                        linkedinProfilePic = pictureUrls
//                    } else {
//                        linkedinProfilePic = "Not exists"
//                    }
//                    print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")

                    // Get user's email address
                    self.fetchLinkedInEmailAddress(accessToken: accessToken)
                }
            }
            task.resume()
        }

        func fetchLinkedInEmailAddress(accessToken: String) {
            let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
                    let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                    print("LinkedIn Email: \(linkedinEmail ?? "")")

                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "detailseg", sender: self)
                    }
                }
            }
            task.resume()
        }
}
