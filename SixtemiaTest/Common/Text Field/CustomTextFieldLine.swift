//
//  CustomTextField.swift
//  redtallerios
//
//  Created by Kevin Costa on 17/07/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextFieldLine: UIView {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var lblMsg: UILabel!
	@IBOutlet weak var CS_HEIGHT_VIEW_TXT: NSLayoutConstraint!
	@IBOutlet weak var viewDivider: UIView!
	@IBOutlet weak var viewMsg: UIView!
	
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
	private var focusColor: UIColor = .black
	private var msgColorOk: UIColor = .green
	private var colorViewDivider: UIColor = UIColor(Hex: 0xDFDFDF)
	private var isShowingPwd: Bool = false
	private var showPassword: Bool = false
	private var delegate: UITextFieldDelegate?
    
    private var tintTextFieldColor : UIColor? = nil
	
	/**
	Defineix un text específic pel TextField. Es pot fer servir amb get i set
	*/
	var text: String {
		set { textField.text = newValue }
		get { return textField.text ?? "" }
	}
	
	/**
	Definix el tipus de visualització que tindra el button de netejar
	*/
	var clearButtonMode: UITextField.ViewMode {
		set { textField.clearButtonMode = newValue }
		get { return textField.clearButtonMode }
	}
	
	/**
	Comprova si el camp del TextField està buit o no, retallan els espais buits
	*/
	var isEmpty: Bool {
		get { return textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true }
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
		let nib = UINib(nibName: "CustomTextFieldLine", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(view)
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
	func configView(placeHolder: String? = "", delegate: UITextFieldDelegate, clearBtn: UITextField.ViewMode? = .never, returnKey: UIReturnKeyType? = .default, keyboardType: UIKeyboardType? = .default, content: String? = "") {
		self.delegate = delegate
		
		textField.placeholder = placeHolder!
		textField.delegate = self
		textField.clearButtonMode = clearBtn!
		textField.returnKeyType = returnKey!
		textField.keyboardType = keyboardType!
        
        if tintTextColor != nil {
            textField.tintColor = tintTextFieldColor
            textField.setClearButton(color: tintTextFieldColor!)
        }
		
		if let cnt = content, !cnt.isEmpty {
			textField.text = cnt
		}
		
		viewDivider.backgroundColor = colorViewDivider
		
		if showPassword {
			configShowBtn()
			textField.rightViewMode = .whileEditing
		}
	}
    
    override func layoutSubviews() {
        if tintTextColor != nil {
            textField.tintColor = tintTextColor
        }
          
    }    
	
	/**
	Comprova si el TextField està buit i posa el missatge d'error de camp buit

	- Returns: true si el camp està, en cas contrari false

	- Postcondition: Posa el missatge de camp buit si es dóna el cas
	*/
	func isEmptyError() -> Bool{
		if isEmpty {
			showMsg("general.requieredField".localized(), isKO: true)
			return true
		}
		return false
	}
	
	/**
	Funció per realitzar l'acció de becomeFirstResponder al TextField
	
	- Postcondition: El textfield té el focus
	*/
	func firstResponder() {
		textField.becomeFirstResponder()
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
			self.viewDivider.backgroundColor = isKO ? .red : self.msgColorOk
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
	
	- Postcondition: TextField queda amb l'aspecte per defecte, i el text del TextField netejat si es dóna el cas
	*/
	func cleanView(cleanTxtField: Bool? = false) {
		textField.text = cleanTxtField! ? "" : textField.text
		
		UIView.animate(withDuration: 0.3, animations: {
			self.viewMsg.alpha = 0.0
		}, completion: { _ in
			self.viewDivider.backgroundColor = self.colorSeparator
			UIView.animate(withDuration: 0.3, animations: {
				self.CS_HEIGHT_VIEW_TXT.constant = 50
				self.layoutIfNeeded()
			})
		})
	}
	
	/**
	Es fa el focus sobre el TextField, en aquest cas es canvia el color de la vista del divisor
	
	- Postcondition: Color de background de la view del divisor canviat per el color de focus
	*/
	func focusTextField() {
		viewDivider.backgroundColor = focusColor
	}
	
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
		
		textField.rightView = showTextBtn
	}
	
	@objc private func showHideImgPwd() {
		textField.isSecureTextEntry = isShowingPwd
		isShowingPwd = !isShowingPwd
		configShowBtn()
	}
	
	//----------------------
	// MARK: - IBInspectable
	//----------------------
	
	@IBInspectable var textFieldTag: Int = 0 {
		didSet { self.textField.tag = textFieldTag }
	}
	
	@IBInspectable var isSecureEntry: Bool = false {
		didSet { self.textField.isSecureTextEntry = isSecureEntry }
	}
	
	@IBInspectable var showBtnPassword: Bool = false {
		didSet { self.showPassword = showBtnPassword }
	}
	
	@IBInspectable var focusColorTxtField: UIColor = .black {
		didSet { self.focusColor = focusColorTxtField }
	}
	
	@IBInspectable var msgColorOkTxt: UIColor = .green {
		didSet { self.msgColorOk = msgColorOkTxt }
	}
	
	@IBInspectable var placeHolder: String = "" {
		didSet { self.textField.placeholder = placeHolder }
	}
	
	@IBInspectable var separatorIsHidden: Bool = false {
		didSet { self.viewDivider.isHidden = separatorIsHidden }
	}
	
	@IBInspectable var colorSeparator: UIColor = UIColor(Hex: 0xDFDFDF)  {
		didSet {
			self.viewDivider.backgroundColor = colorSeparator
			self.colorViewDivider = colorSeparator
		}
	}
	
	@IBInspectable var viewColor: UIColor = .clear {
		didSet { self.contentView.backgroundColor = viewColor }
	}
	
	@IBInspectable var alignCenter: Bool = false {
		didSet {
			if alignCenter {
				self.textField.textAlignment = .center
			}
		}
	}
    
    @IBInspectable var tintTextColor: UIColor? = nil {
        didSet { self.tintTextFieldColor = tintTextColor }
    }
    
}

	//----------------------------
	// MARK: - UITextFieldDelegate
	//----------------------------

extension CustomTextFieldLine: UITextFieldDelegate {
	
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
