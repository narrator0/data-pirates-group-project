//
//  QuestionaresViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 3/4/21.
//

import UIKit

class QuestionaresViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    var companyList = ["FAANG", "No Preference"]
    var raceList = ["White", "Asian", "Black or African American", "Native Hawaiian or Other Pacific Islander", "American Indian or Alaska Native", "No Preference"]
    var genderList = ["Male", "Female", "No Preference"]
    var yearList = ["1-3 yrs", "4-9 yrs", "10+ yrs",  "No Preference"]
    
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
        
        companyTextField.placeholder = "Select company"
        raceTextField.placeholder = "Select race and ethnicity"
        genderTextField.placeholder = "Select gender"
        yearTextField.placeholder = "Select year of experience"
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
