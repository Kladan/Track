//
//  HomeNewViewController.swift
//  Umidity
//
//  Created by Thomas Münzl on 10.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import UIKit

// this view is at the moment now able to handle multiple sensors!

class HomeViewController: UIViewController {
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	var lastMeasuring:Measurement?
	
	@IBOutlet weak var envHumidity: UILabel!
	@IBOutlet weak var envTemperature: UILabel!
	@IBOutlet weak var mainValue: UILabel!
	@IBOutlet weak var hint: UILabel!
	@IBOutlet weak var lastMeasurementTime: UILabel!
	var measurements = [Measurement]()
	var deviceId: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let devices = appDelegate.app.getMyDevices() else {
			return
		}
		
		deviceId = devices.first!
		
		if let lastMeasurement = appDelegate.app.getLastMeasurement() {
			self.setLastMeasurementTime(lastMeasurement)
			self.setMeasurementInfo(lastMeasurement)
			self.setBackgroundColor(lastMeasurement)
			self.setHintLabel(lastMeasurement)
		}
		
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadData()
	}
	
	
	func loadData() {
		
		appDelegate.app.apiService.get(path: "measurements/extended/device/\(deviceId!)", onSuccess: { (result:Measurement) in
			print(result)
			
			self.lastMeasuring = result
			
			self.appDelegate.app.storeLastMeasurement(measurement: result)
			
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				self.setLastMeasurementTime(result)
				self.setMeasurementInfo(result)
				self.setBackgroundColor(result)
				self.setHintLabel(result)
			}
			
			
		}) { (error) in
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
			
			print(error)
			
		}
	}
	
	func setHintLabel(_ result: Measurement) {
		if let timeToCritical = result.timeToCritical {
			if (timeToCritical >= 0 && timeToCritical <= 12) {
				if(timeToCritical == 1) {
					self.hint.text = "We recommend you to water your plant in the next hour"
				}
				else {
					self.hint.text = "We recommend you to water your plant in the next \(timeToCritical) hours"
				}
			}
			else if timeToCritical <= -1 {
				self.hint.text = "No need to water your plant in the next 12 hours"
			}
			else {
				self.hint.text = ""
			}
		}
	}
	
	
	func setBackgroundColor(_ result: Measurement) {
		
		let color: UIColor!
		
		let red = UIColor(red: 228/255, green: 108/255, blue: 91/255, alpha: 1)
		let green = UIColor(red: 125/255, green: 228/255, blue: 109/255, alpha: 1)
		if result.soilHumidity <= 20 {
			color = red
		}
		else if result.soilHumidity > 90 {
			color = red
		}
		else {
			color = green
		}
		
		UIView.animate(withDuration: 1.5, animations: {
			self.view.backgroundColor = color
		})
	}
	
	func setMeasurementInfo(_ result:Measurement) {
		self.envHumidity.text = "\(result.environmentHumidity) %"
		self.envTemperature.text = "\(result.temperature) °C"
		self.mainValue.text = "\(result.soilHumidity) %"
	}
	
	
	func setLastMeasurementTime(_ result: Measurement) {
		var dateString = ""
		
		let dateString1 = result.timestamp.replacingOccurrences(of: ".", with: ",").replacingOccurrences(of: "+0000", with: "Z")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss,SSSZ"
		let date = dateFormatter.date(from:dateString1)
		
		if let date = date {
			if Calendar.current.isDateInToday(date) {
				let hours = Calendar.current.component(Calendar.Component.hour, from: date)
				let minutes = Calendar.current.component(Calendar.Component.minute, from: date)
				
				dateString = "\(hours):\(minutes)"
			}
			else if Calendar.current.isDateInYesterday(date) {
				let hours = Calendar.current.component(Calendar.Component.hour, from: date)
				let minutes = Calendar.current.component(Calendar.Component.minute, from: date)
				
				dateString = "Yesterday, \(hours):\(minutes)"
			}
			else {
				let dateFormatter = DateFormatter()
				dateFormatter.dateStyle = .short
				dateFormatter.timeStyle = .short
				dateString = dateFormatter.string(from: date)
			}
		}
		
		DispatchQueue.main.async {
			self.lastMeasurementTime.text = "\(dateString)"
		}
	}
	
	@IBAction func refreshButtonClicked(_ sender: Any) {
		
		loadData()
	}
	
}
