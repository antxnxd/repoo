//
//  AirlaunchCategory.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

struct AirlaunchCategory: Codable {
	
	var idCategory			: Int64?
	var strTitle			: String?
	var isActive			: Bool?
	
	private enum CodingKeys: String, CodingKey {
		case idCategory = "id"
		case strTitle
	}
	
}
