//
//  APIDecode.swift
//  SixtemiaTest
//
//  Created by santi on 20/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

struct WSBaseResponse: Codable {
	var error                  	: String?
	var msg                  	: String?
	
	private enum CodingKeys: String, CodingKey {
		case error
		case msg
	}
}
