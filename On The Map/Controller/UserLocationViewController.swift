//
//  UserLocationViewController.swift
//  On The Map
//
//  Created by Mohammad Al-Oraini on 29/08/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit
import MapKit

class UserLocationViewController: UIViewController {
    
    //MARK: - IBOutlet of the user location view
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - data to set up the location
    
    static var latitude:Double = 0.0
    static var longitude:Double = 0.0
    static var name: String = ""
    static var url: String = ""
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: UserLocationViewController.latitude, longitude: UserLocationViewController.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    //MARK: - Life cycle of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showingUserLocation()
        perform(#selector(self.animateMap), with: nil, afterDelay: 1)
    }
    
    //MARK: - controller methods
    
    @objc func animateMap() {
        mapView.setRegion(region, animated: true)
    }
    
    func showingUserLocation() {
        let lat = CLLocationDegrees(UserLocationViewController.latitude)
        let long = CLLocationDegrees(UserLocationViewController.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let title = UserLocationViewController.name
        let mediaURL = UserLocationViewController.url
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        mapView.addAnnotations([annotation])
        print(UserLocationViewController.latitude)
        mapView.centerCoordinate = coordinate
    }
    
    func handleMissingLink() {
        let alertVC = UIAlertController(title: "Link broken", message: "could not open the page", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - map view delegate

extension UserLocationViewController: MKMapViewDelegate {

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
