//
//  AboutMenteeViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 3/7/21.
//

import UIKit

class AboutMenteeViewController: UIViewController {

    @IBOutlet weak var schoolTextFeild: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        User.currentUser() { user in
            user.update(field: "company", value: self.schoolTextFeild.text ?? "")
            user.update(field: "position", value: self.majorTextField.text ?? "")
            user.update(field: "about", value: self.aboutTextField.text ?? "")
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "questionareViewController") as? QuestionaresViewController else
            {
                assertionFailure("couldn't find vc")
                return
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
