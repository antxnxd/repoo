//
//  EmptyView.swift
//  SixtemiaTest
//
//  Created by Sergio Rovira on 9/1/23.
//  Copyright © 2023 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    var controller = UIViewController()
    
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
        let nib = UINib(nibName: "EmptyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    
    func configView(_ cont: UIViewController) {
        self.controller = cont
    }

}
