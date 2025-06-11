//
//  DataManager+Airlaunch.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation

extension DataManager {
	
	func processWS11_NotificationCount(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
        guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
        do {
            let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WS11NotificationCount.self, from: data)
            
            //Crate a DataBase Objects
            
            if let total = wsResponse.total{
                SixtemiaOneSignalManager.shared.pendingPush = total
            }
            
            return [RESP_WS_RESULT: wsResponse.result == STR_OK ? STR_OK : STR_KO, RESP_WS_STR_MSG: wsResponse.strMsg ?? ""]
            
        } catch let err {
            print("Error: ", err)
        }
        return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
    }
    
    
    func processWS12_NotificationList(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
        guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
        do {
            let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WS12NotificationList.self, from: data)
            
            //Crate a DataBase Objects
            
            if let arrayNotification = wsResponse.arrayNotification{
                DBAirlaunchNotification.create(arrayNotification)
            }
            
            return [RESP_WS_RESULT: wsResponse.result == STR_OK ? STR_OK : STR_KO, RESP_WS_STR_MSG: wsResponse.strMsg ?? ""]
            
        } catch let err {
            print("Error: ", err)
        }
        return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
    }
    
    func processWS13_NotificationCategory(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
        guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
        do {
            let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WS13NotificationCategory.self, from: data)
            
            //Crate a DataBase Objects
            
            if let arrayCategory = wsResponse.arrayCategory{
                DBAirlaunchCategory.create(arrayCategory)
            }
            
            return [RESP_WS_RESULT: wsResponse.result == STR_OK ? STR_OK : STR_KO, RESP_WS_STR_MSG: wsResponse.strMsg ?? ""]
            
        } catch let err {
            print("Error: ", err)
        }
        return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
    }
	
}
