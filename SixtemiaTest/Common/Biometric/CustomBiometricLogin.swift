//
//  CustomBiometricLogin.swift
//  SixtemiaWidgets
//
//  Created by Sergio Rovira on 14/10/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

struct KeychainConfiguration {
    static let serviceName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    static let accessGroup: String? = nil
}

@IBDesignable
class CustomBiometricLogin: UIView {

    //-----------------------
    // MARK: - OUTLETS
    //-----------------------
    
	@IBOutlet weak var btnBiometric: UIButton!
    @IBOutlet weak var lblBiometricType: UILabel!
    @IBOutlet weak var viewBiometric: CustomView!
    @IBOutlet weak var imgBiometric: UIImageView!
    
    
    //-----------------------
    // MARK: - VARIABLES
    //-----------------------
    
    let touchMe = BiometricIDAuth()
    let LAST_MAIL_LOGGED = "lastUserLogged"
    let BIOMETRIC_ACCEPTED = "biometricAccepted"
    
    var fromButtonId = false
    var controller = UIViewController()
    var txtUsername:UITextField? = nil
    var txtPassword:UITextField? = nil
    
    var touch_Image = UIImage.init(named: "TouchIcon")?.withRenderingMode(.alwaysTemplate)
    var face_Image = UIImage.init(named: "face_id")?.withRenderingMode(.alwaysTemplate)

    private var delegate: OnBiometricDelegate?
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomBiometricLogin", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        
    }
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    /**
    Configuració bàsica per la vista de accés biomètric, tots els camps són obligatoris
    
    - Parameter controller: UIViewController del pare
    - Parameter delegate: Delegate per controlar els events de la vista
    */
    
    func configBiometricView(controller: UIViewController, delegate: OnBiometricDelegate, txtUsername: UITextField, txtPassword: UITextField) {
        self.controller = controller
        self.delegate = delegate
        self.txtUsername = txtUsername
        self.txtPassword = txtPassword
        btnBiometric.tintColor = .white
        lblBiometricType.textColor = .white
        viewBiometric.backgroundColor = PRIMARY_COLOR
        
        imgBiometric.tintColor = .white
        
        switch touchMe.biometricType() {
        case .touchID:
            imgBiometric.image = touch_Image
			lblBiometricType.text = "Touch ID"
        case .faceID:
            imgBiometric.image = face_Image
			lblBiometricType.text = "Face ID"
        default:
            //btnBiometric.alpha = 0
            btnBiometric.isUserInteractionEnabled = false
        }
    }
    
    
    /*
     Desa les dades corresponents a l'accés de l'usuari en l'App (username i password).
     El nom d'usuari el desa en una variable "UserDefaults"  anomenada "lastMailLogged"
     */
    func saveData() {
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: (self.txtUsername?.text!)!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(self.txtPassword?.text ?? "" )
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        
        if fromButtonId {
            fromButtonId = false
            
            //Anem al menu autenticat
            print("Accedir a l'app")
            self.delegate?.enterInApp()
            
        } else {
            if touchMe.biometricType() != .none {
                
                touchMe.loginReason = touchMe.biometricType() == .touchID ? "biometric.saveTouchId".localized() : "biometric.saveFaceId".localized()
                touchMe.authenticateUser() { [weak self] message in
                    if let message = message {
                        //Anem al menu autenticat
                        if message == "biometric.defaultsUserCancel".localized() {
                            print("Accedir a l'app")
							DispatchQueue.main.async {
                                SixtemiaOneSignalManager.shared.setUserName(strName: self?.txtUsername?.text ?? "")
                                self?.delegate?.enterInApp()
							}
                        } else {
                            print("Accedir a l'app")
							
							DispatchQueue.main.async {
                                UserDefaults.standard.set(self?.txtUsername?.text, forKey: self?.LAST_MAIL_LOGGED ?? "lastUserLogged")
                                self?.delegate?.enterInApp()
							}
                        }
                    } else {
                        do {
                            // This is a new account, create a new keychain item with the account name.
                            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                    account: self?.txtUsername?.text ?? "",
                                                                    accessGroup: KeychainConfiguration.accessGroup)
                            
                            // Save the password for the new item.
                            try passwordItem.savePassword(self?.txtPassword?.text ?? "")
                        } catch {
                            fatalError("Error updating keychain - \(error)")
                        }
                        
                        UserDefaults.standard.set(self?.txtUsername?.text, forKey: self?.LAST_MAIL_LOGGED ?? "lastUserLogged")
                        UserDefaults.standard.set(true, forKey: self?.BIOMETRIC_ACCEPTED ?? "biometricAccepted")
                        
                        
                        //Anem al menu autenticat
                        print("Accedir a l'app")
						
						DispatchQueue.main.async {
                            self?.delegate?.enterInApp()
						}
                    }
                }
            }
        }
    }
    
    
    
    //----------------------
    // MARK: - IBInspectable
    //----------------------
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    /**
    Acció que es crida al fer click sobre el botó d'inici amb reconeixement biomètric
    */
	@IBAction func btnBiometricAction(_ sender: Any) {
		actionTouchID()
	}
	
    /**
    Inicia el reconeixement biomètric, si és correcte aquest fa ua crida al delegate per inciar sessió
    */
    func actionTouchID(){
        
        //fromButtonId = true
        touchMe.loginReason = "\("biometric.login".localized()) \(UserDefaults.standard.string(forKey: self.LAST_MAIL_LOGGED) ?? "")?"
        touchMe.authenticateUser() { [weak self] message in
            if let message = message {
                // if the completion is not nil show an alert
                if message == "Touch ID not available" {
                    let context = LAContext()
                    let reason:String = "biometric.disabled";
                    context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in })
                    
                } else {
                    self?.delegate?.showAlert(message: message)
                }
            } else {
                
                if let strLastMail = UserDefaults.standard.string(forKey: self?.LAST_MAIL_LOGGED ?? "lastMailLogged"){
                    
                    self?.txtUsername?.text = strLastMail
                    do {
                        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                account: strLastMail,
                                                                accessGroup: KeychainConfiguration.accessGroup)
                        let keychainPassword = try passwordItem.readPassword()
                        self?.txtPassword?.text = keychainPassword
                    }
                    catch {
                        fatalError("Error reading password from keychain - \(error)")
                    }
                    
                    //Crida de login
                    print("Login")
                    self?.delegate?.clickLogin(username: self?.txtUsername?.text ?? "" , password: self?.txtPassword?.text ?? "")
                    
                }
            }
        }
    }
}


protocol OnBiometricDelegate {
    func clickLogin(username : String, password: String)
    func showAlert(message : String)
    func enterInApp()
	//func actionBtnRememberPwd()
}


/*extension CustomBiometricLogin: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            //txtPassword.firstResponder()
        } else {
            self.controller.view.endEditing(true)
        }
        return true
    }
        
}*/
