//
//  AirlaunchNotificationCategoryListC.swift
//  mobappiios
//
//  Created by santi on 29/05/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import Alamofire
import OneSignal

class AirlaunchNotificationCategoryListC: BaseC {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAnimation: UIView!
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    var arrayCategory = [AirlaunchCategory]()
    var firstLoad = true
        
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        //-------------------------------- DISSENY ------------------------------------//
        navigationItem.title = "airlaunch.categoryTitle".localized()
        configBackButtonLight(true)
        
        //to hide separators between empty cells
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        lblError.text = "\("airlaunch.categoryListEmpty".localized())\n\n\(NSLocalizedString("RETRY", comment: ""))"
        lblTitle.text = "airlaunch.categoryListEmpty".localized()
        
        //-----------------------------------------------------------------------------//
                
        lblError.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.retry)))
        //setupPullToRefresh()
//        viewAnimation.addLottie(strName: "loading_rodones_vermelles")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arrayCategory = DBAirlaunchCategory.getAllAsObjs()
        
        if arrayCategory.count > 0 {
            viewContent.alpha = 1.0
            viewLoading.alpha = 0.0
            viewError.alpha = 0.0
            wsNotificationCategoryList()
        } else if firstLoad {
            viewContent.alpha = 0.0
            viewError.alpha = 0.0
            viewLoading.alpha = 1.0
            wsNotificationCategoryList()
        } else {
            viewContent.alpha = 0.0
            viewError.alpha = 1.0
            viewLoading.alpha = 0.0
        }
        
        firstLoad = true
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func activeCategory(_ category: AirlaunchCategory, active: Bool){
        if let idCat = category.idCategory{
            DBAirlaunchCategory.setActiveWithId(idCat, active: active)
            let strTag = "Category_\(idCat)"
            OneSignal.sendTags([strTag : active == true ? "1" : "0"]);
        }
    }
    
    @objc private func retry() {
        showView(type: .viewLoading)
        wsNotificationCategoryList()
    }
    
    private func wsNotificationCategoryList() {
        API.shared.ws13_Notification_Category_List({ (result, error, strMsg, array) in
            self.processWSResponse(strAction: WS_13_NOTIFICATION_CATEGORY_LIST, result: result, error: error, strMsg: strMsg, array: array)
        })
    }
    
    /*private func setupPullToRefresh() {
        let customRefreshView = CustomRefreshView()
        customRefreshView.refreshColor = PRIMARY_COLOR
        customRefreshView.translatesAutoresizingMaskIntoConstraints = false
        customRefreshView.autoresizingMask = [.flexibleWidth]
        customRefreshView.frame.size.height = 40.0
        let awesomeRefresher = PullToRefresh(refreshView: customRefreshView, animator: CustomViewAnimator(refreshView: customRefreshView), height: 40.0, position: .top)
        tableView.sixAddPullToRefresh(awesomeRefresher) {
            self.wsNotificationCategoryList()
        }
    }*/
    
    private func showView(type: viewType, mssgError: String? = "") {
        switch type {
        case .viewContent:
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 1.0
                self.viewLoading.alpha = 0.0
                self.viewError.alpha = 0.0
            })
        case .viewLoading:
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 0.0
                self.viewLoading.alpha = 1.0
                self.viewError.alpha = 0.0
            })
        case .viewError, .viewEmpty:
            lblError.text = "\(mssgError ?? "defaultErrorMsg".localized())\n\("RETRY".localized())"
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 0.0
                self.viewLoading.alpha = 0.0
                self.viewError.alpha = 1.0
            })
        default:
            break
        }
    }
    
    private func setupCategories() {
        arrayCategory = DBAirlaunchCategory.getAllAsObjs()
        
        for cat in arrayCategory {
            if let idCat = cat.idCategory{
                OneSignal.sendTags(["Category_\(idCat)" : (cat.isActive ?? false) ? "1" : "0"]);
            }
        }
        
        if arrayCategory.count > 0 {
            showView(type: .viewContent)
        } else {
            showView(type: .viewError, mssgError: "airlaunch.categoryListEmpty".localized())
        }
        
        tableView.reloadData()
    }
    
    //-----------------------
    // MARK: - DATAMANAGER
    //-----------------------
    
    override func processWSResponse(strAction: String, result: AFResult<Data>, error: NSError?, strMsg: String?, array: [Any]?) {
        super.processWSResponse(strAction: strAction, result: result, error: error, strMsg: strMsg, array: array)
        //tableView.endRefreshing(at: .top)
        
        switch result {
        case .success:
            if error != nil {
                print("\(String(describing: self)) >>> processWSResponse\nWS = OK | Result = KO")
                showView(type: .viewError, mssgError: error?.domain)
            } else {
                print("\(String(describing: self)) >>> processWSResponse\nWS = OK | Result = OK")
                setupCategories()
            }
        case .failure:
            print("\(String(describing: self)) >>> processWSResponse\nWS = KO | Result = ?")
            showView(type: .viewError, mssgError: error?.domain)
        }
    }
}

extension AirlaunchNotificationCategoryListC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AirlaunchNotificationCategoryCell"
        let object = arrayCategory[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AirlaunchNotificationCategoryCell
        
        if cell == nil {
            tableView.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AirlaunchNotificationCategoryCell
        }
        
        cell?.configCellWithCategory(object, cont: self)
        
        cell?.setNeedsUpdateConstraints()
        cell?.updateConstraintsIfNeeded()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

