//
//  DataManager+Base.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 6/9/21.
//  Copyright © 2021 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation

extension DataManager {
	
	func processWS_BaseError(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
		guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
		
		do {
			let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WSBaseResponse.self, from: data)
			
			//Crate a DataBase Objects
			
			
			return [RESP_WS_RESULT: STR_OK, RESP_WS_STR_MSG: wsResponse.msg ?? ""]
			
		} catch let err {
			print("Error - Name of the function: processWS_BaseError ==> ", err)
		}
		
		return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
			
	}
	
}
