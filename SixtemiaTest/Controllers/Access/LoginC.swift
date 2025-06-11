//
//  LoginC.swift
//  nussliios
//
//  Created by Kevin Costa on 08/11/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import IQKeyboardManagerSwift

class LoginC: BaseC {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnPasswordRecovery: UIButton!
    @IBOutlet weak var viewBiometric: CustomBiometricLogin!
    @IBOutlet weak var btnLogin: CustomUIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	var firstTime = true
	
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init() {
		super.init(nibName: "LoginC", bundle: Bundle.main)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
        viewBiometric.configBiometricView(controller: self, delegate: self, txtUsername: txtUsername, txtPassword: txtPassword)
        txtUsername.placeholder = "login.txtField.email".localized()
        txtPassword.placeholder = "login.txtField.password".localized()
        btnPasswordRecovery.setTitle("login.btn.rememberPwd".localized(), for: .normal)
        
        activityIndicator.alpha = 0
        
        //Biometric config
        if let strLastEmail = UserDefaults.standard.string(forKey: LAST_USER_LOGGED){
            txtUsername.text = strLastEmail
            viewBiometric.isHidden = false
        } else {
            viewBiometric.isHidden = true
        }
        
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        
    }
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
    @IBAction func btnLoginAction(_ sender: Any) {
        /*if let user = txtUsername.text, let pwd = txtPassword.text {
            ws11AccessLogin(strUser: user, strPwd: pwd)
        } else {
            SAlertView.sharedInstance.showAlert(title: "No data", message: "Missing login data", buttonLabels: ["BOK".localized()], actions: [])
        }*/
        
        appLog(tag: .stop)
    }
    
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	private func ws11AccessLogin(strUser: String, strPwd: String) {
        self.btnLogin.setTitle("", for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.activityIndicator.alpha = 1
        }, completion: nil)
        
        // AQUEST TROS S'HA DE SUBSTITUIR PER LA CRIDA AL WS
        
        API.shared.ws_1_Login(strUsername: strUser, strPassword: strPwd) { result, error, strMsg, array in
            self.processWSResponse(strAction: WS_1_LOGIN, result: result, error: error, strMsg: strMsg, array: array)
        }
        
	}
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
	override func processWSResponse(strAction: String, result: AFResult<Data>, error: NSError?, strMsg: String?, array: [Any]?) {
		super.processWSResponse(strAction: strAction, result: result, error: error, strMsg: strMsg, array: array)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.activityIndicator.alpha = 0
        }, completion: {(finish) in
            self.btnLogin.setTitle("login.btn.login".localized(), for: .normal)
        })
		
		switch result {
		case .success:
			if error != nil {
				print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = KO")
				SAlertView.sharedInstance.showAlert(title: "", message: error?.domain ?? "defaultErrorMsg".localized(), buttonLabels: ["BOK".localized()], actions: [{}])
			} else {
				print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = OK")
                viewBiometric.saveData()
			}
		case .failure:
			print("\(self) >>> processWSResponse\nWS - \(strAction) = KO | Result = ?")
			SAlertView.sharedInstance.showAlert(title: "", message: error?.domain ?? "defaultErrorMsg".localized(), buttonLabels: ["BOK".localized()], actions: [{}])
		}
	}
}

extension LoginC: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.tag == 0 {
            txtPassword.becomeFirstResponder()
		} else {
			self.view.endEditing(true)
		}
		return true
	}
	
}

extension LoginC: OnBiometricDelegate {
	
	func clickLogin(username: String, password: String) {
		ws11AccessLogin(strUser: username, strPwd: password)
	}
	
	func showAlert(message: String) {
		print(message)
	}
	
    func enterInApp() {
        SixtemiaOneSignalManager.shared.setUserName(strName: self.txtUsername?.text ?? "")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = UINavigationController.init(rootViewController: TestWSC())
        appDelegate.window?.makeKeyAndVisible()
        UIView.transition(with: appDelegate.window!, duration: FADE_IN, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
	
}
