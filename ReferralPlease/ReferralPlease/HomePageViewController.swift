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
        MentorRequests.setup("sample2")

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
    
        return cell
    }

}
