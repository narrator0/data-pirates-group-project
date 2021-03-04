//
//  FirstTimeLoginFormViewController.swift
//  ReferralPlease
//
//  Created by arfullight on 3/1/21.
//

import UIKit

class FirstTimeLoginFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    @IBOutlet weak var companyDrop: UIButton!
    @IBOutlet weak var raceDrop: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var raceTableView: UITableView!
    var companyList = ["FAANG", "No Preference"]
    var raceList = ["White", "Asian", "Black or African American", "Native Hawaiian or Other Pacific Islander", "American Indian or Alaska Native"]
    var user: User?
    var company: String = ""
    var race: String = ""

//    @IBOutlet weak var companyTextField: UITextField!
//    @IBOutlet weak var positionTextField: UITextField!
//    @IBOutlet weak var aboutTextField: UITextField!
//
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
//        tableView.tableFooterView = UIView()
        
        raceTableView.dataSource = self
        raceTableView.delegate = self
        raceTableView.isHidden = true
//        raceTableView.tableFooterView = UIView()
//

        // Do any additional setup after loading the view.

   }
    @IBAction func onClickDropCompany(_ sender: Any) {
        if tableView.isHidden {
            animate(true, companyDrop)
        } else {
            animate(false, companyDrop)
        }
    }
    @IBAction func onClickDropRace(_ sender: Any) {
        if raceTableView.isHidden {
            animate(true, raceDrop)
        } else {
            animate(false, raceDrop)
        }
    }
    
    func animate(_ toggle: Bool, _ type: UIButton){
        print("type", type.titleLabel ?? "")
        print(type == companyDrop)
        if type == companyDrop {
            if toggle {
                toggleTable(tableView, false)
            } else {
                toggleTable(tableView, true)
            }
        } else {
            if toggle {
                toggleTable(raceTableView, false)
            } else {
                toggleTable(raceTableView, true)
            }
        }
        
        
    }
    
    func toggleTable(_ table: UITableView, _ isHidden: Bool){
        UIView.animate(withDuration: 0.3){
            table.isHidden = isHidden
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            print("Count,",  companyList.count)
            return companyList.count
        } else {
            print("Count,",  raceList.count)
            return raceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.tableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath)
                cell.textLabel?.text = companyList[indexPath.row]

                return cell
        } else if tableView == self.raceTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "raceCell", for: indexPath)
                cell.textLabel?.text = raceList[indexPath.row]

                return cell
        }

        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView,
              didSelectRowAt indexPath: IndexPath) {
        print("here")

        if tableView == self.tableView {
            companyDrop.setTitle("\(companyList[indexPath.row])", for: .normal)
            animate(false, companyDrop)
            self.company = companyList[indexPath.row]
            print("Company", self.company)
        } else {
            raceDrop.setTitle("\(raceList[indexPath.row])", for: .normal)
            animate(false, raceDrop)
            self.race = raceList[indexPath.row]
            print("Race", self.race)        }
        
       
    }
    
    
    
    
    
    
    //    @IBAction func submitButtonPressed(_ sender: Any) {
//        let company = self.companyTextField.text ?? ""
//        let position = self.positionTextField.text ?? ""
//        let about = self.aboutTextField.text ?? ""
//
//        self.user?.update(field: "company", value: company)
//        self.user?.update(field: "position", value: position)
//        self.user?.update(field: "about", value: about)
//
//        // login should go to home vc
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let mainTabController = storyboard.instantiateViewController(withIdentifier: "mainTabViewController") as? MainTabController else
//        {
//            assertionFailure("couldn't find vc")
//            return
//        }
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabController)
//    }
    

    

}
