//
//  AirlaunchNotificationListC.swift
//  Airlaunch
//
//  Created by santi on 07/05/2019.
//  Copyright © 2019 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
//import PullToRefresh
import Alamofire
import SafariServices
//import OneSignal

class AirlaunchNotificationListC: BaseC {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblEmptyTitle: UILabel!
    @IBOutlet weak var lblEmptyDesc: UILabel!
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    private var arrayNotifications = [AirlaunchNotification]()
    private var firstLoad = true
    private var navigationTab: UITabBarController? = nil
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-------------------------------- DISSENY ------------------------------------//
        
        navigationItem.title = "airlaunch.title".localized()
        configBackButtonLight(true)
        configSettingBtn()
        
        lblEmptyTitle.text = "airlaunch.notificationEmptyTitle".localized()
        
//        viewAnimation.addLottie(strName: "loading_rodones_vermelles")
        
        //-----------------------------------------------------------------------------//
        
        //setupPullToRefresh()
        lblEmptyDesc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.retry)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.setStatusBar(style: .default)
        navigationController?.isNavigationBarHidden = false
        
        arrayNotifications = DBAirlaunchNotification.getAllAsObjs()
        wsNotificationCategoryList()
        
        if arrayNotifications.count > 0 {
            viewContent.alpha = 1.0
            viewLoading.alpha = 0.0
            viewError.alpha = 0.0
            wsNotificationList()
        } else if firstLoad {
            viewContent.alpha = 0.0
            viewLoading.alpha = 1.0
            viewError.alpha = 0.0
            wsNotificationList()
        } else {
            viewContent.alpha = 0.0
            viewLoading.alpha = 0.0
            viewError.alpha = 1.0
        }
        
        firstLoad = true
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    @objc private func retry() {
        showView(type: .viewLoading)
        wsNotificationList()
    }
    
    @objc private func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @objc private func openCategories() {
        navigationController?.pushViewController(AirlaunchNotificationCategoryListC(), animated: true)
    }
    
    private func imageTapped(image:UIImage) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    /*private func setupPullToRefresh() {
        let customRefreshView = CustomRefreshView()
        customRefreshView.refreshColor = PRIMARY_COLOR
        customRefreshView.translatesAutoresizingMaskIntoConstraints = false
        customRefreshView.autoresizingMask = [.flexibleWidth]
        customRefreshView.frame.size.height = 40.0
        let awesomeRefresher = PullToRefresh.init(refreshView: customRefreshView, animator: CustomViewAnimator.init(refreshView: customRefreshView), height: 40.0, position: .top)
        tableView.sixAddPullToRefresh(awesomeRefresher) {
            self.wsNotificationList()
        }
    }*/
    
    private func wsNotificationList() {
        API.shared.ws12_Notification_List(strDate: SixtemiaOneSignalManager.shared.getLastNotiDate(),
                                          sdid: SixtemiaOneSignalManager.shared.getUserId(), completionHandler: { (result, error, strMsg, array) in
            self.processWSResponse(strAction: WS_12_NOTIFICATION_LIST, result: result, error: error, strMsg: strMsg, array: array)
        })
    }
    
    private func wsNotificationCategoryList() {
        API.shared.ws13_Notification_Category_List({ (result, error, strMsg, array) in
            self.processWSResponse(strAction: WS_13_NOTIFICATION_CATEGORY_LIST, result: result, error: error, strMsg: strMsg, array: array)
        })
    }
    
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
            lblEmptyDesc.text = "\(mssgError ?? "defaultErrorMsg".localized())\n\("RETRY".localized())"
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 0.0
                self.viewLoading.alpha = 0.0
                self.viewError.alpha = 1.0
            })
        default:
            break
        }
    }
    
    private func setupNotifications() {
        arrayNotifications = DBAirlaunchNotification.getAllAsObjs()
        
        if arrayNotifications.count > 0 {
            showView(type: .viewContent)
        } else {
            showView(type: .viewEmpty, mssgError: "airlaunch.notificationEmptyDesc".localized())
        }
        tableView.reloadData()
    }
    
    private func configSettingBtn(){
        let arrayCats = DBAirlaunchCategory.getAllAsObjs()
        if arrayCats.count != 0 {
            let img = UIImage(named: "setup_light")?.withRenderingMode(.alwaysTemplate)
            let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.openCategories))
            btn.tintColor = PRIMARY_COLOR
            navigationItem.rightBarButtonItem = btn
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    //-----------------------
    // MARK: - DATAMANAGER
    //-----------------------
    
    override func processWSResponse(strAction: String, result: AFResult<Data>, error: NSError?, strMsg: String?, array: [Any]?) {
        super.processWSResponse(strAction: strAction, result: result, error: error, strMsg: strMsg, array: array)
        
        switch result {
        case .success:
            if error != nil {
                print("\(String(describing: self)) >>> processWSResponse\nWS = OK | Result = KO")
                showView(type: .viewError, mssgError: error?.domain)
            } else {
                print("\(String(describing: self)) >>> processWSResponse\nWS = OK | Result = OK")
                switch strAction {
                case WS_12_NOTIFICATION_LIST:
                    //tableView.endRefreshing(at: .top)
                    setupNotifications()
                case WS_13_NOTIFICATION_CATEGORY_LIST:
                    configSettingBtn()
                default:
                    break
                }
            }
        case .failure:
            print("\(String(describing: self)) >>> processWSResponse\nWS = KO | Result = ?")
            switch strAction {
            case WS_12_NOTIFICATION_LIST:
                showView(type: .viewError, mssgError: error?.domain)
            default:
                break
            }
        }
    }
}


extension AirlaunchNotificationListC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AirlaunchNotificationCell"
        let object = arrayNotifications[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AirlaunchNotificationCell
        
        if cell == nil {
            tableView.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AirlaunchNotificationCell
        }
        
        cell?.configCellWithNotification(object, cont: self)
        
        cell?.setNeedsUpdateConstraints()
        cell?.updateConstraintsIfNeeded()
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let airlaunchNotification = arrayNotifications[indexPath.row]
        
        if let strCode = airlaunchNotification.strCode, strCode != "" {
            switch strCode {
            case "webview":
                if let url = URL(string: airlaunchNotification.strValue ?? "") {
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }
    
}
