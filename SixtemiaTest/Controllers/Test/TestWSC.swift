//
//  TestWSC.swift
//  SixtemiaTest
//
//  Created by santi on 19/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import Alamofire

class TestWSC: BaseC {
    
    
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    var arrayWSs = [String]()
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarColor = PRIMARY_COLOR
        titleBarColor = SECONDARY_COLOR
        UIApplication.shared.setStatusBar(style: .default)
        
        self.title = "TEST WS"
        
        arrayWSs = [WS_11_NOTIFICATION_COUNT, WS_12_NOTIFICATION_LIST, WS_13_NOTIFICATION_CATEGORY_LIST]
        
        //-------------------------------- DISSENY ------------------------------------//
        
        //Assignem l'alçada de les cel.les automaticament amb un valor estimat (Posarem el minim)
        tableView.estimatedRowHeight = CGFloat(44)
        tableView.rowHeight = UITableView.automaticDimension
        
        //to hide separators between empty cells
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        //-----------------------------------------------------------------------------//
        
        // Do any additional setup after loading the view.
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    
    
    
    
    
    
    //-----------------------
    // MARK: - DATAMANAGER
    //-----------------------
    
    override func processWSResponse(strAction: String, result: AFResult<Data>, error: NSError?, strMsg: String?, array: [Any]?) {
        
        super.processWSResponse(strAction: strAction, result: result, error: error, strMsg: strMsg, array: array)
        
        switch result {
        case .success:
            switch strAction {
                
            case WS_11_NOTIFICATION_COUNT, WS_12_NOTIFICATION_LIST, WS_13_NOTIFICATION_CATEGORY_LIST:
                if error != nil {
                    print("\(String(describing: self)) >>> \(strAction) ===== processWSResponse\nWS = OK | Result = KO")
                    
                    let alertC = UIAlertController(title: "WS KO", message: "\(strAction)\n\(error!.domain)", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertC.addAction(actionOK)
                    present(alertC, animated: true, completion: nil)
                } else {
                    print("\(String(describing: self)) >>> \(strAction) ===== processWSResponse\nWS = OK | Result = OK")
                    
                    let alertC = UIAlertController(title: "WS OK", message: "\(strAction)\n\(strMsg ?? "")", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertC.addAction(actionOK)
                    present(alertC, animated: true, completion: nil)
                }
                
            default:
                break
            }
        case .failure:
            
            switch strAction {
                
            case WS_11_NOTIFICATION_COUNT, WS_12_NOTIFICATION_LIST, WS_13_NOTIFICATION_CATEGORY_LIST:
                print("\(String(describing: self)) >>> \(strAction) ===== processWSResponse\nWS = KO | Result = ?")
                
                let alertC = UIAlertController(title: "WS KO", message: "\(strAction)\n\(error!.domain)", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertC.addAction(actionOK)
                present(alertC, animated: true, completion: nil)
                
            default:
                break
            }
            
            
        }
    }
    
}

extension TestWSC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWSs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let ws = arrayWSs[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = ws
        return cell!
        
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ws = arrayWSs[indexPath.row]
        
        switch ws {
        case WS_11_NOTIFICATION_COUNT:
            
			API.shared.ws11_Notification_Count(strDate: "", sdid: "", strFilter: "") { (result, error, strMsg, array) in
				self.processWSResponse(strAction: WS_11_NOTIFICATION_COUNT, result: result, error: error, strMsg: strMsg, array: array)
			}
            
            break
            
            
        case WS_12_NOTIFICATION_LIST:
			
			API.shared.ws12_Notification_List(strDate: "", sdid: "", strFilter: "") { (result, error, strMsg, array) in
				self.processWSResponse(strAction: WS_12_NOTIFICATION_LIST, result: result, error: error, strMsg: strMsg, array: array)
			}
            
            break
			
		case WS_13_NOTIFICATION_CATEGORY_LIST:
		
			API.shared.ws13_Notification_Category_List { (result, error, strMsg, array) in
				self.processWSResponse(strAction: WS_13_NOTIFICATION_CATEGORY_LIST, result: result, error: error, strMsg: strMsg, array: array)
			}
            
		break
            
        default:
            break
        }
    }
    
    
}


