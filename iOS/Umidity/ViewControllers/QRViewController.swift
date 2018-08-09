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
	var qrCodeFrameView:UIView?
	let delegate = UIApplication.shared.delegate as! AppDelegate
	
	
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
			
			
			print("avail", captureMetadataOutput.availableMetadataObjectTypes)
			
			
			
			
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			print(captureMetadataOutput.metadataObjectTypes)
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
		
		
		
		
		
		// Move the message label and top bar to the front
		//		view.bringSubview(toFront: messageLabel)
		//		view.bringSubview(toFront: topbar)
		
	}
	
	
	func requestCameraPermission(onSuccess: @escaping (Bool) -> ()) {
		AVCaptureDevice.requestAccess(for: AVMediaType.video) { (success) in
			if success { onSuccess(success) }
		}
	}
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		
		if metadataObjects.count == 0 {
			qrCodeFrameView?.frame = CGRect.zero
			// messageLabel.text = "No QR code is detected"
			return
		}
		
		
		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
		
		if metadataObj.type == AVMetadataObject.ObjectType.qr {
			// If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
			let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
			qrCodeFrameView?.frame = barCodeObject!.bounds
			
			if metadataObj.stringValue != nil {
				print(metadataObj.stringValue)
				delegate.app.newDeviceId  = metadataObj.stringValue
				
				captureSession.stopRunning()
				navigationController?.popViewController(animated: true)
			}
		}
		
	}
	
	
	
	
}
