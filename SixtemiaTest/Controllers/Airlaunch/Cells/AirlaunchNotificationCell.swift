//
//  AirlaunchNotificationCell.swift
//  Airlaunch
//
//  Created by santi on 07/05/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import AlamofireImage

class AirlaunchNotificationCell: UITableViewCell {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var viewContent: CustomView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewDisclosure: UIView!
    @IBOutlet weak var viewShadow: CustomView!
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    private var controller: UIViewController!
    private var airlaunchNotification: AirlaunchNotification!
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    required init?(coder aDecoder: NSCoder) {
        self.controller = UIViewController()
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if airlaunchNotification.strCode != "" {
            viewContent.animateViewCellTap(isHighlighted: highlighted)
            viewShadow.animateViewCellTap(isHighlighted: highlighted)
        }
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func configCellWithNotification(_ airlaunchNotification: AirlaunchNotification, cont: UIViewController) {
        self.controller = cont
        self.airlaunchNotification = airlaunchNotification
        
        if let strTitle = airlaunchNotification.strTitle, strTitle != ""{
            viewTitle.isHidden = false
            lblTitle.text = strTitle
        } else {
            viewTitle.isHidden = true
        }
        
        if let strDesc = airlaunchNotification.strDesc, strDesc != ""{
            viewDesc.isHidden = false
            lblDesc.text = strDesc
        } else {
            viewDesc.isHidden = true
        }
        
        if let strImg = airlaunchNotification.strUrlImg, let url = URL(string:strImg) {
            viewImg.isHidden = false
            viewSpace.isHidden = true
            img.af.setImage(withURL: url, placeholderImage: UIImage(named: "logo_login"),
                            imageTransition: .crossDissolve(FADE_IN)
            )
            img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTapped)))
        } else {
            viewImg.isHidden = true
            viewSpace.isHidden = false
        }
        
        if let strDate = airlaunchNotification.strDate, strDate != "" {
            lblDate.text = strDate.formatStrDate(fromFormat: "yyyyMMddHHmmSS", toFormat: "EEEE d LLLL yyyy, H:mm").capitalizingFirstLetter()
            viewDate.isHidden = false
        } else {
            viewDate.isHidden = true
        }
        
        viewDisclosure.isHidden = airlaunchNotification.strCode == ""
    }
    
    @objc private func imageTapped() {
        let vc = ImageGalleryC(arrayImg: [img.image ?? UIImage()], currentIndex: 0)
        let navC = UINavigationController(rootViewController: vc)
        navC.modalPresentationStyle = .fullScreen
        controller.present(navC, animated: true)
    }
    
}
