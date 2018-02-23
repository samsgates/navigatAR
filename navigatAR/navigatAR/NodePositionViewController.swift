//
//  NodePositionViewController.swift
//  navigatAR
//
//  Created by Michael Gira on 2/3/18.
//  Copyright © 2018 MICDS Programming. All rights reserved.
//

import UIKit
import IndoorAtlas

class NodePositionViewController: UIViewController {

	let locationManager = IALocationManager.sharedInstance()

	var currentLocation: IALocation?

	@IBOutlet weak var calibrationText: UILabel!
	@IBOutlet weak var accuracyText: UILabel!
	@IBOutlet weak var getPositionButton: UIButton!

	@IBAction func getPosition() {
		self.gotPosition()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Delegate methods to our custom location handler
		locationManager.delegate = self
		locationManager.startUpdatingLocation()
		setQualityText(calibrationQuality: locationManager.calibration)
		if let l = locationManager.location {
			setLocation(location: l)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		// Stop getting location
		locationManager.stopUpdatingLocation()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func gotPosition() {
		print("Got gotted");
		performSegue(withIdentifier: "unwindToUpsertNodesWithUnwindSegue", sender: self)
	}

	//	Pass position data back to the creation page
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let UpsertNodeViewController = segue.destination as? UpsertNodeViewController {
			UpsertNodeViewController.locationData = currentLocation
		}
	}
}

// MARK: - IndoorAtlas delegates
extension NodePositionViewController: IALocationManagerDelegate {
	// recieve locaiton info
	func indoorLocationManager(_ manager: IALocationManager, didUpdateLocations locations: [Any]) {
		let l = locations.last as! IALocation

		setLocation(location: l);
	}

//	func indoorLocationManager(_ manager: IALocationManager, statusChanged status: IAStatus) {
//		if status.type != ia_status_type.iaStatusServiceAvailable {
//			performSegue(withIdentifier: "unwindToManageNodesSegueId", sender: self)
//		}
//	}
	
	func indoorLocationManager(_ manager: IALocationManager, calibrationQualityChanged quality: ia_calibration) {
		setQualityText(calibrationQuality: quality)
	}
	
	func setLocation(location l: IALocation) {
		currentLocation = l
		let ha = String(round(currentLocation!.location!.horizontalAccuracy))
		let va = String(round(currentLocation!.location!.verticalAccuracy))
		accuracyText.text = "Accuracy: (" + ha + ", " + va + ")"
	}

	func setQualityText(calibrationQuality quality: ia_calibration) {
		var qualityText: String
		switch quality {
		case ia_calibration.iaCalibrationExcellent:
			qualityText = "Excellent"
		case ia_calibration.iaCalibrationGood:
			qualityText = "Good"
		case ia_calibration.iaCalibrationPoor:
			qualityText = "Poor"
		}
		calibrationText.text = "Calibration: " + qualityText
	}
}
