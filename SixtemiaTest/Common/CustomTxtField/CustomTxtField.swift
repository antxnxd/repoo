//
//  CustomTxtField.swift
//  vitefacturacio
//
//  Created by sergio on 21/4/21.
//  Copyright © 2021 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

enum fieldTypes {
    case text, password, email, number, decimal, date
}


class CustomTxtField: UIView {

    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    
    @IBOutlet weak var viewCustomField: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgField: UIImageView!
    @IBOutlet weak var viewSecureEntry: UIView!
    @IBOutlet weak var btnShowPwd: UIButton!
    
    
    @IBOutlet weak var stackValues: UIStackView!
    @IBOutlet weak var viewTxtField: UIView!
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var viewBtnValue: UIView!
    @IBOutlet weak var btnValue: UIButton!
    
    
    
    @IBOutlet weak var viewContent: CustomView!
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    var controller = UIViewController()
    var fieldType:fieldTypes = .text {
        didSet {
            txtField.placeholder = placeholder
        }
    }
    var placeholder = ""
    var delegate:UITextFieldDelegate?
    
    
    var text = "" {
        didSet {
            if self.text != "" {
                self.stackValues.isHidden = false
                self.txtField.text = text
                //self.lblTitle.font = UIFont.init(name: "Beatrice-Regular", size: 10.0)
                self.lblTitle.font = UIFont.init(name: "FrutigerLT-55Rm", size: 13)
                UIView.animate(withDuration: 0.10, delay: 0.3, options: [.allowUserInteraction]) {
                    self.viewSecureEntry.alpha = 1
                }
            } else {
                self.viewSecureEntry.alpha = 0
            }
            self.txtField.text = text
        }
    }
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    private var CONST_BAR_COLOR = UIColor.darkGray
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomTxtField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func configField(_ cont: UIViewController, delegate: UITextFieldDelegate? = nil, fieldType: fieldTypes = .text, title: String = "", text: String, placeholder: String = "", iconImg: UIImage, tag: Int = -1) {
        self.controller = cont
        self.fieldType = fieldType
        self.delegate = delegate
        self.placeholder = placeholder
        
        self.txtField.tag = tag
        
        viewCustomField.layer.cornerRadius = 15
        
        imgField.image = iconImg
        
        switch fieldType {
        case .text:
            viewSecureEntry.isHidden = true
            txtField.isSecureTextEntry = false
            txtField.keyboardType = .default
            viewBtnValue.isHidden = true
            viewContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapView)))
        case .password:
            viewSecureEntry.isHidden = false
            txtField.isSecureTextEntry = true
            txtField.keyboardType = .default
            txtField.autocapitalizationType = .none
            txtField.autocorrectionType = .no
            viewBtnValue.isHidden = true
            viewContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapView)))
        case .email:
            viewSecureEntry.isHidden = true
            txtField.isSecureTextEntry = false
            txtField.keyboardType = .emailAddress
            txtField.autocorrectionType = .no
            txtField.autocapitalizationType = .none
            viewBtnValue.isHidden = true
            viewContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapView)))
        case .number:
            viewSecureEntry.isHidden = true
            txtField.isSecureTextEntry = false
            txtField.keyboardType = .numberPad
            viewBtnValue.isHidden = true
            viewContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapView)))
        case .decimal:
            viewSecureEntry.isHidden = true
            txtField.isSecureTextEntry = false
            txtField.keyboardType = .decimalPad
            viewBtnValue.isHidden = true
            viewContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapView)))
        case .date:
            viewSecureEntry.isHidden = true
            txtField.isSecureTextEntry = false
            txtField.addInputViewDatePicker(target: self, selector: #selector(self.doneButtonPressed))
            viewBtnValue.isHidden = true
            viewContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapView)))
            
        default:
            break
            
        }
        
        lblTitle.text = title
        txtField.placeholder = placeholder
        
        if text != "" {
            self.text = text
        }
        
        
        
        txtField.delegate = self
    }
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    @objc func tapView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction]) {
            self.stackValues.isHidden = false
        } completion: { finish in
            self.txtField.becomeFirstResponder()
        }
        UIView.animate(withDuration: 0.10, delay: 0.3, options: [.allowUserInteraction]) {
            self.viewSecureEntry.alpha = 1
        }
        
        UIView.transition(with: lblTitle, duration: 0.2, options: [.transitionCrossDissolve]) {
            self.lblTitle.font = UIFont.init(name: "FrutigerLT-55Rm", size: 13)
        }
        
    }
    
    
    @IBAction func btnShowPwdAction(_ sender: UIButton) {
        txtField.isSecureTextEntry = !txtField.isSecureTextEntry
        if txtField.isSecureTextEntry {
            btnShowPwd.setImage(UIImage.init(named: "icon_ull_off")!, for: .normal)
        } else {
            btnShowPwd.setImage(UIImage.init(named: "icon_ull_on")!, for: .normal)
        }
    }
    
    //DATE
    @objc func doneButtonPressed() {
        if let datePicker = self.txtField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.txtField.text = dateFormatter.string(from: datePicker.date)
            delegate?.textFieldDidEndEditing?(txtField)
        }
        self.txtField.resignFirstResponder()
     }
    
    
    
}


extension CustomTxtField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField)
        tapView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            UIView.animate(withDuration: 0.15, delay: 0.10, options: [.allowUserInteraction]) {
                self.stackValues.isHidden = true
            }
            UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction]) {
                self.viewSecureEntry.alpha = 0
            }
            UIView.transition(with: lblTitle, duration: 0.15, options: [.transitionCrossDissolve]) {
                self.lblTitle.font = UIFont.init(name: "FrutigerLT-55Rm", size: 15)
            }
            
        }
        self.text = txtField.text ?? ""
        delegate?.textFieldDidEndEditing?(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
