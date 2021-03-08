//
//  AboutMentorViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 3/7/21.
//

import UIKit

class AboutMentorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var aboutTextField: UILabel!
    
    var companyList = ["Facebook", "Apple", "Amazon", "Netflix", "Google"]
    var raceList = ["Prefer not to answer", "White", "Asian", "Black or African American", "Native Hawaiian or Other Pacific Islander", "American Indian or Alaska Native"]
    var genderList = ["Prefer not to answer", "Male", "Female"]
    var yearList = ["Prefer not to answer", "1-3 yrs", "4-9 yrs", "10+ yrs"]
    
    var companyPickerView = UIPickerView()
    var racePickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    var yearPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyTextField.inputView = companyPickerView
        raceTextField.inputView = racePickerView
        genderTextField.inputView = genderPickerView
        yearTextField.inputView = yearPickerView
        
        companyTextField.text = self.companyList[0]
        raceTextField.text = self.raceList[0]
        genderTextField.text = self.genderList[0]
        yearTextField.text = self.yearList[0]
        
        companyPickerView.delegate = self
        companyPickerView.dataSource = self
        racePickerView.delegate = self
        racePickerView.dataSource = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        companyPickerView.tag = 1
        racePickerView.tag = 2
        genderPickerView.tag = 3
        yearPickerView.tag = 4
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return companyList.count
        case 2:
            return raceList.count
        case 3:
            return genderList.count
        case 4:
            return yearList.count
    
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return companyList[row]
        case 2:
            return raceList[row]
        case 3:
            return genderList[row]
        case 4:
            return yearList[row]
    
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            companyTextField.text = companyList[row]
            companyTextField.resignFirstResponder()
        case 2:
            raceTextField.text = raceList[row]
            raceTextField.resignFirstResponder()
        case 3:
            genderTextField.text = genderList[row]
            genderTextField.resignFirstResponder()
        case 4:
            yearTextField.text = yearList[row]
            yearTextField.resignFirstResponder()
    
        default:
            return
        }
    }
    
  
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let company = self.companyTextField.text ?? "No Preference"
        let race = self.raceTextField.text ?? "No Preference"
        let gender = self.genderTextField.text ?? "No Preference"
        let years = self.yearTextField.text ?? "No Preference"
        
        User.currentUser() { user in
            user.update(field: "company", value: company)
            user.update(field: "race", value: race)
            user.update(field: "gender", value: gender)
            user.update(field: "years", value: years)
            user.update(field: "position", value: self.positionTextField.text ?? "")
            user.update(field: "about", value: self.aboutTextField.text ?? "")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mainTabController = storyboard.instantiateViewController(withIdentifier: "mainTabViewController") as? MainTabController else
            {
                assertionFailure("couldn't find vc")
                return
            }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabController)
        }

    }

}
