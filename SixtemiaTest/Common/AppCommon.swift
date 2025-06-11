//
//  AppCommon.swift
//  SixtemiaTest
//
//  Created by Avantiam on 9/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation

class AppCommon: NSObject {
    
    //-----------------------
    // MARK: Constants
    //-----------------------
    
    let NOTIFICATION_FCMTOKEN           : String = "notification_firebase_fcmtoken"
    let RETRY_COUNT                     : String = "retry_count"
    let USER_LOGED_TOKEN                : String = "user_loged_token"
    
    //-----------------------
    // MARK: - Init
    //-----------------------
    
    public static var shared: AppCommon = {
        return AppCommon.init()
    }()
    
    override init() {
        super.init()
    }
    
    //-----------------------
    // MARK: Variables
    //-----------------------
    
    var retryCount: Int {
        get {
            if let value = UserDefaults.standard.value(forKey: RETRY_COUNT) as? Int {
                return value
            } else {
                return 0
            }
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: RETRY_COUNT)
        }
    }
    
    
    var notification_fcm_token: String? {
        get {
            if let value = UserDefaults.standard.value(forKey: NOTIFICATION_FCMTOKEN) as? String {
                return value
            } else {
                return nil
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: NOTIFICATION_FCMTOKEN)
        }
    }
    
    var token: String? {
        get {
            if let value = UserDefaults.standard.value(forKey: USER_LOGED_TOKEN) as? String {
                return value
            } else {
                return nil
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: USER_LOGED_TOKEN)
        }
    }
}
