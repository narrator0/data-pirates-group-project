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

    @IBOutlet weak var buttonGo: UIButton!
    
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        self.navigationController?.navigationBar.isHidden = true
        
        // for button shape
        self.buttonGo.layer.cornerRadius = 5
        // for button shadow
        self.buttonGo.layer.shadowColor = UIColor.black.cgColor
        self.buttonGo.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.buttonGo.layer.shadowRadius = 8
        self.buttonGo.layer.shadowOpacity = 0.5
        
        // tab bar for the login page should be hidden
        self.tabBarController?.tabBar.isHidden = true
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
                            self.handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
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
        LinkedInOAuth.getAccessToken(code: linkedInAuthorizationCode) { token in
            LinkedInOAuth.getUserProfile(token: token) { user in
                // login success
                User.get(user.userID) { userRecord in
                    if userRecord.userID == "" || userRecord.role == "" {
                        print("first time login")
                        user.save()
                        self.goToFirstTimeLoginView(user)
                    } else {
                        self.goToHome()
                    }
                }
            }
        }
    }
    
    func goToFirstTimeLoginView(_ user: User) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        guard let firstTimeViewController = storyboard.instantiateViewController(withIdentifier: "firstTimeViewController") as? FirstTimeLoginViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        
        firstTimeViewController.user = user
        navigationController?.pushViewController(firstTimeViewController, animated: true)
    }

    func goToHome() {
        // login should go to home vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabController = storyboard.instantiateViewController(withIdentifier: "mainTabViewController") as? MainTabController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabController)
    }
}
