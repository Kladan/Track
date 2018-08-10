//
//  LocationViewController.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

	@IBOutlet weak var mapView: MKMapView!
	var locationManager: CLLocationManager!
	var lastLocation: CLLocationCoordinate2D?
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

	override func viewDidLoad() {
        super.viewDidLoad()

		mapView.showsUserLocation = true
		
		
		let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.saveLocation) )
		navigationItem.rightBarButtonItem = saveButton
		
		
		if CLLocationManager.locationServicesEnabled() {
			
			locationManager = CLLocationManager()
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
			
		}
	}
	
	
	@objc func saveLocation() {

		UISelectionFeedbackGenerator().selectionChanged()
		appDelegate.app.myCurrentLocation = lastLocation
		navigationController?.popViewController(animated: true)
	}
	
//	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//		let annotationView = MKAnnotationView()
//
//		annotationView.isDraggable = true
//
//		annotationView.annotation = annotation
//
//		return annotationView
//
//	}
//
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		if let userLocation = locations.first {
			
			CLGeocoder().reverseGeocodeLocation(locations.first!) { (placemarks, error) in
				
				self.appDelegate.app.myCurrentPlacemark = placemarks?.first
				
			}
			lastLocation = locations.first?.coordinate
			

			let myAnnotation: MKPointAnnotation = MKPointAnnotation()
			myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
			myAnnotation.title = "Your location"
			mapView.addAnnotation(myAnnotation)
		}
	}
	
	
//	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
//		switch newState {
//		case .starting:
//			view.dragState = .dragging
//		case .ending, .canceling:
//			view.dragState = .none
//		default: break
//		}
//	}
	
}
