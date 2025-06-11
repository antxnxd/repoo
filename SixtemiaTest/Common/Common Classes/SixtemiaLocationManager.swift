//
//  SixtemiaLocationManager.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class SixtemiaLocationManager: NSObject, CLLocationManagerDelegate {
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	private var locationManager: CLLocationManager!
	var delegate: SixtemiaLocationDelegate?
	var controller: UIViewController?
	var latitude: Float = 0.0
	var longitude: Float = 0.0
	
	public static var shared = SixtemiaLocationManager()
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	private override init() {
		super.init()
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			startLocation()
		}
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/**
	Atura la locaclització del manager
	*/
	func stopUpdatingLocation() {
		locationManager.stopUpdatingLocation()
	}
	
	/**
	Activa la localització del manager
	*/
	func startLocation() {
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager?.startUpdatingLocation()
	}
	
	/**
	Comprova si te permisos per ".authorizedWhenInUse" per la localització
	*/
	func havePermissions() -> Bool {
		return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
	}
	
	//----------------------------------
	// MARK: - CLLocationManagerDelegate
	//----------------------------------
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		case .authorizedWhenInUse:
			manager.startUpdatingLocation()
		case .restricted, .denied:
			let alert = UIAlertController(
				title: "locationServicesDisabledTitle".localized(),
				message: "locationServicesDisabledMessage".localized(),
				preferredStyle: UIAlertController.Style.alert
			)
			alert.addAction(UIAlertAction(title: "BKO".localized(), style: .default, handler: nil))
			alert.addAction(UIAlertAction(title: "BSETTINGS".localized(), style: .cancel, handler: { _ in
				if let url = URL(string:UIApplication.openSettingsURLString) {
					if UIApplication.shared.canOpenURL(url) {
						UIApplication.shared.open(url, options: [:], completionHandler: nil)
					}
				}
			}))
			controller?.present(alert, animated: true, completion: nil)
		default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let loc = locations.last
		
		latitude = Float(loc?.coordinate.latitude ?? 0.0)
		longitude = Float(loc?.coordinate.longitude ?? 0.0)
		
		delegate?.didUpdateLocations(locations: locations)
	}
	
}

protocol SixtemiaLocationDelegate {
	
	/**
	Funció que s'activa quan s'actulitza l'ubicacoó del dispositiu
	
	- Parameter locations: Localització actual del dispositiu
	*/
	func didUpdateLocations(locations: [CLLocation])
	
}
