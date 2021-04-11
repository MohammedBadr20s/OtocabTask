//
//  ViewController.swift
//  OtocabTask
//
//  Created by MGoKu on 5/5/20.
//  Copyright © 2020 MohammedBadr. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationVC: UIViewController {

    
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var LocationButton: CustomButtons!
    @IBOutlet weak var LocationStateLabel: UILabel!
    @IBOutlet weak var searchTF: CustomTextField!
    var resultView: UITextView?
    
    var currCoordinate = CLLocationCoordinate2D()
    
    var locationManager = CLLocationManager()
    var currAddress = String()
    let geocoder = GMSGeocoder()
    var pickUpLat = Double()
    var pickUpLong = Double()
    var dropOffLat = Double()
    var dropOffLong = Double()
    var PickupName = String()
    var DropoffName = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GMSPlacesClient.provideAPIKey(Constants.shared.GoogleAPIKey)
        GMSServices.provideAPIKey(Constants.shared.GoogleAPIKey)
        self.LocationStateLabel.adjustsFontSizeToFitWidth = true
        self.LocationStateLabel.minimumScaleFactor = 0.5
        self.addressLabel.adjustsFontSizeToFitWidth = true
        self.addressLabel.minimumScaleFactor = 0.5
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    // once permissions have been established, ask the location manager for updates on the user’s location
                    locationManager.startUpdatingLocation()
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                case .denied, .notDetermined, .restricted:
                    //Ask for persmission
                    locationManager.requestWhenInUseAuthorization()
                @unknown default:
                    locationManager.requestWhenInUseAuthorization()
                    
                }
        
    }
    @IBAction func searchDidChange(_ sender: CustomTextField) {
        SearchAutoCompleteFunction()
    }
    
    func SearchAutoCompleteFunction() {
        searchTF.resignFirstResponder()
        let autoComplete = GMSAutocompleteViewController()
        autoComplete.delegate = self
        autoComplete.modalPresentationStyle = .overFullScreen
        autoComplete.modalTransitionStyle = .crossDissolve
        autoComplete.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5033979024)
        present(autoComplete, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        reverseGeocodeCoordinate(currCoordinate) { (location) in
            self.addressLabel.text = location
            self.addressLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        resetLocationPickingAndGetCurrentLocation()
        
    }
    @IBAction func PickUpDropOffLocationAction(_ sender: UIButton) {
        currAddress = addressLabel.text!
        if pickUpLat == 0 && pickUpLong == 0 {
            self.pickUpLat = currCoordinate.latitude
            self.pickUpLong = currCoordinate.longitude
            self.reverseGeocodeCoordinate(self.currCoordinate) { (location) in
                self.PickupName = location
                self.LocationStateLabel.text = "Your Pick Up is Set, Now Pick Your Destination"
                self.addressLabel.text = "Your Pick Up is Set : \(self.PickupName)"
                self.LocationButton.setTitle("Confirm Your Drop off Destination", for: .normal)
            }
            
        } else if dropOffLat == 0 && dropOffLong == 0 {
            self.dropOffLat = currCoordinate.latitude
            self.dropOffLong = currCoordinate.longitude
            self.reverseGeocodeCoordinate(self.currCoordinate) { (location) in
                self.DropoffName = location
                self.addressLabel.text = "Your Pick Up is Set: \(self.PickupName)\nYour Destination is Set: \(self.DropoffName)"
                self.LocationStateLabel.text = "Your Destination is set"
                self.LocationButton.setTitle("Now you are ready to start your directions", for: .normal)
            }
            
            drawDirectionsGoogleMaps()
        } else {
            openGoogleMapsWithDirections()
        }
        
    }
    func openGoogleMapsWithDirections() {
        let schemeUrl = NSURL(string: "comgooglemaps://?saddr=\(self.pickUpLat),\(self.pickUpLong)&daddr=\(self.dropOffLat),\(self.dropOffLong)&directionsmode=driving")!
        if UIApplication.shared.canOpenURL(schemeUrl as URL) {
            UIApplication.shared.open(schemeUrl as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(NSURL(string: "https://www.google.co.in/maps/dir/?saddr=\(self.pickUpLat),\(self.pickUpLong)&daddr=\(self.dropOffLat),\(self.dropOffLong)&directionsmode=driving")! as URL)
        }
    }
    func setupMap(coordinate: CLLocationCoordinate2D){
        //         Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 17)
        self.googleMapsView.camera = camera
        self.googleMapsView.animate(to: camera)
        self.googleMapsView.delegate = self
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        self.currCoordinate = coordinate
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.map = googleMapsView
        
    }
    func drawDirectionsGoogleMaps() {
        googleMapsView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: self.pickUpLat , longitude: self.pickUpLong, zoom: 17)
        googleMapsView.animate(to: camera)
        let pickUpMarker = #imageLiteral(resourceName: "icons8-marker")
        let markerView = UIImageView(image: pickUpMarker)
        let dropOffMarkerImage = #imageLiteral(resourceName: "icons8-marker-1")
        let dropOffMarkerView = UIImageView(image: dropOffMarkerImage)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.pickUpLat , self.pickUpLong )
        marker.isDraggable = false
        marker.iconView = markerView
        marker.snippet = "Pickup lat: \(self.pickUpLat.rounded(toPlaces: 2) ) Long:\(self.pickUpLong.rounded(toPlaces: 2) )"
        marker.title = self.PickupName

        marker.map = googleMapsView
        let dropOffMarker = GMSMarker()
        dropOffMarker.position = CLLocationCoordinate2DMake(self.dropOffLat , self.dropOffLong )
        dropOffMarker.isDraggable = false
        dropOffMarker.iconView = dropOffMarkerView
        dropOffMarker.snippet = "Dropoff Lat: \(self.dropOffLat.rounded(toPlaces: 2) ) Long: \(self.dropOffLong.rounded(toPlaces: 2) )"
        dropOffMarker.title = self.DropoffName
        dropOffMarker.map = googleMapsView
        //get Directions For Google Maps
        googleMapsView.getPolylineRoute(from: CLLocationCoordinate2DMake(pickUpLat , pickUpLong ), to: CLLocationCoordinate2DMake(dropOffLat, dropOffLong ), view: self)
    }
    func markLocation(coordinates: CLLocationCoordinate2D) {
        self.googleMapsView.clear()
        geocoder.reverseGeocodeCoordinate(coordinates) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                print("\(result)")
                marker.position = self.currCoordinate
                marker.title = result.lines?[0]
                marker.snippet = result.thoroughfare
                //                self.addressLabel.text = result.lines?[0]
                self.reverseGeocodeCoordinate(self.currCoordinate) { (location) in
                    self.addressLabel.text = location
                    self.addressLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                marker.map = self.googleMapsView
            }
        }
    }
    
    func resetLocationPickingAndGetCurrentLocation() {
        self.pickUpLat = 0
        self.pickUpLong = 0
        self.dropOffLat = 0
        self.dropOffLong = 0
        self.addressLabel.text = ""
        self.LocationStateLabel.text = "Pick Up Your Location"
        self.LocationButton.setTitle("Confirm Your Location", for: .normal)
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            currCoordinate = currentLocation.coordinate
            setupMap(coordinate: currentLocation.coordinate)
            markLocation(coordinates: currCoordinate)
        }
    }
}

//MARK:- Location Manage Delegate Methods
extension LocationVC: CLLocationManagerDelegate{
    // user grants or revokes location permissions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            displayMessage(title: "", message: "Location usage is disabled, Enable Location use from Settings.", status: .error, forController: self)
            return
        }
        // once permissions have been established, ask the location manager for updates on the user’s location
        locationManager.startUpdatingLocation()
    }
    
    // executes when the location manager receives new location data.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // Stop updating the location just get the users initial location
        manager.stopUpdatingLocation()
        currCoordinate = location.coordinate
        setupMap(coordinate: location.coordinate)
        markLocation(coordinates: currCoordinate)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completionHandler : @escaping (String) -> ()) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let _ = address.lines else {
                return
            }
            completionHandler(address.lines?[0] ?? "")
        }
    }
}

extension LocationVC: GMSMapViewDelegate {
    //MARK:- single Tap Function
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        //MARK:- Resets Location Picker if there was a pickup and Drop off points selected on Tap
        if self.pickUpLat != 0 && self.pickUpLong != 0 && self.dropOffLat != 0 && self.dropOffLong != 0 {
            resetLocationPickingAndGetCurrentLocation()
        } else {
            currCoordinate = coordinate
            setupMap(coordinate: currCoordinate)
            markLocation(coordinates: currCoordinate)
        }
    }
    //MARK:- long tap Function
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        //MARK:- Resets Location Picker if there was a pickup and Drop off points selected on Long Press
        if self.pickUpLat != 0 && self.pickUpLong != 0 && self.dropOffLat != 0 && self.dropOffLong != 0 {
            resetLocationPickingAndGetCurrentLocation()
        } else {
            currCoordinate = coordinate
            setupMap(coordinate: currCoordinate)
            markLocation(coordinates: currCoordinate)
        }
    }
    //MARK:- Method Accessed When user is going to swipe through Google Maps
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    }
    //MARK:- Get the Location where the user stops his swipping at specific position
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
    }
}

//MARK:- GMS Auto Complete Delegate Methods
extension LocationVC: GMSAutocompleteViewControllerDelegate {
    //MARK:-
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        googleMapsView.clear()
        geocoder.reverseGeocodeCoordinate(place.coordinate) { (response, error) in
                    guard error == nil else {
                        return
                    }
        
                    if let result = response?.firstResult() {
                        let marker = GMSMarker()
                        print("\(result)")
                        marker.position = place.coordinate
                        marker.title = result.lines?[0]
                        marker.snippet = result.thoroughfare
                        self.reverseGeocodeCoordinate(place.coordinate) { (location) in
                            self.addressLabel.text = location
                            self.addressLabel.textColor = #colorLiteral(red: 0.0920875594, green: 0.1960377097, blue: 0.2973010242, alpha: 1)
                        }
                        self.currCoordinate = place.coordinate
                        self.setupMap(coordinate: self.currCoordinate)
                        marker.map = self.googleMapsView
                    }
                }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
