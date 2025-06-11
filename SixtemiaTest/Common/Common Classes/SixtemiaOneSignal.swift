//
//  SixtemiaOneSignal.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import OneSignal
import UIKit

class SixtemiaOneSignalManager {
	
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    private var pending: Int = 0
    var pendingPush: Int {
        set { pending = newValue }
        get { return pending }
    }
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    /**
    Singleto de la classe
    */
    public static let shared = SixtemiaOneSignalManager()
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    private init() { }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    /**
    Realitza la configuració de OneSignal amb opcions de l'AppDelegate
    
    - Parameter launchOptions: Opcions de l'AppDelegate
    */
    func setupOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let strDateInstall = UserDefaults.standard.string(forKey: K_DATE){
            print("\nData instalacio \(strDateInstall)")
        } else {
            configDateInstall()
        }
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
                
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body ?? "")")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            // Realitzar una acció quan es faci tap sobre una notificació
            
            //            if DBUser.getCurrentDBUser() != nil {
            //                if let navC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController,
            //                    let home = navC.topViewController as? HomeViewC  {
            //                    home.showMenuSection(type: .notifications)
            //                } else {
            //                    let navC = UINavigationController(rootViewController: LoginC())
            //                    self.window?.rootViewController = navC
            //                    self.window?.makeKeyAndVisible()
            //                }
            //            } else {
            //                let navC = UINavigationController(rootViewController: LoginC())
            //                self.window?.rootViewController = navC
            //                self.window?.makeKeyAndVisible()
            //            }
        }
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: AIRLAUNCH_ID,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        OneSignal.sendTags([LANGUAGE_ONESIGNAL : String(Locale.preferredLanguages[0].prefix(2))]);
        OneSignal.sendTags([APP_VERSION_ONESIGNAL : Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""]);
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /**
    Defineix un usuari per OneSignal
    
    - Parameter strName: Nom de l'usuari
    */
    func setUserName(strName: String) {
        OneSignal.sendTags([USER_NAME_ONESIGNAL : strName.lowercased()]);
    }
    
    /**
    Elimina l'usuari que ha fet login amb OneSignal
    */
    func removeUserName() {
        OneSignal.sendTags([USER_NAME_ONESIGNAL : ""]);
    }
    
    /**
    Defineix un per OneSignal
    
    - Parameter strPrefix: Idioma per OneSignal
    */
    func setLanguage(strPrefix: String) {
        OneSignal.sendTags([LANGUAGE_ONESIGNAL : strPrefix]);
    }
    
    /**
    Configura la data d'instal·lació per OneSignal
    */
    func configDateInstall() {
        let dateFormatterPrint = DateFormatter()
        let lang = String(Locale.preferredLanguages[0].prefix(2))
        let currentLocale = lang == "es" ? "es_ES" : "ca_ES"
        dateFormatterPrint.locale = Locale(identifier: currentLocale)
        dateFormatterPrint.dateFormat = "yyyyMMddHHmmss"
        UserDefaults.standard.set(dateFormatterPrint.string(from: Date()), forKey: K_DATE)
    }
    
    func getUserId() -> String {
        return OneSignal.getUserDevice().getUserId()
    }
    
    func getLastNotiDate() -> String {
        let lastNotiDate = DBAirlaunchNotification.getAllAsObjs().first?.strDate ?? ""
        
        if lastNotiDate == "" {
            return UserDefaults.standard.string(forKey: K_DATE) ?? ""
        }
        
        return lastNotiDate
    }
}

