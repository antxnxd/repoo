//
//  ImageViewerC.swift
//  mobappiios
//
//  Created by Kevin Costa on 18/06/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ImageViewerC: BaseC {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	private var imageView : UIImageView!
    private var image: UIImage!
	private var strUrlImg: String!
	private var sImage = UIImageView()
    private var isFromUrl: Bool!
	var index = 0
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init(strUrlImg: String) {
		super.init(nibName: "ImageViewerC", bundle: Bundle.main)
		self.strUrlImg = strUrlImg
        self.isFromUrl = true
	}
    
    init(img: UIImage) {
        super.init(nibName: "ImageViewerC", bundle: Bundle.main)
        self.image = img
        self.isFromUrl = false
    }
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
		let placeHolder = UIImage(named: "sabout_placeholder")
		imageView = UIImageView(image: placeHolder)
		imageView.backgroundColor = .clear
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDouebleTap(_:)))
		doubleTapGesture.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTapGesture)
		
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 3.0

		loadImage()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	private func loadImage() {
        if isFromUrl {
            if let url = URL(string: strUrlImg) {
                imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(FADE_IN))
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.getWidth(), height: UIScreen.main.getHeight())
                
                scrollView.addSubview(imageView)
            }
        } else {
            imageView.image = self.image
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.getWidth(), height: UIScreen.main.getHeight())
            scrollView.addSubview(imageView)
        }
	}
	
	@objc private func handleDouebleTap(_ gesture: UITapGestureRecognizer) {
		if scrollView.zoomScale == 1 {
			scrollView.zoom(to: zoomRectForScale(2.0, center: gesture.location(in: gesture.view)), animated: true)
		} else {
			scrollView.setZoomScale(1, animated: true)
		}
	}
	
	func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect = CGRect.zero
		zoomRect.size.height = imageView.frame.size.height / scale
		zoomRect.size.width = imageView.frame.size.width / scale
		let newCenter = scrollView.convert(center, from: imageView)
		zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
		zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
		return zoomRect
	}
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
}

extension ImageViewerC: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
}
