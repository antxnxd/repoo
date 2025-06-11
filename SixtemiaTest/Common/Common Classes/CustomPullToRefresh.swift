//
//  CustomPullToRefresh.swift
//  teisacustomersios
//
//  Created by santi on 3/9/18.
//  Copyright © 2018 MOTTO. All rights reserved.
//

/*import UIKit
import PullToRefresh

class CustomRefreshView: UIView {
    
    var refreshColor: UIColor = .white
    
    fileprivate(set) lazy var activityIndicator: UIActivityIndicatorView! = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.tintColor = refreshColor
        activityIndicator.color = refreshColor
        self.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    override func layoutSubviews() {
        centerActivityIndicator()
        setupFrame(in: superview)
        
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        centerActivityIndicator()
        setupFrame(in: superview)
    }
}

private extension CustomRefreshView {
    
    func setupFrame(in newSuperview: UIView?) {
        guard let superview = newSuperview else { return }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: superview.frame.width, height: frame.height)
    }
    
    func centerActivityIndicator() {
        activityIndicator.center = convert(center, from: superview)
    }
}

class CustomViewAnimator: RefreshViewAnimator {
    
    fileprivate let refreshView: CustomRefreshView
    
    init(refreshView: CustomRefreshView) {
        self.refreshView = refreshView
    }
    
    func animate(_ state: State) {
        switch state {
        case .initial:
            refreshView.activityIndicator.stopAnimating()
            
        case .releasing(let progress):
            refreshView.activityIndicator.isHidden = false
            
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: progress, y: progress)
            transform = transform.rotated(by: CGFloat(Double.pi) * progress * 2)
            refreshView.activityIndicator.transform = transform
            
        case .loading:
            refreshView.activityIndicator.startAnimating()
            
        case .finished:
            refreshView.activityIndicator.stopAnimating()
        }
    }
}

*/
