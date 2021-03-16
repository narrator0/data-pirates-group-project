//
//  HomePageViewController.swift
//  ReferralPlease
//
//  Created by Chloe Vo on 2/24/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import SDWebImage
import CoreLocation
import MapKit


class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate{
    var user: User?
    var db: Firestore?
    var currentUsers: [User] = []
    var nearbyUsers: [User] = []
    var currentlongitude: CLLocationDegrees = 0.0
    var currentLatitude: CLLocationDegrees = 0.0
    var currentLocation = CLLocation()
    var manager: CLLocationManager?

//    @IBOutlet var distanceSelection: [UIButton]!
//    @IBOutlet weak var nearmeButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nearmeButton: UIButton!
    
    @IBOutlet var distanceSelection: [UIButton]!
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        print("home page view called")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    

        MentorRequests.update()
        
        // dispatch queue
        User.getAll() { mentors in
            self.currentUsers = mentors
            self.tableView.reloadData()
//            print("Number of users: \(self.currentUsers.count)")

        }
        
        // distance btn setting
        distanceSelection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }
        
 
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else {
            return
        }
        
        self.currentlongitude = last.coordinate.longitude
        self.currentLatitude =  last.coordinate.latitude
                
        // save locations
        self.currentLocation = CLLocation(latitude: last.coordinate.latitude, longitude: last.coordinate.longitude)
//
        print("longitude \(self.currentlongitude); latitude \(self.currentLatitude)")
//        print("location: \(userLocation)")

        
        User.currentUser() { user in
            user.updateLocation(field: "longitude", value:  self.currentlongitude)
            user.updateLocation(field: "latitude", value: self.currentLatitude)

        }
        
        
    }

    func filterByMiles(miles: Double) {

        print("Number of users: \(self.currentUsers.count)")
        self.nearbyUsers = []

        User.getAll() { users in
            for user in users {
                print("longitude: \(user.longitude), Latitude: \(user.latitude)")
                
                let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
                let distance = self.currentLocation.distance(from: location) // in meters
                let distanceInMiles =  distance / 1609 // in meters

                print("Distance from currentLocation: \(distanceInMiles) miles")

                if distanceInMiles <= miles || miles == 0 {
                    self.nearbyUsers.append(user)
                }
            }
            print("Number of nearby users: \(self.nearbyUsers.count)")
            self.currentUsers = self.nearbyUsers
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentUsers.count
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
        
//        cell.layer.cornerRadius = 5
        let user = self.currentUsers[indexPath.row]
        let firstname = user.firstName
        let lastname = user.lastName
        cell.userName.text = firstname + " " + lastname
        cell.userDescription.text = user.company
        cell.profileImage.sd_setImage(with: URL(string: user.avatarURL), placeholderImage: UIImage(named: "placeholder.png"))
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
        cell.userPosition.text = user.position
        cell.layer.cornerRadius = 10
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowRadius = 7.0
        cell.layer.shadowOffset = CGSize(width: 0, height: 6.0)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "profilePageViewController") as? ProfilePageViewController else
        {
            assertionFailure("couldn't find vc")
            return
        }
        
        vc.user = self.currentUsers[indexPath.row]
        vc.isPublic = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 20

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        self.tableView.contentInset.bottom = -verticalPadding/2
        self.tableView.contentInset.top = -verticalPadding/2
    }
    
    @IBAction func distanceBtnPressed(_ sender: UIButton) {
        self.toggleDropdown()
    }
    
    
    @IBAction func distanceOptionsPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
            return
        }
        self.nearmeButton.setTitle(title, for: .normal)
        switch title {
        case "Within 10 miles":
            // add action when users clicked the 10 mile button
            print("within 10 mile")
            self.filterByMiles(miles: 10.0)

        case "Within 30 miles":
            // add action when users clicked the 20 mile button
            print("within 30 mile")
            self.filterByMiles(miles: 30.0)
        default:
            self.filterByMiles(miles: 0)
        }

        self.toggleDropdown()
    }
    
    
    
    
    func toggleDropdown() {
        self.distanceSelection.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                button.alpha = button.alpha == 0 ? 0.8 : 0
               self.view.layoutIfNeeded()
               self.view.bringSubviewToFront(self.stackView)
            })
        }
    }
    

    @IBAction func tap(_ sender: Any) {
        self.toggleDropdown()
        self.view.endEditing(true)
    }
    

}
