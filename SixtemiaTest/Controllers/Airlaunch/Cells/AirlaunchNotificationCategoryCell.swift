//
//  AirlaunchNotificationCategoryCell.swift
//  mobappiios
//
//  Created by santi on 29/05/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

class AirlaunchNotificationCategoryCell: UITableViewCell {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchCat: UISwitch!
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    private var controller: UIViewController!
    private var airlaunchCategory: AirlaunchCategory!
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    required init?(coder aDecoder: NSCoder) {
        self.controller = UIViewController()
        self.airlaunchCategory = AirlaunchCategory()
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblTitle.textColor = UIColor.init(Hex: 0x333333)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    @IBAction func actionSwitch(_ sender: Any) {
        if let vc = controller as? AirlaunchNotificationCategoryListC {
            vc.activeCategory(self.airlaunchCategory, active: switchCat.isOn)
        }
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func configCellWithCategory(_ airlaunchCategory: AirlaunchCategory, cont: UIViewController) {
        self.controller = cont
        self.airlaunchCategory = airlaunchCategory
        
        lblTitle.text = airlaunchCategory.strTitle ?? ""
        switchCat.setOn(airlaunchCategory.isActive ?? false, animated: false)
    }
    
}
