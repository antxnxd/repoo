//
//  TestC.swift
//  SixtemiaTest
//
//  Created by lluisborras on 19/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

class TestC: BaseC {
    
    //-----------------------
    // MARK: Outlets
    //-----------------------
    
    @IBOutlet weak var txtExample1: UITextField!
    
    //-----------------------
    // MARK: Variables
    //-----------------------
    
//    var keyboardToolbar: KeyboardToolbar?
    
    //-----------------------
    // MARK: Constants
    //-----------------------
    
    //-----------------------
    // MARK: Live App
    //-----------------------
    
    override func viewDidLoad() {
        print("viewDidLoad started")
        super.viewDidLoad()
        print("Called super.viewDidLoad()")
        navBarColor = PRIMARY_COLOR
        print("Set navBarColor")
        self.title = "Test View Controller"
        print("Set title to 'Test View Controller'")
        
//        txtExample1.delegate = self
//        print("Set txtExample1.delegate")
//        
//        keyboardToolbar = KeyboardToolbar(attachedTo: txtExample1)
//        print("Initialized keyboardToolbar with txtExample1")
//        txtExample1.inputAccessoryView = keyboardToolbar?.create(labelText: "Test", placeholder: "Placeholder  test")
//        print("Set inputAccessoryView with custom toolbar")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //-----------------------
    // MARK: Methods
    //-----------------------
    
    
    
    //-----------------------
    // MARK: Actions
    //-----------------------
    
}

//extension TestC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        dismissKeyboard()
//        return true
//    }
//}
