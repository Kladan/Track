//
//  LaunchViewController.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

	let launchSetupSegue = "launch-setup_segue"
	let launchHomeSegue = "launch-home_segue"
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		checkDeviceAvailable()
		
	}

	func checkDeviceAvailable() {
		
		let devicesFromStorage = UserDefaults.standard.array(forKey: "myDevices")
		
		
		if let devices = devicesFromStorage {
			
			self.performSegue(withIdentifier: launchHomeSegue, sender: nil)
			
			
		}
		
		else {
			
			self.performSegue(withIdentifier: launchSetupSegue, sender: nil)
			
		}
		
		
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let identifier = segue.identifier {

			
			switch identifier {
				
			case launchHomeSegue:
//				let destination = segue.destination as! HomeViewController
				
				break
				
			case launchSetupSegue:
//				let destination = segue.destination as! SetupViewController
				break
				
				
			default: break
				
			}
		
		}
		
	}
	
	
}
