//
//  QRViewController.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import UIKit
import AVFoundation


class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	
	var captureSession:AVCaptureSession!
	var videoPreviewLayer:AVCaptureVideoPreviewLayer?
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var delegate:QRDelegateProtocol?
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		requestCameraPermission { _ in
			
			self.captureSession = AVCaptureSession()
			
			let device = AVCaptureDevice.default(for: AVMediaType.video)

			guard let captureDevice = device else {
				print("Failed to get the camera device")
				return
			}
			
			do {
				// Get an instance of the AVCaptureDeviceInput class using the previous device object.
				let input = try AVCaptureDeviceInput(device: captureDevice)
				
				// Set the input device on the capture session.
				self.captureSession?.addInput(input)
				
			} catch {
				// If any error occurs, simply print it out and don't continue any more.
				print(error)
				return
			}
			
			
			let captureMetadataOutput = AVCaptureMetadataOutput()
			
			self.captureSession?.addOutput(captureMetadataOutput)
			
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			captureMetadataOutput.metadataObjectTypes = [.qr]
			
			// Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
			self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
			self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
			
			DispatchQueue.main.async {
				
				self.videoPreviewLayer?.frame = self.view.layer.bounds
				self.view.layer.addSublayer(self.videoPreviewLayer!)
			}
			
			self.captureSession?.startRunning()
			
		}
		
	}
	
	
	func requestCameraPermission(onSuccess: @escaping (Bool) -> ()) {
		AVCaptureDevice.requestAccess(for: AVMediaType.video) { (success) in
			if success { onSuccess(success) }
		}
	}
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		
		if metadataObjects.count == 0 {
			return
		}
		
		
		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
		
		if metadataObj.type == AVMetadataObject.ObjectType.qr {
			
			if let value = metadataObj.stringValue {
				
				self.storeDeviceId(value: value)
				
				delegate?.returnQRData(value: value)
				
				UINotificationFeedbackGenerator().notificationOccurred(.success)
				self.captureSession.stopRunning()
				connection.isEnabled = false
				
				
				DispatchQueue.main.async {
					self.videoPreviewLayer?.removeFromSuperlayer()
				}
			
				self.navigationController?.popViewController(animated: true)
				
			}
		}
		
	}
	
	func storeDeviceId(value: String) {
		appDelegate.app.setNewDeviceId(value: value)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.captureSession = nil
		self.videoPreviewLayer = nil
	}
	
	
	
	
}

// protocol to give data backwards to setup-viewcontroller
protocol QRDelegateProtocol {
	func returnQRData(value: String)
}
