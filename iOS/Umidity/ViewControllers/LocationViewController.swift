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

class LocationViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var mapView: MKMapView!
	var locationManager: CLLocationManager!
	var lastLocation: CLLocationCoordinate2D?
	let delegate = UIApplication.shared.delegate as! AppDelegate

	
	override func viewDidLoad() {
        super.viewDidLoad()

		mapView.showsUserLocation = true
		
		var saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.saveLocation) )
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
		
		
		delegate.app.myCurrentLocation = lastLocation
		navigationController?.popViewController(animated: true)
	}
	
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("here locations", locations.first)
		
		CLGeocoder().reverseGeocodeLocation(locations.first!) { (placemarks, error) in
			
			self.delegate.app.myCurrentPlacemark = placemarks?.first
			
			print(placemarks)
			
			
		}
		lastLocation = locations.first?.coordinate
		
		
	}
	
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
