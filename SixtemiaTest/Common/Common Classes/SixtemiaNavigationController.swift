//
//  SixtemiaNavigationController.swift
//  SixtemiaTest
//
//  Created by Sergio Rovira on 4/3/23.
//  Copyright © 2023 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

class SixtemiaNavigationController: UINavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	override var childForStatusBarStyle: UIViewController? {
		return visibleViewController
	}
}
