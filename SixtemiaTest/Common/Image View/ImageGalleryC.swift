//
//  ImageGalleryC.swift
//  mobappiios
//
//  Created by Kevin Costa on 03/06/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ImageGalleryC: BaseC {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var btnBack: UIButton!
	@IBOutlet weak var viewPagerController: UIView!
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	private var arrayStrImgs: [String]!
    private var arrayImg: [UIImage]!
	private var currentIndex: Int!
    private var isFromUrl: Bool!
	private var pageController = UIPageViewController()
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init(arrayStrImgs: [String], currentIndex: Int) {
        super.init(nibName: "ImageGalleryC", bundle: Bundle.main)
		self.arrayStrImgs = arrayStrImgs
		self.currentIndex = currentIndex
        self.isFromUrl = true
	}
    
    init(arrayImg: [UIImage], currentIndex: Int) {
        super.init(nibName: "ImageGalleryC", bundle: Bundle.main)
        self.arrayImg = arrayImg
        self.currentIndex = currentIndex
        self.isFromUrl = false
    }
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
		navigationController?.isNavigationBarHidden = true
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
		
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeCloseView))
		swipeDown.direction = .down
		self.view.addGestureRecognizer(swipeDown)
		
		setupPageController()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        UIApplication.shared.setStatusBar(style: .lightContent)
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	@IBAction func actionBtnBack(_ sender: Any) {
		let transition = CATransition()
		transition.duration = FADE_IN
		transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		transition.type = CATransitionType.fade
		self.navigationController?.view.layer.add(transition, forKey: nil)
		self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true)
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	@objc private func swipeCloseView() {
		actionBtnBack(UIButton())
	}
	
	private func setupPageController() {
		pageController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		pageController.dataSource = self
		pageController.setViewControllers([viewControllerAtIndex(currentIndex)], direction: .forward, animated: false, completion: nil)
		
		addChild(pageController)
		view.addSubview(pageController.view)
		pageController.didMove(toParent: self)
		pageController.view.frame = view.bounds
		
		addSubviewBase(pageController.view, toView: viewPagerController)
	}
	
	func viewControllerAtIndex(_ index: Int) -> UIViewController {
        if isFromUrl {
            let imageC = ImageViewerC(strUrlImg: arrayStrImgs![index])
            imageC.index = index
            
            return imageC
        }
		let imageC = ImageViewerC(img: arrayImg![index])
		imageC.index = index
		return imageC
	}
	
	func getIndexController(_ vc: UIViewController) -> Int {
		return (vc as! ImageViewerC).index
	}
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
}

extension ImageGalleryC: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		var index = getIndexController(viewController)
		currentIndex = index
		
		if index == 0 { return nil }
		
		// Decrease the index by 1 to return
		index -= 1
		return viewControllerAtIndex(index)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index = getIndexController(viewController)
		var maxElements = 0
		
		currentIndex = index
		index += 1
		
        if isFromUrl {
            maxElements = arrayStrImgs.count
        } else {
            maxElements = arrayImg.count
        }
		
		
		if index == maxElements { return nil }
		return viewControllerAtIndex(index)
	}
	
}
