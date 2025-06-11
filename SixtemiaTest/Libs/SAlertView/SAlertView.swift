//
//  SAlertView.swift
//
//  Created by Nicholas Wood on 11/09/2015.
//  Copyright (c) 2015 The White Wood. All rights reserved.
//

import UIKit

typealias SAlertAction = () -> Void

class SAlertView: UIViewController {
    
    
    
    //Alert
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewAlertText: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewAlertButtons: UIView!
    
    
    
    var buttons:[UIButton]!
    var actions:[SAlertAction]!
    
    static let sharedInstance = SAlertView()
    
    //Calling the designated initializer of same class
    convenience init() {
        self.init(nibName: "SAlertView", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Posem el fons negre amb un alpha de 0.7
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.layoutIfNeeded()

    }


    
    // MARK:- Methods
    
    
    func showAlert(title:String, message:String, buttonLabels:[String], actions:[SAlertAction]){
        
        self.view.alpha = 0
        
        addSubview(self.view, toView: (UIApplication.shared.keyWindow?.subviews.last)!)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 1
        }) { (Bool) -> Void in
        }
        
        for view in self.view.subviews
        {
            view.isHidden = true
        }
        viewAlert.isHidden = false
        
        self.lblTitle.text = title
        self.lblTitle.sizeToFit()
        
        self.lblDesc.text = message
        self.lblDesc.sizeToFit()
        
        
        
        if self.buttons != nil{
            for button in self.buttons{
                button.removeFromSuperview()
            }
        }
        
        self.buttons = []
        self.actions = actions
        
        
        
        for i in 0...buttonLabels.count - 1 {
            let button:UIButton = UIButton()
            button.setTitle(buttonLabels[i], for: UIControl.State.normal)
            button.setTitleColor(UIColor.init(Hex: 0x000000), for: .normal)
            
            button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 15)

            button.setBackgroundColor(UIColor.white, forState: .normal)
            button.setBackgroundColor(UIColor.white.withAlphaComponent(0.7), forState: .highlighted)
            
            
            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44)
            button.addConstraint(heightConstraint)
            
            self.buttons.append(button)
            button.addTarget(self, action: #selector(self.button_press_handler(target:)), for: UIControl.Event.touchUpInside)
        }
        
        addButtons(self.buttons, atViewContent: viewAlertButtons)
        
        
    }
    
    func addSubview(_ newSubview: UIView, toView container: UIView) {
        newSubview.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(newSubview)
        
        let views = ["newSubview": newSubview]
        
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[newSubview]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[newSubview]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    
    
    
    
    func addButtons(_ arrayButtons:[UIButton], atViewContent viewContainer:UIView) {
        for v in viewContainer.subviews{
            v.removeFromSuperview()
        }
        
        var strConstraint = "V:|"
        
        var subViews = [String: AnyObject]()
        
        for index in 0...arrayButtons.count - 1 {
            let btn = arrayButtons[index]
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            viewContainer.addSubview(btn)
            let views = ["view\(index)" : btn]
            
            viewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view\(index)]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
            
            let featName = "view\(index)"
            var viewName = ""
            
            if index == 0 {
                if arrayButtons.count > 1 {
                    viewName = "-0-[\(featName)]-"
                }
                else {
                    viewName = "-0-[\(featName)]"
                }
            }
            else if index < arrayButtons.count - 1 {
                viewName = "1-[\(featName)]-"
            }
            else {
                viewName = "1-[\(featName)]"
            }
            
            strConstraint = strConstraint + viewName
            subViews[featName] = btn
            
        }
        
        strConstraint = strConstraint + "-0-|"
        
        viewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: strConstraint, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: subViews))
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK:- Handlers
    
    @objc func button_press_handler(target: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            //self.container.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y + 50)
            self.view.alpha = 0
        }) { (Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        }
        
        if self.actions.count == 0{
            return
        }
        
        var i = 0
        for btn in self.buttons
        {
            if btn == target
            {
                let action = self.actions[i]
                action()
            }
            
            i += 1
        }
        
    }
    
    



    
    @IBAction func dismiss(_ sender:Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            //self.container.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y + 50)
            self.view.alpha = 0
        }) { (Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
}
