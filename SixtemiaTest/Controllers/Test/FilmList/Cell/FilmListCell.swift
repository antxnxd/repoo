//
//  FilmListCell.swift
//  SixtemiaTest
//
//  Created by Apps Avantiam on 10/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import AlamofireImage

class FilmListCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgTest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(title: String, image: String) {
        if let url = URL(string: image) {
            
            
            imgTest.af.setImage(withURL: url)
            
        }
        label.text = title
    }
    
}
