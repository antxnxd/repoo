//
//  API.swift
//  SixtemiaTest
//
//  Created by lluisborras on 19/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    //-----------------------
    // MARK: Variables
    //-----------------------
    
    internal var params: [String: Any] = [:]
    
    public static var shared: API = {
        return API.init()
    }()
    
    //-----------------------
    // MARK: - Methods
    //-----------------------
    
    public init() { }
    
    private func addCommonParams(){
        params[PARAM_LANG] = String(Locale.preferredLanguages[0].prefix(2))
        params[PARAM_VERSION] = NSNumber.init(value: WS_VERSION)
        params[PARAM_PLATFORM] = PLATFORM_IOS
    }
    
    func cancelTask(strAction: String) {
        DataManager.shared.cancelTask(strAction: strAction)
    }
    
    //-----------------------
    // MARK: - API Methods
    //-----------------------
    
    func ws_1_Login(strUsername: String, strPassword: String, completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        params = [:]
        
        addCommonParams()
        
        //Parameters for this ws
        params["strUsername"] = strUsername
        params["strPassword"] = strPassword
        
        DataManager.shared.getDataAPI(strAction: WS_1_LOGIN, parameters: params) { (result, error, strMsg, array) in completionHandler(result, error, strMsg, array)
        }
    }
}

//------------------------------
// MARK: - DataManager Extension
//------------------------------

extension DataManager {
    func process(data: Data?, paramsSent: [String: Any]? = nil, strAction: String, method: HTTPMethod) -> [String: Any] {
        switch strAction {
        case WS_11_NOTIFICATION_COUNT:
            return processWS11_NotificationCount(data: data, paramsSent: paramsSent)
        case WS_12_NOTIFICATION_LIST:
            return processWS12_NotificationList(data: data, paramsSent: paramsSent)
        case WS_13_NOTIFICATION_CATEGORY_LIST:
            return processWS13_NotificationCategory(data: data, paramsSent: paramsSent)
            
        case WS_1_LOGIN:
            return processWS1_Login(data:data, paramsSent: paramsSent)
            
        default:
            print("WS not implemented in APP")
            return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "WS not implemented in APP"]
        }
    }
}
