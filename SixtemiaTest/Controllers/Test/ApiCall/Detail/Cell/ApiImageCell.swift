//
//  ApiImageCell.swift
//  SixtemiaTest
//
//  Created by Apps Avantiam on 11/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import AlamofireImage

class ApiImageCell: UICollectionViewCell {

    @IBOutlet weak var imgTest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
              self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.imgTest.backgroundColor = .blue
              
            }
            else
            {
              self.transform = CGAffineTransform.identity
                self.imgTest.backgroundColor = .systemGreen
            }
          }
    }
    
    func configCell(image: String) {
        if let url = URL(string: image) {
            
            
            imgTest.af.setImage(withURL: url)
            
        }
    }

}
