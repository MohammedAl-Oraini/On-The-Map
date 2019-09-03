//
//  AddingLocationViewController.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 31/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddingLocationViewController: UIViewController {
    
    //MARK: - IBOutlet of the adding location view

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - data to setup the location
    
    static var locationString = "Riyadh"
    static var urlString = "https://"
    
    let gecoder = CLGeocoder()
    
    var userCoordinate:CLLocationCoordinate2D?
    var userRegion:MKCoordinateRegion?
    
    //MARK: - Life cycle of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        finishButton.isEnabled = false
        finishButton.isHidden = true
        setAdding(true)
        gecoder.geocodeAddressString(AddingLocationViewController.locationString, completionHandler: handleGecodeRequest(placemark:error:))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setAdding(false)
    }
    
    //MARK: - animate method
    
    @objc func animateMap() {
        if let region = userRegion {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    //MARK: - IBAction of the adding location view
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        self.finishButton.isEnabled = false
        self.finishButton.isHidden = true
        self.setAdding(true)
        OnTheMapClient.postingStudentLocation(firstName: OnTheMapModel.user.firstName, lastName: OnTheMapModel.user.lastName, mapString: AddingLocationViewController.locationString, mediaURL: AddingLocationViewController.urlString, latitude: Double(userCoordinate!.latitude), longitude: Double(userCoordinate!.longitude), completion: handlePostingLocation(success:error:))
        
    }
    
    //MARK: - handling methods
    
    func handleGecodeRequest(placemark: [CLPlacemark]?, error: Error?) -> Void {
        guard let placemark = placemark else {
            setAdding(false)
            self.showLocationFailure(message: error?.localizedDescription ?? "error")
            return
        }
        let coordinate = placemark[0].location?.coordinate
        self.userCoordinate = coordinate
        print(placemark[0].country!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        self.mapView.addAnnotations([annotation])
        self.mapView.setCenter(coordinate!, animated: true)
        
        let region = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.userRegion = region
        perform(#selector(self.animateMap), with: nil, afterDelay: 2)

        setAdding(false)
        finishButton.isEnabled = true
        finishButton.isHidden = false
        
        
    }
    
    func handlePostingLocation(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                OnTheMapClient.getStudentLocations(completion: self.handleStudentLocations(students:error:))
            } else {
                self.showLocationFailure(message: error?.localizedDescription ?? "error posting location!")
                self.setAdding(false)
                self.finishButton.isEnabled = true
                self.finishButton.isHidden = false
            }
        }
    }
     func handleStudentLocations(students:StudentLocations?,error:Error?) {
        if error == nil {
            self.setAdding(false)
            dismiss(animated: true, completion: nil)
        } else {
            showLocationFailure(message: error?.localizedDescription ?? "Could not add location this time try againe later")
            self.setAdding(false)
        }
     
    }
    func showLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Location was not found", message: message, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (alertAction) in
            self.gecoder.geocodeAddressString(AddingLocationViewController.locationString, completionHandler: self.handleGecodeRequest(placemark:error:))
        }))
        present(alertVC, animated: true, completion: nil)
    }
    func setAdding(_ adding: Bool) {
        DispatchQueue.main.async {
            if adding {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
        }
    }
}

//MARK: - map view delegate

extension AddingLocationViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
