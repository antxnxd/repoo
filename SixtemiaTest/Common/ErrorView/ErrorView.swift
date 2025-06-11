//
//  ErrorView.swift
//  veterapp
//
//  Created by Sergio Rovira on 13/4/22.
//  Copyright © 2022 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

typealias ErrorViewAction = () -> Void


class ErrorView: UIView {

    
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnRetry: CustomUIButton!
    
    
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    var controller = UIViewController()
    var errorAction:ErrorViewAction? = nil
    
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
        let nib = UINib(nibName: "ErrorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    @IBAction func btnTryAgainAction(_ sender: Any) {
        errorAction!()
    }
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    
    func configView(_ cont: UIViewController, action: @escaping ErrorViewAction) {
        self.controller = cont
        self.errorAction = action
    }
    

}
