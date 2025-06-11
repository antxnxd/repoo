//
//  API+Airlaunch.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import Alamofire

extension API {
	
	//-----------------------
	// MARK: - API METHODS
	//-----------------------
	
	private func addCommonParamsAirlaunch() {
		params["strToken"] = AIRLAUNCH_ID
		params["strLang"] = String(Locale.preferredLanguages[0].prefix(2))
		params["strPlatform"] = PLATFORM_IOS
	}
	
	// MARK: 1.1 NOTIFICATION COUNT
	func ws11_Notification_Count(strDate: String, sdid: String, strFilter: String = "all", completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
		params = [:]
		
		addCommonParamsAirlaunch()
		
		//Parameters for this ws
		params["strDate"]                               = strDate
		params["sdid"]                                  = sdid
		params["strFilter"]                             = strFilter
		
		
		DataManager.shared.getDataAPI(strAction: WS_11_NOTIFICATION_COUNT, parameters: params) { (result, error, strMsg, array) in completionHandler(result, error, strMsg, array)
		}
	}
	
	// MARK: 1.2 NOTIFICATION LIST
	func ws12_Notification_List(strDate: String, sdid: String, strFilter: String = "all", completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
		params = [:]
		
		addCommonParamsAirlaunch()
		
		//Parameters for this ws
		params["strDate"]                               = strDate
		params["sdid"]                                  = sdid
		params["strFilter"]                             = strFilter
		
		DataManager.shared.getDataAPI(strAction: WS_12_NOTIFICATION_LIST, parameters: params) { (result, error, strMsg, array) in completionHandler(result, error, strMsg, array)
		}
	}
	
	// MARK: 1.3 NOTIFICATION CATEGORY LIST
	func ws13_Notification_Category_List(_ completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
		params = [:]
		
		addCommonParamsAirlaunch()
		
		//Parameters for this ws
		
		DataManager.shared.getDataAPI(strAction: WS_13_NOTIFICATION_CATEGORY_LIST, parameters: params) { (result, error, strMsg, array) in completionHandler(result, error, strMsg, array)
		}
	}
	
}
