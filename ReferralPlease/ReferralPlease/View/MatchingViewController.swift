//
//  MatchingViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 3/5/21.
//

import UIKit
import SDWebImage

class MatchingViewController: UIViewController {
    
    var mentor: User?

    @IBOutlet weak var matchingLabel: UILabel!
    @IBOutlet weak var matchingBtn: UIButton!
    @IBOutlet weak var mentorNameLabel: UILabel!
    @IBOutlet weak var mentorSubtitle: UILabel!
    @IBOutlet weak var mentorImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        matchingLabel.text = "Congratulations! \n We find your matching mentor!"
        matchingBtn.layer.cornerRadius = 5
        matchingBtn.layer.shadowOpacity = 0.5
        matchingBtn.layer.shadowRadius = 5
        matchingBtn.layer.shadowOffset = .zero
        
        self.mentorImage.layer.cornerRadius = self.mentorImage.frame.size.width / 2
        self.mentorImage.clipsToBounds = true
        self.mentorImage.layer.shadowOpacity = 0.5
        self.mentorImage.layer.shadowRadius = 5
        self.mentorImage.layer.shadowOffset = .zero

        // Do any additional setup after loading the view.
        
        User.currentUser() { user in
            user.matchMentor() { mentor in
                self.mentor = mentor
                
                self.mentorImage.sd_setImage(with: URL(string: mentor.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
                self.mentorNameLabel.text = "\(mentor.firstName) \(mentor.lastName)"
                self.mentorSubtitle.text = "\(mentor.company) @ \(mentor.position)"
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // login should go to home vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabController = storyboard.instantiateViewController(withIdentifier: "mainTabViewController") as? MainTabController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabController)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
