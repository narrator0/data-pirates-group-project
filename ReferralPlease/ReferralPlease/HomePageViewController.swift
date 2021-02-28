//
//  HomePageViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/24/21.
//

import UIKit

class HomePageViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        print("home page view called")

//        guard let mainTabController = storyboard?.instantiateViewController(withIdentifier: "mainTabController") as? MainTabController else
//        {
//            assertionFailure("couldn't find vc")
//            return
//        }
//        mainTabController.selectedViewController = mainTabController.viewControllers?[0]
//        present(mainTabController, animated: true, completion: nil)
        
//        guard let mainTabController = storyboard?.instantiateViewController(withIdentifier: "mainTabController") as? MainTabController else
//        {
//            assertionFailure("couldn't find vc")
//            return
//        }
//        mainTabController.selectedViewController = mainTabController.viewControllers?[0]
//        present(mainTabController, animated: true, completion: nil)
//        UIImageView(frame: CGRectMake(0, 0, 100, 100))


        // Do any additional setup after loading the view.
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        cell.layer.cornerRadius = 5
        cell.userName.text = "test user name"
        cell.userDescription.text = "user description"
        cell.profileImage.image = UIImage(named: "image1")
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
        
//        cell.profileImage.layer.borderWidth = 1
//        cell.profileImage.layer.borderColor = UIColor.blue.cgColor
        return cell
    }

}
