//
//  ApiImageVC.swift
//  SixtemiaTest
//
//  Created by Apps Avantiam on 11/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import AlamofireImage

class ApiImageVC: UIViewController {
    
    var apiImage = ""
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageDetail: UIImageView!
    
    init(apiImage: String = "") {
        super.init(nibName: "ApiImageVC", bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        self.apiImage = apiImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: apiImage) {
            imageDetail.af.setImage(withURL: url)
        }

        imageDetail.layer.cornerRadius = 10
        imageDetail.clipsToBounds = true
        imageDetail.layer.borderColor = UIColor.black.cgColor
        imageDetail.layer.borderWidth = 3

            

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonCloseAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
    
