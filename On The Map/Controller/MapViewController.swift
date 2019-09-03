//
//  MapViewController.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 28/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - IBOutlet of the map view

    @IBOutlet weak var mapView: MKMapView!
    
    // setting up the annotations to be displayed
    
    var annotations = [MKPointAnnotation]()
    
    //MARK: - Life cycle of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        OnTheMapClient.getStudentLocations(completion: handleStudentLocations(students:error:))
        OnTheMapClient.gettingPublicUserData(userID: OnTheMapClient.Auth.key, completion: handleUserData(success:error:))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        annotations.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        addingAnnotations()
    }
    
    //MARK: - adding annotations to be displayed on the map
    
    func addingAnnotations() {
        for dictionary in OnTheMapModel.students {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "NO FIRST NAME") \(last ?? "NO LAST NAME")"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            self.annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.annotations)
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    //MARK: - IBAction of the map view
    

    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.getStudentLocations(completion: handleStudentLocations(students:error:))
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - handling methods
    
    func handleStudentLocations(students:StudentLocations?,error:Error?) {
        guard students == nil else {
            handleMissingLocation()
            return
        }
        DispatchQueue.main.async {
            self.annotations.removeAll()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addingAnnotations()
        }
    }
    
    func handleUserData(success: Bool , error: Error?) {
        if success {
            print("got user data with Key")
        } else {
            handleMissingUserData()
        }
    }
    
    func handleMissingLink() {
        let alertVC = UIAlertController(title: "Link broken", message: "could not open the page", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func handleMissingLocation() {
        let alertVC = UIAlertController(title: "Location error", message: "could not get the locations", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    func handleMissingUserData() {
        let alertVC = UIAlertController(title: "User Error", message: "could not get user data", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - map view delegate

extension MapViewController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            guard let toOpen = view.annotation!.subtitle! else{
                handleMissingLink()
                return
            }
            guard let url = URL(string: toOpen) else {
                handleMissingLink()
                return
            }
            app.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
