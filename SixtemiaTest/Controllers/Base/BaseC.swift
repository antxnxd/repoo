//
//  BaseC.swift
//  SixtemiaTest
//
//  Created by santi on 19/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import Alamofire

enum viewType {
    case unknown, viewContent, viewLoading, viewError, viewEmpty
}

class BaseC: UIViewController, UIGestureRecognizerDelegate {
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    /// Changing Status Bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    var navBarColor: UIColor? = nil
    var titleBarColor: UIColor? = nil
    var navBarFont:UIFont = UIFont.systemFont(ofSize: 17)
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBarColor = .white
        UIApplication.shared.setStatusBar(style: .default)
        
        navigationController?.hairLine(hide: true)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        if navBarColor != nil {
            if (navBarColor == UIColor.clear) {
                if #available(iOS 13.0, *) {
                    let navBarAppearance = UINavigationBarAppearance()
                    navBarAppearance.configureWithTransparentBackground()
                    navBarAppearance.backgroundColor = .clear
                    navBarAppearance.shadowColor = nil
                    navBarAppearance.shadowImage = UIImage()
                    navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: navBarFont, NSAttributedString.Key.foregroundColor : titleBarColor ?? .clear]
                    self.navigationController?.navigationBar.standardAppearance = navBarAppearance
                    self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
                } else {
                    navigationController?.navigationBar.isTranslucent = true
                    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    navigationController?.navigationBar.shadowImage = UIImage()
                }
            } else {
                if #available(iOS 13.0, *) {
                    let navBarAppearance = UINavigationBarAppearance()
                    navBarAppearance.configureWithOpaqueBackground()
                    navBarAppearance.backgroundColor = navBarColor
                    navBarAppearance.shadowColor = nil
                    navBarAppearance.shadowImage = UIImage()
                    navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: navBarFont, NSAttributedString.Key.foregroundColor : titleBarColor ?? .clear]
                    self.navigationController?.navigationBar.standardAppearance = navBarAppearance
                    self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
                } else {
                    navigationController?.navigationBar.isTranslucent = false
                    
                    if let navBar = navigationController?.navigationBar {
                        navBar.setBackgroundImage(UIImage(color: navBarColor!), for: .default)
                    }
                }
            }
        } else {
            var colors = [UIColor]()
            colors.append(PRIMARY_COLOR)
            colors.append(SECONDARY_COLOR)
            
            if #available(iOS 13.0, *) {
                let gradientLayer = CAGradientLayer(frame: UIScreen.main.bounds, colors: colors)
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = navBarColor
                navBarAppearance.shadowColor = nil
                navBarAppearance.shadowImage = UIImage()
                navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: navBarFont, NSAttributedString.Key.foregroundColor : titleBarColor ?? .clear]
                navBarAppearance.backgroundImage = gradientLayer.creatGradientImage()
                self.navigationController?.navigationBar.standardAppearance = navBarAppearance
                self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            } else {
                navigationController?.navigationBar.isTranslucent = false
                navigationController?.navigationBar.shadowImage = UIImage()
                
                if (navigationController?.navigationBar) != nil {
                    let gradientLayer = CAGradientLayer(frame: UIScreen.main.bounds, colors: colors)
                    navigationController?.navigationBar.setBackgroundImage( gradientLayer.creatGradientImage(), for: .default)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (navigationController?.viewControllers.count)! > 1 {
            /// Activem el popviewcontroller (BACK) per swipe
            navigationController?.interactivePopGestureRecognizer!.isEnabled = true
            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
        else {
            /// Desactivem el popviewcontroller (BACK) per swipe
            navigationController?.interactivePopGestureRecognizer!.isEnabled = false
            navigationController?.interactivePopGestureRecognizer!.delegate = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func addSubviewBase(_ newSubview: UIView, toView container: UIView) {
        newSubview.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(newSubview)
        
        let views = ["newSubview": newSubview]
        
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[newSubview]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[newSubview]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func restrictRotation(_ restriction: RotationType) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.restrictRotation = restriction
    }
    
    
    func configBackButtonLight(_ light: Bool) {
        var img = UIImage(named: "back_light")?.withRenderingMode(.alwaysOriginal)
        
        if !light {
            img = UIImage(named: "back_dark")?.withRenderingMode(.alwaysOriginal)
        }
        
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.popController))
        navigationItem.leftBarButtonItem = btn
    }
    
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func logout() {
        // DBUser.deleteCurrentUser()
        DBAirlaunchCategory.deleteAll()
        DBAirlaunchNotification.deleteAll()
        SixtemiaOneSignalManager.shared.removeUserName()
        SixtemiaOneSignalManager.shared.configDateInstall()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = UINavigationController.init(rootViewController: LoginC())
        appDelegate.window?.makeKeyAndVisible()
        UIView.transition(with: appDelegate.window!, duration: FADE_IN, options: .transitionCrossDissolve, animations: nil, completion: nil)
        appLog(tag: .success, "Logout")
    }
    
    //-----------------------
    // MARK: - DATAMANAGER
    //-----------------------
    
    func processWSResponse(strAction: String, result: AFResult<Data>, error: NSError?, strMsg: String?, array: [Any]?) {
        switch result {
        case .success:
            switch strAction {
            case WS_TEST:
                if error != nil {
                    appLog(tag: .error, error?.domain ?? "".localized())
                } else {
                    appLog(tag: .success)
                }
            default:
                break
            }
        case .failure:
            appLog(tag: .error, error?.domain ?? "".localized())
            
            if error?.code == ERROR_CODE_SESSION_EXPIRED {
                SAlertView.sharedInstance.showAlert(title: "", message: error?.domain ?? "", buttonLabels: ["BOK".localized()], actions: [{
                    self.logout()
                }])
            }
        }
    }
}

