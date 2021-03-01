//
//  ProfilePageViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/25/21.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        userImage.layer.shadowOpacity = 0.5
        userImage.layer.shadowRadius = 5
        userImage.layer.shadowOffset = .zero


        topView.layer.cornerRadius = 10
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowPath = UIBezierPath(rect: topView.bounds).cgPath
        topView.layer.shadowRadius = 8
        topView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)


        aboutView.layer.cornerRadius = 10
        aboutView.layer.shadowOpacity = 0.5
        aboutView.layer.shadowPath = UIBezierPath(rect: aboutView.bounds).cgPath
        aboutView.layer.shadowRadius = 8
        aboutView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        aboutText.text = "Entrepreneur and professor, research interests include computer security, financial fraud, and digital identity. As a professor, I made fundamental contributions to computer security. You can find more information, including articles in the popular press here: https://bob.cs.ucdavis.edu/research.html. And here is a lecture I gave about some of my research in hardware security: http://vimeo.com/23836967. And here is a link to my academic website, which includes my full publication list (in case you are having trouble sleeping: https://bob.cs.ucdavis.edu/publications.html"
        requestBtn.layer.cornerRadius = 5
        requestBtn.layer.shadowOpacity = 0.5
        requestBtn.layer.shadowRadius = 5
        requestBtn.layer.shadowOffset = .zero

    }
    

    
    


}
