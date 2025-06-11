//
//  APIDecodeAirlaunch.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//


struct WS11NotificationCount: Codable {
    var result                  : String?
    var token                   : String?
    var strMsg                  : String?
    var total                   : Int?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case token
        case strMsg
        case total
    }
}

struct WS12NotificationList: Codable {
    var result                  : String?
    var token                   : String?
    var strMsg                  : String?
    var arrayNotification       : [AirlaunchNotification]?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case token
        case strMsg
        case arrayNotification
    }
}

struct WS13NotificationCategory: Codable {
    var result                  : String?
    var token                   : String?
    var strMsg                  : String?
    var arrayCategory           : [AirlaunchCategory]?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case token
        case strMsg
        case arrayCategory
    }
}
