////
////  HomeViewController.swift
////  Umidity
////
////  Created by Thomas Münzl on 09.08.18.
////  Copyright © 2018 Thomas Münzl. All rights reserved.
////
//
//import UIKit
//
//class HomeViewController: UICollectionViewController {
//	
//	var lastMeasuring:Measurement?
//	
//	var measurements = [Measurement]()
//	
//	let appDelegate = UIApplication.shared.delegate as! AppDelegate
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		UIApplication.shared.isNetworkActivityIndicatorVisible = true
//		
////		if 60 < 70 {
////			UIView.animate(withDuration: 3.0, animations: {
////
////				self.view.backgroundColor = .brown
////
////			})
////		}
//		
//		guard let devices = appDelegate.app.getMyDevices() else {
//			return
//		}
//		self.collectionView!.reloadData()
//		
//		for deviceId in devices {
//			
//			appDelegate.app.apiService.get(path: "measurements/extended/device/\(deviceId)", onSuccess: { (result:Measurement) in
//				print(result)
//				
//				var date = DateFormatter().date(from: result.timestamp)
//							
//				DispatchQueue.main.async {
//					UIApplication.shared.isNetworkActivityIndicatorVisible = false
//				}
//				
//				
//				let existingMeasurement = self.measurements.firstIndex(where: { (m) -> Bool in			return m.deviceIdentifier == result.deviceIdentifier
//				})
//				
//				if let index = existingMeasurement {
//					self.measurements[index] = result
//				}
//				else {
//					self.measurements.append(result)
//				}
//				print("hallo hier")
//				
//				 DispatchQueue.main.async {
//					self.collectionView!.reloadData()
//				 }
//			
//				
//				
//			}) { (error) in
//				DispatchQueue.main.async {
//					UIApplication.shared.isNetworkActivityIndicatorVisible = false
//				}
//				
//				print(error)
//				
//			}
//		}
//			
//		
//		
//		func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//			print("Hallo")
//			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "home_cell", for: indexPath) as! HomeCollectionViewCell
//			
//			cell.envHumidityLabel.text = "\(measurements[indexPath.item].environmentHumidity) %"
//			cell.envTemperatureLabel.text = "\(measurements[indexPath.item].temperature) °C"
//			cell.mainValueLabel.text = "\(measurements[indexPath.item].soilHumidity) %"
//			
//			
//			
//			let date = DateFormatter().date(from: measurements[indexPath.item].timestamp)
//			var dateString = ""
//			
//			if let date = date {
//				
//				
//				
//				if Calendar.current.isDateInToday(date) {
//					let hours = Calendar.current.component(Calendar.Component.hour, from: date)
//					let minutes = Calendar.current.component(Calendar.Component.minute, from: date)
//					
//					dateString = "\(hours):\(minutes)"
//				}
//				else if Calendar.current.isDateInYesterday(date) {
//					let hours = Calendar.current.component(Calendar.Component.hour, from: date)
//					let minutes = Calendar.current.component(Calendar.Component.minute, from: date)
//					
//					dateString = "Yesterday, \(hours):\(minutes)"
//				}
//				else {
//					let dateFormatter = DateFormatter()
//					dateFormatter.dateStyle = .short
//					dateFormatter.timeStyle = .short
//					dateString = dateFormatter.string(from: date)
//				}
//				
//				cell.lastMeasuringTimeLabel.text = "\(dateString)"
//			}
//			return cell
//		}
//		
//		func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//			print(measurements.count)
//			return measurements.count
//		}
//		
//		func numberOfSections(in collectionView: UICollectionView) -> Int {
//			return 1
//		}
//		
//		
//		
//		
//		
//	}
//	
//	
//	
//	
//}
