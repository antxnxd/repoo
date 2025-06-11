//
//  AppConfig.swift
//  SixtemiaTest
//
//  Created by lluisborras on 18/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ERROR CODES

let ERROR_CODE_INTERNET_CONNECTION      	: Int           = 1
let ERROR_CODE_GENERIC                  	: Int           = 2
let ERROR_CODE_SESSION_EXPIRED          	: Int           = 3

// MARK: - APP KEYS

#if DEBUG
let FLURRY_API_KEY                  	: String        = ""
let AIRLAUNCH_ID                    	: String        = "456ff4bd-4333-4827-837d-06d78c8b0752"
let URL_BASE                        	: String        = "http://private-58b29-iessoapp.apiary-mock.com/api"
let URL_BASE_PUSH                   	: String        = "https://api.airlaunch.io/"
#else
let FLURRY_API_KEY                  	: String        = ""
let AIRLAUNCH_ID                    	: String        = "456ff4bd-4333-4827-837d-06d78c8b0752"
let URL_BASE                        	: String        = ""
let URL_BASE_PUSH                   	: String        = "https://api.airlaunch.io/"
#endif

// MARK: - CONSTANTS
let WS_VERSION                      	: Double        	= 1.0
let STR_OK                          	: String        	= "OK"
let STR_KO                          	: String        	= "KO"
let PLATFORM_IOS                    	: String        	= "ios"
let FADE_IN							: Double			= 0.3
let PRIMARY_COLOR						: UIColor		= UIColor.init(named: "PRIMARY_COLOR") ?? .green
let SECONDARY_COLOR					: UIColor		= UIColor.init(named: "SECONDARY_COLOR") ?? .green
let BACKGROUND_COLOR                 	: UIColor       	= UIColor.init(named: "BACKGROUND_COLOR") ?? .green


// MARK: - WS
let WS_TEST                            	: String        = "testDecode.json"
let WS_11_NOTIFICATION_COUNT            	: String        = "app/notification/count"
let WS_12_NOTIFICATION_LIST             	: String        = "app/notification/list"
let WS_13_NOTIFICATION_CATEGORY_LIST    	: String        = "app/category/list"


let WS_1_LOGIN                          	: String        = "/access/login"


// MARK: - WS GLOBAL PARAM
let PARAM_VERSION                       	: String        = "ver"
let PARAM_LANG                          	: String        = "lang"
let PARAM_TOKEN                         	: String        = "token"
let PARAM_PLATFORM                      	: String        = "platform"


// MARK: - WS GLOBAL RESP
let RESP_WS_RESULT                      	: String        = "result"
let RESP_WS_STR_MSG                     	: String        = "strMsg"
let RESP_ARRAY_RESULT                   	: String        = "arrayResult"
let RESP_TOKEN                          	: String        = "token"


// MARK: - WS PARAM


// MARK: - WS RESP


// MARK: - USER DEFAULTS KEYS
let USER_LOGED_ID                       	: String        = "userLogedId"
let USER_LOGED_USERNAME                 	: String        = "userLogedUsername"
let LAST_USER_LOGGED                    	: String        = "lastUserLogged"

// MARK: - ONESIGNAL
let K_DATE								: String			= "kDateAirlaunch"
let USER_NAME_ONESIGNAL					: String			= "Username"
let LANGUAGE_ONESIGNAL					: String			= "Language"
let APP_VERSION_ONESIGNAL					: String			= "AppVersion"
