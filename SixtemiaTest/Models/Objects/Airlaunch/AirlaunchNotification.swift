//
//  AirlaunchNotification.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

struct AirlaunchNotification: Codable {
	
	var nid 				: String?
    var strDate				: String?
    var strTitle			: String?
    var strDesc				: String?
    var strCode				: String?
    var strValue			: String?
    var strUrlImg			: String?
	
	private enum CodingKeys: String, CodingKey {
		case nid
        case strDate
        case strTitle
        case strDesc
        case strCode
        case strValue
        case strUrlImg
	}
	
}
