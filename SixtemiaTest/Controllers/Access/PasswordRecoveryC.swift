//
//  PasswordRecoveryC.swift
//  nussliios
//
//  Created by Kevin Costa on 11/11/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PasswordRecoveryC: BaseC {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblDescription: UILabel!
	@IBOutlet weak var txtField: CustomTextFieldBox!
	@IBOutlet weak var btnSend: CustomUIButton!
	@IBOutlet var CS_BTN_WIDTH: NSLayoutConstraint!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var CS_BTN_LEADING: NSLayoutConstraint!
	@IBOutlet var CS_BTN_TRAILING: NSLayoutConstraint!
	
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init() {
		super.init(nibName: "PasswordRecoveryC", bundle: Bundle.main)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
		configBackButtonLight(true)
		navBarColor = .clear
		self.title = "recovery.title".localized()
		lblTitle.text = "recovery.lbl.title".localized()
		lblDescription.text = "recovery.lbl.description".localized()
		btnSend.setTitle("recovery.btn.send".localized(), for: .normal)
		
		txtField.configView(placeHolder: "recovery.btn.email".localized(), delegate: self, returnKey: .send, keyboardType: .emailAddress, strLeftImg: "mail")
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	@IBAction func actionBtnSend(_ sender: Any) {
		ws12Recovery()
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	private func ws12Recovery() {
		let isEmailOk = txtField.isEmptyError()
		
		if !isEmailOk {
			animateView(type: .viewLoading)
			
			// AQUEST TROS S'HA DE SUBSTITUIR PER LA CRIDA AL WS
			SAlertView.sharedInstance.showAlert(title: "", message: "recovery.success".localized(), buttonLabels: ["BOK".localized()], actions: [{self.popController()}])
			animateView(type: .viewContent)
		}
	}
	
	private func animateView(type: viewType) {
		CS_BTN_WIDTH.isActive = type == .viewLoading
		CS_BTN_LEADING.isActive = type != .viewLoading
		CS_BTN_TRAILING.isActive = type != .viewLoading
		let titleBtn = type == .viewLoading ? "" : "recovery.btn.send".localized()
		
		UIView.animate(withDuration: FADE_IN) {
			self.btnSend.setTitle(titleBtn, for: .normal)
			self.activityIndicator.alpha = type == .viewLoading ? 1.0 : 0.0
			self.view.layoutIfNeeded()
		}
	}
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
	override func processWSResponse(strAction: String, result: AFResult<Data>, error: NSError?, strMsg: String?, array: [Any]?) {
		super.processWSResponse(strAction: strAction, result: result, error: error, strMsg: strMsg, array: array)
		animateView(type: .viewContent)
		
		switch result {
		case .success:
			if error != nil {
				print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = KO")
				SAlertView.sharedInstance.showAlert(title: "", message: error?.domain ?? "defaultErrorMsg".localized(), buttonLabels: ["BOK".localized()], actions: [{}])
			} else {
				print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = OK")
				SAlertView.sharedInstance.showAlert(title: "", message: "recovery.success".localized(), buttonLabels: ["BOK".localized()], actions: [{self.popController()}])
			}
		case .failure:
			print("\(self) >>> processWSResponse\nWS - \(strAction) = KO | Result = ?")
			SAlertView.sharedInstance.showAlert(title: "", message: error?.domain ?? "defaultErrorMsg".localized(), buttonLabels: ["BOK".localized()], actions: [{}])
		}
	}
}

extension PasswordRecoveryC: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		ws12Recovery()
		return true
	}
}
