//
//  AppController.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import Foundation
import CoreLocation

class AppController {
	var myCurrentLocation:CLLocationCoordinate2D?
	var myCurrentPlacemark:CLPlacemark?
	var newDeviceId: String?
	
	let apiService = ApiService()
	
	
	
	
}


struct Device:Codable {
	var deviceIdentifier: String
	var deviceName: String
	var latitude: Double
	var longitude: Double
	
	
}

