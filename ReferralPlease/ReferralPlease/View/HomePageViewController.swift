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
    @IBOutlet weak var findNearbyBtn: UIButton!
    var manager: CLLocationManager?

    @IBOutlet var distanceSelection: [UIButton]!
    @IBOutlet weak var nearmeButton: UIButton!
    
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

    @IBAction func findNearbyBtnClick(_ sender: Any) {
//        let request = MKDirections.Request()
//        let sourceP         = CLLocationCoordinate2DMake(self.currentLatitude, self.currentlongitude)
//        let destP           = CLLocationCoordinate2DMake(p2.coordinate.latitude, p2.coordinate.longitude)
//        let source = MKPlacemark(coordinate: sourceP)



        print("Number of users: \(self.currentUsers.count)")
        for user in self.currentUsers {
            print("longitude: \(user.longitude), Latitude: \(user.latitude)")
//            let distance = self.getDistance(user)
//            print("Distance \(distance)")
//            let destP = CLLocationCoordinate2DMake(user.latitude, user.longitude)
//            let destination     = MKPlacemark(coordinate: destP)
//            request.source      = MKMapItem(placemark: source)
//            request.destination = MKMapItem(placemark: destination)
//            request.transportType = MKDirectionsTransportType.automobile //define the transportation method
//            let directions = MKDirections(request: request) //request directions
//            directions.calculate { (response, error) in
//                if let response = response, let route = response.routes.first {
//                    print("here", route.distance * 0.000621371) // You could have this returned in an async approach
//                    let distance = route.distance * 0.000621371
//                    if distance <= 30 {
//                        self.nearbyUsers.append(user)
//                    }
//                }
//            }
            
            let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
            let distance = self.currentLocation.distance(from: location) // in meters
            let distanceInMiles =  distance / 1609 // in meters

            print("Distance from currentLocation: \(distanceInMiles) miles")

            if distanceInMiles <= 30 {
                self.nearbyUsers.append(user)
            }
        }
        print("Number of nearby users: \(self.nearbyUsers.count)")
        self.currentUsers = self.nearbyUsers
        self.tableView.reloadData()

        
    }
    
//    func rad(_ x: Double) -> Double {
//      return x * Double.pi / 180
//    }
//
//    func getDistance(_ user2: User) -> Float {
//        let R = Float(6371); // Earth’s mean radius in meter
//        let dLat = rad(user2.latitude - self.currentLatitude);
//        let dLong = rad(user2.longitude - self.currentlongitude);
//        let a = sin(dLat / 2) * sin(dLat / 2)
//        let b = Float(sin(dLong/2) * sin(dLong/2)) * cos(Float(self.currentLatitude)) * cos(Float(user?.latitude ?? 0))
//        let z = Float(a)+b
//        let c = 2 * atan2(sqrt(z), sqrt(1 - z))
//        let d = R * c
//        return d // returns the distance in meter
//    }

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
    
    
    @IBAction func distanceFilter(_ sender: UIButton) {
        
        distanceSelection.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                            button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
            
        }
    }
    enum Miles:String {
        case tenMile = "within 10 mile"
        case twentyMile = "within 20 mile"
    }
    
    
    @IBAction func distanceTap(_ sender: UIButton) {
        guard let title = sender.currentTitle, let mile = Miles(rawValue: title) else {
            return
        }
        
        switch mile {
        case .tenMile:
            // add action when users clicked the 10 mile button
            print("within 10 mile")
        
        case .twentyMile:
            // add action when users clicked the 20 mile button
            print("within 20 mile")
        }
        
    }
}

