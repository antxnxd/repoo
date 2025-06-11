//
//  KeyboardToolbar.swift
//  SixtemiaTest
//
//  Created by Avantiam on 9/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

//class KeyboardToolbar {
//    static func create(labelText: String, buttonTitle: String, target: Any?, action: Selector) -> UIToolbar {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        
//        // Left-side label
//        let label = UILabel()
//        label.text = labelText
//        label.textColor = .darkGray
//        let labelItem = UIBarButtonItem(customView: label)
//        
//        // Flexible space to push button to right
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        // Right-side button
//        let button = UIBarButtonItem(title: buttonTitle, style: .done, target: target, action: action)
//        
//        toolbar.items = [labelItem, flexSpace, button]
//        return toolbar
//    }
//}

    //enum KeyboardToolbarType {
    //    case
    //}
    //
    //class KeyboardToolbar: NSObject, UITextFieldDelegate {
    //
    //    //-----------------------
    //    // MARK: Variables
    //    //-----------------------
    //
    //    private weak var mainTextField: UITextField?
    //
    //    //-----------------------
    //    // MARK: Constants
    //    //-----------------------
    //
    //    private let rightTextField = UITextField()
    //
    //    //-----------------------
    //    // MARK: Init
    //    //-----------------------
    //
    //    init(attachedTo textField: UITextField) {
    //        super.init()
    //        self.mainTextField = textField
    //    }
    //
    //    //-----------------------
    //    // MARK: - Methods
    //    //-----------------------
    //
    //    func create(labelText: String, placeholder: String) -> UIToolbar {
    //        let toolbar = UIToolbar()
    //        toolbar.sizeToFit()
    //
    //        // Left-side label
    //        let label = UILabel()
    //        label.text = labelText
    //        label.textColor = .darkGray
    //        let labelItem = UIBarButtonItem(customView: label)
    //
    //        // Flexible space
    //        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //
    //        // Right-side text field
    //        rightTextField.placeholder = placeholder
    //        rightTextField.borderStyle = .roundedRect
    //        rightTextField.delegate = self
    //        rightTextField.frame = CGRect(x: 0, y: 0, width: 120, height: 32)
    //        let rightTextFieldItem = UIBarButtonItem(customView: rightTextField)
    //
    //        toolbar.items = [labelItem, flexSpace, rightTextFieldItem]
    //        return toolbar
    //    }
    //
    //    // Sync text when user finishes editing right text field
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        guard let mainTextField = mainTextField else { return }
    //        mainTextField.text = textField.text
    //    }
    //
    //    // Optionally sync live
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if let currentText = textField.text as NSString? {
    //            let newText = currentText.replacingCharacters(in: range, with: string)
    //            mainTextField?.text = newText
    //        }
    //        return true
    //    }
    //}
