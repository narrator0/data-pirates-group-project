//
//  FirstTimeLoginFormViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 3/1/21.
//

import UIKit

class FirstTimeLoginFormViewController: UIViewController {
    
    var user: User?
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        let company = self.companyTextField.text ?? ""
        let position = self.positionTextField.text ?? ""
        let about = self.aboutTextField.text ?? ""
        
        self.user?.update(field: "company", value: company)
        self.user?.update(field: "position", value: position)
        self.user?.update(field: "about", value: about)
        
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
