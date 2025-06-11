//
//  DataManager+Access.swift
//  SixtemiaTest
//
//  Created by Sergio Rovira on 4/3/23.
//  Copyright © 2023 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation


extension DataManager {
    
    
    
    func processWS1_Login(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
        guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
        
        do {
            let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WSBaseResponse.self, from: data)
            
            //Crate a DataBase Objects
            print(wsResponse)
            
            return [RESP_WS_RESULT: STR_OK, RESP_WS_STR_MSG: wsResponse.msg ?? ""]
            
        } catch let err {
            print("Error - Name of the function: processWS_BaseError ==> ", err)
        }
        
        return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
            
    }
    
    
}
