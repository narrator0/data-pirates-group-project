//
//  MatchingViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 3/5/21.
//

import UIKit

class MatchingViewController: UIViewController {

    @IBOutlet weak var matchingLabel: UILabel!
    @IBOutlet weak var matchingBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        matchingLabel.text = "Congratulations! \n We find your matching mentor..."
        matchingBtn.layer.cornerRadius = 5
        matchingBtn.layer.shadowOpacity = 0.5
        matchingBtn.layer.shadowRadius = 5
        matchingBtn.layer.shadowOffset = .zero

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
