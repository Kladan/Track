//
//  SetupNewViewController.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import UIKit

private let reuseIdentifier = "setup_cell"

class SetupViewController: UICollectionViewController, QRDelegateProtocol {
	
	// CELL-DATA
	let titles = [
		"Let's setup your new sensor",
		"Scan the QR-Code",
		"Set the location",
		"You're done!"
	]
	let descriptions = [
		"Welcome to the setup",
		"You find the QR-Code on the sensor or in the package",
		"Select the location where you will install the sensor",
		"Congratulations, you can now place your sensor"
	]
	let icons = [
		UIImage(named: "logo"),
		UIImage(named: "smartQR"),
		UIImage(named: "map"),
		UIImage(named: "check")
	]
	let buttonTitles = [
		"Start",
		"Scan it",
		"Select location",
		"Finish"
	]
	// END: CELL-DATA
	
	let setupLocationSegue = "setup-location_segue"
	let setupQRSegue = "setup-qr_segue"
	let setupHomeSegue = "setup-home_segue"
	let delegate = UIApplication.shared.delegate as! AppDelegate
	var qrData:String?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		collectionView?.reloadData()
	}
	
	// MARK: UICollectionViewDataSource
	
	
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if processComplete() {
			return 4
		}
		return 3
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		
		guard let setupCell = cell as? SetupCollectionViewCell else {
			fatalError()
		}
		
		// remove all targets from button to avoid unexpected behaviour
		setupCell.actionButton.removeTarget(nil, action: nil, for: .allTouchEvents)
		
		
		// set design & shadow
		setupCell.layer.cornerRadius = 10
		setupCell.layer.masksToBounds = true
		setupCell.clipsToBounds = false
		setupCell.layer.shadowOffset = CGSize(width: 1, height: 0)
		setupCell.layer.shadowColor = UIColor.black.cgColor
		setupCell.layer.shadowRadius = 10
		setupCell.layer.shadowOpacity = 0.25
		
		setupCell.actionButton.layer.shadowOpacity = 0.4
		setupCell.actionButton.clipsToBounds = false
		setupCell.actionButton.layer.shadowRadius = 10
		setupCell.actionButton.layer.shadowOffset = CGSize(width: 1, height: 0)
		setupCell.actionButton.layer.shadowColor = UIColor.black.cgColor
		
		
		// set cell content
		setupCell.title = titles[indexPath.item]
		setupCell.titleLabel.text = titles[indexPath.item]
		setupCell.descriptionLabel.text = descriptions[indexPath.item]
		
		if let image = icons[indexPath.item] {
			setupCell.imageView.image = image
		}
		
		let buttonTitle = buttonTitles[indexPath.item]
		setupCell.actionButton.isHidden = false
		setupCell.actionButton.titleLabel?.frame = setupCell.actionButton.frame
		setupCell.actionButton.setTitle(buttonTitle, for: UIControlState.normal)
		
		switch indexPath.item {
		case 0:
			setupCell.actionButton.addTarget(self, action: #selector(self.start), for: .touchUpInside)
			
			
		case 1:
				if self.qrData != nil {
					setupCell.descriptionLabel.text = "Your sensor has been detected successfully"
					
					let indexPath = IndexPath(row: 2, section: 0)
					
					Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (_) in
						collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
					}
				}
				
				setupCell.actionButton.addTarget(self, action: #selector(self.goToQRCode), for: .touchUpInside)
			
			
		case 2:
			var descriptionText = ""
			
			if let placemark = self.delegate.app.myCurrentPlacemark {
				if let throughfare = placemark.thoroughfare {
					descriptionText.append(throughfare)
				}
				if let subThroughfare = placemark.subThoroughfare {
					descriptionText.append(subThroughfare)
					descriptionText.append(" ")
				}
				if let locality = placemark.locality {
					descriptionText.append(", \(locality)")
				}
				
				setupCell.descriptionLabel.text = descriptionText
				
				let indexPath = IndexPath(row: 3, section: 0)
				
				Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (_) in
					collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
				}
			}
			
			setupCell.actionButton.addTarget(self, action: #selector(self.goToLocation), for: .touchUpInside)
			
			
		case 3:
				if processComplete() {
					setupCell.actionButton.isHidden = false
				}
				else {
					setupCell.actionButton.isHidden = true
				}
				setupCell.actionButton.addTarget(self, action: #selector(self.sendDevice), for: .touchUpInside)
			
			
			
		default:
			break
			
		}

		return setupCell
	}
	
	
	@objc func start() {
		
		let indexPath = IndexPath(row: 1, section: 0)
		collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		UISelectionFeedbackGenerator().selectionChanged()
		
	}
	
	@objc func goToQRCode() {
		UISelectionFeedbackGenerator().selectionChanged()
		// segue is prepared with delegate below
		self.performSegue(withIdentifier: setupQRSegue, sender: nil)
	}
	
	@objc func goToLocation() {
		UISelectionFeedbackGenerator().selectionChanged()
		
		
		self.performSegue(withIdentifier: setupLocationSegue, sender: nil)
	}
	@objc func sendDevice() {
		print("senddevice", delegate.app.newDeviceId)
		UISelectionFeedbackGenerator().selectionChanged()
		
		let lat = Double((delegate.app.myCurrentLocation?.latitude)!)
		let lon = Double((delegate.app.myCurrentLocation?.longitude)!)
		
		let device = Device(deviceIdentifier: delegate.app.newDeviceId!, deviceName: "My new sensor", latitude: lat, longitude: lon)
		
		
		delegate.app.apiService.post(path: "device", body: device, onSuccess: { (result:Device) in
			print(result)
			
			
			self.delegate.app.storeDevice(deviceIdentifier: self.delegate.app.newDeviceId!)
			
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: self.setupHomeSegue , sender: nil)
			}
			
			
		}) { (error) in
			print("error", error)
		}
		
	}
	
	
	func processComplete() -> Bool {
		return delegate.app.myCurrentLocation != nil && delegate.app.newDeviceId != nil
	}
	
	// MARK: UICollectionViewDelegate
	

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == setupQRSegue {
			guard let viewController = segue.destination as? QRViewController else {
				fatalError()
			}
			
			viewController.delegate = self
		}
	}
	
	
	func returnQRData(value: String) {
		print("val", value)
		qrData = value
		delegate.app.setNewDeviceId(value: value)
	}
	
	
}

