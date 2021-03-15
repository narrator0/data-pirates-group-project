//
//  ProfilePageViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/25/21.
//

import UIKit
import SDWebImage

class ProfilePageViewController: UIViewController {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var userPositionTextField: UITextField!
    @IBOutlet weak var userCompanyTextField: UITextField!
    var user = User()
    var isPublic = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        userImage.layer.shadowOpacity = 0.5
        userImage.layer.shadowRadius = 5
        userImage.layer.shadowOffset = .zero


        topView.layer.cornerRadius = 10
        topView.layer.shadowOpacity = 0.25
        topView.layer.shadowRadius = 7.0
        topView.layer.shadowOffset = CGSize(width: 0, height: 6.0)


        aboutView.layer.cornerRadius = 10
        aboutView.layer.shadowOpacity = 0.25
//        aboutView.layer.shadowPath = UIBezierPath(rect: aboutView.bounds).cgPath
        aboutView.layer.shadowRadius = 7.0
        aboutView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        aboutText.text = "Entrepreneur and professor, research interests include computer security, financial fraud, and digital identity. As a professor, I made fundamental contributions to computer security. You can find more information, including articles in the popular press here: https://bob.cs.ucdavis.edu/research.html. And here is a lecture I gave about some of my research in hardware security: http://vimeo.com/23836967. And here is a link to my academic website, which includes my full publication list (in case you are having trouble sleeping: https://bob.cs.ucdavis.edu/publications.html"
        requestBtn.layer.cornerRadius = 5
        requestBtn.layer.shadowOpacity = 0.5
        requestBtn.layer.shadowRadius = 5
        requestBtn.layer.shadowOffset = .zero
        
        self.userPositionTextField.borderStyle = .none
        self.userCompanyTextField.borderStyle = .none
        
        if self.isPublic {
            
            self.renderText()
            User.currentUser() { user in
                if (user.role == "mentee" && self.user.role == "mentor") {
                    self.requestBtn.isHidden = false
                }
                
            }
        }
        else {
            User.currentUser() { user in
                self.user = user
                self.renderText()
            }
        }
        
        changeButtonTitle()
        // change the color of the navigation back button
        self.navigationController?.navigationBar.tintColor = .orange
    }
    
    func renderText() {
        self.userNameText.text = "\(self.user.firstName) \(self.user.lastName)"
        self.userImage.sd_setImage(with: URL(string: self.user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
        self.userCompanyTextField.text = self.user.company
        self.userPositionTextField.text = self.user.position
        self.aboutText.text = self.user.about
    }
    
    @IBAction func sendRequest() {
        if (MentorRequests.shared.getMentees().contains(self.user)) {
            if let url = URL(string: "mailto:\(self.user.email)") {
                UIApplication.shared.open(url)

            }
        }
        else {
            User.currentUser() { user in
                MentorRequests.createRequest(self.user.userID, user.userID)
            }
            
            changeButtonTitle()
        }
 
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as? SettingsViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeButtonTitle() {
        MentorRequests.update()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            print(MentorRequests.shared.getRequestees().count)
            print(MentorRequests.shared.getMentees().count)
            
        if (MentorRequests.shared.getRequestees().contains(self.user)) {
            self.requestBtn.setTitle("Request sent", for: .normal)
            self.requestBtn.isUserInteractionEnabled = false
            
        }
        else if (MentorRequests.shared.getMentees().contains(self.user)){
            self.requestBtn.setTitle("Send email", for: .normal)
            
        }
    }
    }
}
