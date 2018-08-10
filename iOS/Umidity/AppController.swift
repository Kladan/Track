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
	
	func setNewDeviceId(value:String) {
		newDeviceId = value
	}
	
	
	
	func getMyDevices() -> [String]? {
		if let myDevices = UserDefaults.standard.array(forKey: "myDevices") {
			return myDevices as? [String]
		}
		return nil
	}
	
	func storeDevice(deviceIdentifier : String) {
		
		var myDevices = self.getMyDevices()
		if myDevices == nil {
			myDevices = [deviceIdentifier]
		}
		else {
			myDevices?.append(deviceIdentifier)
		}
		
		UserDefaults.standard.set(myDevices, forKey: "myDevices")
		
	}
	
	
	// should be replaced with Core-Data!!
	func storeLastMeasurement(measurement:Measurement) {
		
		let data = try! JSONEncoder().encode(measurement)
		
		let dataAsString = String(data: data, encoding:.utf8)
		UserDefaults.standard.set(dataAsString, forKey: "lastMeasurement")
		
	}
	
	func getLastMeasurement() -> Measurement? {
		
		let dataAsString = UserDefaults.standard.string(forKey: "lastMeasurement")
		guard let string = dataAsString else {
			return nil
		}
		let data = string.data(using: .utf8)
		
		return try! JSONDecoder().decode(Measurement.self, from: data!)
		
	}
	
	
}


struct Device:Codable {
	var deviceIdentifier: String
	var deviceName: String
	var latitude: Double
	var longitude: Double
}



struct Measurement:Codable {
	let id: String
	let deviceIdentifier:String
	let soilHumidity: Int
	let environmentHumidity: Int
	let timestamp:String
	let temperature: Int
	let timeToCritical: Int?
}

