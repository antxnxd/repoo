//
//  LoadingView.swift
//  veterapp
//
//  Created by Sergio Rovira on 12/4/22.
//  Copyright © 2022 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LoadingView: UIView {
    
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var viewAnimation: UIView!
    
    
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    let animationView = LottieAnimationView(name: "loading")
    
    
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
        let nib = UINib(nibName: "LoadingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = viewAnimation.frame
    }
    
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    
    func configView() {
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: viewAnimation.frame.width, height: viewAnimation.frame.height)
        self.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
        self.setNeedsLayout()
    }
    
    
}
