//
//  CustomTextFieldBox.swift
//  SixtemiaWidgets
//
//  Created by Kevin Costa on 04/10/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextFieldBox: UIView {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var CS_HEIGHT_VIEW_TXT: NSLayoutConstraint!
	@IBOutlet weak var txtField: UITextField!
	@IBOutlet weak var viewMsg: UIView!
	@IBOutlet weak var lblMsg: UILabel!
	@IBOutlet var contentView: UIView!
	
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
	private var delegate: UITextFieldDelegate?
	private var showPassword: Bool = false
	private var focusColor: UIColor = .black
	private var unfocusColor: UIColor = .lightText
	private var msgColorOk: UIColor = UIColor(Hex: 0xA0BE3E)
	private var isShowingPwd: Bool = false
	
	/**
	Comprova si el camp del TextField està buit o no, retallan els espais buits
	*/
	var isEmpty: Bool {
		get { return txtField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true }
	}
	
	/**
	Defineix un text específic pel TextField. Es pot fer servir amb get i set
	*/
	var text: String {
		set { txtField.text = newValue }
		get { return txtField.text ?? "" }
	}
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
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
		let nib = UINib(nibName: "CustomTextFieldBox", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(view)
		txtField.layer.cornerRadius = 5.0
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/**
	Configuració bàsica per el TextField, tots els camps són opcionals menys el delegate que es obligatori
	
	- Parameter placeHolder: Placeholder per el TextField, per defecte es fica buit
	- Parameter delegate: Delegate per controlar els events del TextField
	- Parameter clearBtn: Tipus de visibilitat pel botó de netejar, per defecte .never
	- Parameter returnKey: Tipus de retorn pel TextField, per defecte es .default
	- Parameter keyboardType: Tipus de teclat per el TextField, per defecte .default
	- Parameter content: Contingut String que ha de tenir el TextField
	*/
	func configView(placeHolder: String? = "", delegate: UITextFieldDelegate, clearBtn: UITextField.ViewMode? = .never, returnKey: UIReturnKeyType? = .default, keyboardType: UIKeyboardType? = .default, content: String? = "", strLeftImg: String? = "") {
		self.delegate = delegate
		
		txtField.placeholder = placeHolder!
		txtField.delegate = self
		txtField.clearButtonMode = clearBtn!
		txtField.returnKeyType = returnKey!
		txtField.keyboardType = keyboardType!
		
		if let cnt = content, !cnt.isEmpty {
			txtField.text = cnt
		}
		
		if showPassword {
			configShowBtn()
			txtField.rightViewMode = .whileEditing
		}
		
		if !strLeftImg!.isEmpty {
			showIconTxtField(strNameImg: strLeftImg!)
		}
	}
	
	/**
	Comprova si el TextField està buit i posa el missatge d'error de camp buit

	- Returns: true si el camp està, en cas contrari false
	*/
	func isEmptyError() -> Bool{
		if isEmpty {
			showMsg("general.requieredField".localized(), isKO: true)
			return true
		}
		return false
	}
	
	/**
	Modifica la vista i posa un missatge de KO o OK depenent dels paràmetres de la funció i fa l'animació
	per mostrar el missatge que li arriba
	
	- Parameter msg: String amb el misssatge de KO o OK per el Textfield
	- Parameter isKO: Bool per definir si es KO o OK el missatge
	*/
	func showMsg(_ msg: String, isKO: Bool) {
		lblMsg.text = msg
		lblMsg.textColor = isKO ? .red : msgColorOk
		
		UIView.animate(withDuration: 0.3, animations: {
			self.CS_HEIGHT_VIEW_TXT.constant = 35
			self.txtField.layer.borderColor = isKO ? UIColor.red.cgColor : self.msgColorOk.cgColor
			self.txtField.layer.borderWidth = 2.0
			self.layoutIfNeeded()
		}, completion: { _ in
			UIView.animate(withDuration: 0.3, animations: {
				self.viewMsg.alpha = 1.0
			})
		})
	}
	
	/**
	Treu el color que té el TextField (OK o KO) i el deixa per defecte, s'amaga el camp del missatge.
	També es pot netejar el contingut del TextField en funció del paràmetre, per defecte false
	
	- Parameter cleanTxtField: true si es vol netejar el contingut del TextField, en cas contrari no es netejarà
	*/
	func cleanView(cleanTxtField: Bool? = false) {
		txtField.text = cleanTxtField! ? "" : txtField.text
		
		UIView.animate(withDuration: 0.3, animations: {
			self.viewMsg.alpha = 0.0
			self.txtField.layer.borderColor = self.unfocusColor.cgColor
			self.txtField.layer.borderWidth = 0.5
		}, completion: { _ in
			UIView.animate(withDuration: 0.3, animations: {
				self.CS_HEIGHT_VIEW_TXT.constant = 45
				self.layoutIfNeeded()
			})
		})
	}
	
	/**
	Es fa el focus sobre el TextField, i es canvia el bordeWidth i el border color del Textfield
	*/
	func focusTextField() {
		txtField.layer.borderWidth = 2.0
		txtField.layer.borderColor = focusColor.cgColor
	}
	
	/**
	Funció per realitzar l'acció de becomeFirstResponder al TextField
	*/
	func firstResponder() {
		txtField.becomeFirstResponder()
	}
	
	/**
	Mostrar la icona a la dreta del textfield per poder visualitzar el password, en el cas de que es tracti
	d'un textfield de contrasenya
	*/
	private func configShowBtn() {
		let showTextBtn = UIButton()
		showTextBtn.isUserInteractionEnabled = true
		showTextBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		showTextBtn.addTarget(self, action: #selector(showHideImgPwd), for: .touchUpInside)
		
		if isShowingPwd {
			showTextBtn.setImage(UIImage(named: "visibility_on"), for: .normal)
		} else {
			showTextBtn.setImage(UIImage(named: "visibility_off"), for: .normal)
		}
		
		txtField.rightView = showTextBtn
	}
	
	@objc private func showHideImgPwd() {
		txtField.isSecureTextEntry = isShowingPwd
		isShowingPwd = !isShowingPwd
		configShowBtn()
	}
	
	func showIconTxtField(strNameImg: String) {
		txtField.setLeftIcon(strNameImg)
	}
	
	//----------------------
	// MARK: - IBInspectable
	//----------------------
	
	@IBInspectable var textFieldTag: Int = 0 {
		didSet { self.txtField.tag = textFieldTag }
	}
	
	@IBInspectable var isSecureEntry: Bool = false {
		didSet { self.txtField.isSecureTextEntry = isSecureEntry }
	}
	
	@IBInspectable var showBtnPassword: Bool = false {
		didSet { self.showPassword = showBtnPassword }
	}
	
	@IBInspectable var msgColorOkTxt: UIColor = UIColor(Hex: 0xA0BE3E) {
		didSet { self.msgColorOk = msgColorOkTxt }
	}
	
	@IBInspectable var placeHolder: String = "" {
		didSet { self.txtField.placeholder = placeHolder }
	}
	
	@IBInspectable var viewColor: UIColor = .clear {
		didSet { self.contentView.backgroundColor = viewColor }
	}
	
	@IBInspectable var focusColorTxt: UIColor = .black {
		didSet { self.focusColor = focusColorTxt }
	}
	
	@IBInspectable var unfocusColorTxt: UIColor = .black {
		didSet { self.unfocusColor = unfocusColorTxt }
	}
}

	//----------------------------
	// MARK: - UITextFieldDelegate
	//----------------------------

extension CustomTextFieldBox: UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return delegate?.textFieldShouldBeginEditing?(textField) ?? true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		focusTextField()
		delegate?.textFieldDidBeginEditing?(textField)
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        cleanView()
		return delegate?.textFieldShouldEndEditing?(textField) ?? true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		delegate?.textFieldDidEndEditing?(textField)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		delegate?.textFieldDidEndEditing?(textField, reason: reason)
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
	}
	
	func textFieldDidChangeSelection(_ textField: UITextField) {
		if #available(iOS 13.0, *) {
			delegate?.textFieldDidChangeSelection?(textField)
		} else {
			// Fallback on earlier versions
		}
	}
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return delegate?.textFieldShouldClear?(textField) ?? true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return delegate?.textFieldShouldReturn?(textField) ?? true
	}
	
}
