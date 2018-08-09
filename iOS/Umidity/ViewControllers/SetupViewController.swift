//
//  SetupViewController.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import UIKit

private let reuseIdentifier = "setup_cell"

class SetupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	let titles = [
		"Let's setup your new device",
		"Scan the QR-Code",
		"Set the location",
		"You're done!"
	]
	let descriptions = [
		"Welcome to the setup",
		"You find the QR-Code on the device or in the package",
		"Select the location where you will install the device",
		"Congratulations, you can now place your device"
	]
	let icons = [
		nil,
		UIImage(named: "smartQR"),
		UIImage(named: "map"),
		nil
		
	]
	let buttonTitles = [
		nil,
		"Take photo",
		"Select location",
		"Start"
	]
	
	let setupLocationSegue = "setup-location_segue"
	let setupQRSegue = "setup-qr_segue"
	let delegate = UIApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		collectionView.reloadData()
		
	}
	
	
	// MARK: UICollectionViewDataSource	
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		
		//		let frame = cell.frame
		// cell.frame = CGRect(x: frame.minX, y: frame.minY, width: view.frame.width-32, height: frame.height)
		
		
		guard let setupCell = cell as? SetupCollectionViewCell else {
			fatalError()
		}
		
		
		setupCell.title = titles[indexPath.item]
		setupCell.titleLabel.text = titles[indexPath.item]
		setupCell.descriptionLabel.text = descriptions[indexPath.item]
		//		setupCell.imageView.image = images
		
		
		if let buttonTitle = buttonTitles[indexPath.item] {
			setupCell.actionButton.titleLabel?.frame = setupCell.actionButton.frame
			setupCell.actionButton.setTitle(buttonTitle, for: UIControlState.normal)
		}
		else {
			setupCell.actionButton.isHidden = true
		}
		
		
		if indexPath.item == 1 {
			setupCell.actionButton.addTarget(self, action: #selector(self.goToQRCode), for: .touchUpInside)
		}
			
		else if indexPath.item == 2 {
			
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
				
			}
			
			
			
			setupCell.actionButton.addTarget(self, action: #selector(self.goToLocation), for: .touchUpInside)
		}
			
		else if indexPath.item == 3 {
			if processComplete() {
				setupCell.actionButton.isHidden = false
			}
			else {
				setupCell.actionButton.isHidden = true
			}
			
			setupCell.actionButton.addTarget(self, action: #selector(self.sendDevice), for: .touchUpInside)
		}
		
		
//		if delegate.app.myCurrentLocation != nil {
//			if indexPath.item == 3 {
//				collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//			}
//		}
		
		
		setupCell.contentView.layer.cornerRadius = 10.0
		setupCell.contentView.layer.masksToBounds = true
		
		
		return setupCell
	}
	
	
	@objc func goToQRCode() {
		self.performSegue(withIdentifier: setupQRSegue, sender: nil)
	}
	
	@objc func goToLocation() {
		self.performSegue(withIdentifier: setupLocationSegue, sender: nil)
	}
	@objc func sendDevice() {
				
		let lat = Double((delegate.app.myCurrentLocation?.latitude)!)
		let lon = Double((delegate.app.myCurrentLocation?.longitude)!)
		
		let device = Device(deviceIdentifier: delegate.app.newDeviceId!, deviceName: "My new device", latitude: lat, longitude: lon)
		
		
		delegate.app.apiService.post(path: "/device", body: device, onSuccess: { (result:Device) in
			print(result)
		}) { (error) in
			print("error", error)
		}
		
	}
	
	
	func processComplete() -> Bool {
		return delegate.app.myCurrentLocation != nil
		//		return delegate.app.myCurrentLocation != nil && delegate.app.newDeviceId != nil
		
	}
	
	// MARK: UICollectionViewDelegate
	
	
}

