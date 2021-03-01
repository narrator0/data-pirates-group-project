//
//  ProfilePageViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/25/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class ProfilePageViewController: UIViewController {
<<<<<<< Updated upstream

    override func viewDidLoad() {
        super.viewDidLoad()
=======
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    
    
    var db: Firestore?
    
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var userImage: UIImageView!
//    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var aboutView: UIView!
//    @IBOutlet weak var aboutText: UILabel!
//    @IBOutlet weak var requestBtn: UIButton!
    //    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var userDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
//        let contentWidth = scrollView.bounds.width
//        let contentHeight = scrollView.bounds.height * 3
//        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
//
        guard let currUserID = UserData.currentUserID else {
            assertionFailure("couldn't find user ID")
            return
        }
        let docRef = db?.collection("users").document(currUserID)
        
        
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            
                guard let firstname = document.get("first") as? String else {return}
                guard let lastname = document.get("last") as? String else {return}
                self.userName.text = firstname + " " + lastname
            } else {
                print("Document does not exist")
            }
        }
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor.black.cgColor

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
        requestBtn.layer.cornerRadius = 10
        requestBtn.layer.shadowOpacity = 0.5
//        requestBtn.layer.shadowPath = UIBezierPath(rect: topView.bounds).cgPath
        requestBtn.layer.shadowRadius = 5
        requestBtn.layer.shadowOffset = .zero
        
//        table.dataSource = self
//        table.delegate = self
//
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.blue
//        table.tableHeaderView = headerView
>>>>>>> Stashed changes

        // Do any additional setup after loading the view.
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
