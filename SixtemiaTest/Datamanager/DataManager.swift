//
//  DataManager.swift
//  SixtemiaTest
//
//  Created by Sergio Rovira on 29/09/2023.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private var manager         : Session
    
    public static var shared: DataManager = {
        return DataManager.init()
    }()
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    public init() {
        manager = {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = nil
            return Alamofire.Session(configuration: configuration, interceptor: APIRequestInterceptor())
        }()
    }
    
    func getDataAPI(needAuth: Bool = false, strAction: String, strActionWithParameters: String = "", method: HTTPMethod = .post, isMultipart: Bool? = false, parameters: [String: Any]? = nil, completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        
        var strUrl = "\(URL_BASE)\(strAction)"
        
        // SERVEI DE NOTIFICACIONS AIRLAUNCH?
        if strAction == WS_11_NOTIFICATION_COUNT ||
            strAction == WS_12_NOTIFICATION_LIST ||
            strAction == WS_13_NOTIFICATION_CATEGORY_LIST {
            strUrl = "\(URL_BASE_PUSH)\(strAction)"
        }
        
        // TENIM PARÀMETRES EXTRA A LA URL?
        if strActionWithParameters != "" {
            strUrl = "\(URL_BASE)\(strActionWithParameters)"
        }
        
        // REQUEST HEADERS
        var headers:HTTPHeaders? = HTTPHeaders([
            HTTPHeader.accept("application/json"),
            HTTPHeader.acceptLanguage("ca"),
            .init(name: "X-Platform", value: "ios")
        ])
        
        // REQUEST AUTENTIFICADA?
        if needAuth {
            guard let token = UserDefaults.standard.value(forKey: RESP_TOKEN) as? String, token != "" else {
                BaseC().logout()
                return
            }
            headers?.add(HTTPHeader.authorization(String(format: "Bearer %@", token)))
        }
        
        // REQUEST MULTIPART?
        if !isMultipart! {
            manager.request(strUrl, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData(completionHandler: { response in
                self.manageResponse(response, strAction: strAction, method: method, parameters: parameters, completionHandler: completionHandler)
            })
        } else {
            multipartRequest(strAction: strAction, method: method, parameters: parameters, strUrl: strUrl, completionHandler: completionHandler)
        }
    }
    
    private func multipartRequest(strAction: String, method: HTTPMethod, parameters: [String: Any]? = nil, strUrl: String, completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        let strUrl = "\(URL_BASE)\(strAction)"
        
        manager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters! {
                if value is UIImage {
                    let timestamp = Date().ticks
                    multipartFormData.append((value as! UIImage).jpegData(compressionQuality: 0.75)!, withName: key, fileName: "\(timestamp).jpeg",mimeType: "image/jpeg")
                } else if value is Data {
                    let timestamp = Date().ticks
                    multipartFormData.append(value as! Data, withName: key, fileName: "\(timestamp).zip", mimeType: "applications/zip")
                } else {
                    if value is Dictionary<String, Any> {
                        for (keyObj, obj) in value as! Dictionary<String, Any> {
                            if obj is Data {
                                let timestamp = Date().ticks
                                multipartFormData.append(obj as! Data, withName: keyObj, fileName: "\(timestamp).zip", mimeType: "applications/zip")
                            } else if obj is Array<Any> {
                                var num = 0
                                for item in obj as! [Any] {
                                    multipartFormData.append("\(item)".data(using: .utf8)!, withName: "\(keyObj)[\(num)")
                                    num += 1
                                }
                            } else {
                                multipartFormData.append("\(obj)".data(using: .utf8)!, withName: keyObj)
                            }
                        }
                    } else {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
            }
        }, to: strUrl).responseData { (response) in
            self.manageResponse(response, strAction: strAction, method: method ,parameters: parameters, completionHandler: completionHandler)
        }
    }
    
    private func manageResponse(_ response: AFDataResponse<Data>, strAction: String, method:HTTPMethod, parameters: [String: Any]? = nil, completionHandler: @escaping (_ result: AFResult<Data>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        var nsError: NSError
        
        if let codeError = response.response?.statusCode {
            if codeError == 401 {
                manager.cancelAllRequests()
                nsError = NSError.init(domain: "error.sessionExpired".localized(), code: ERROR_CODE_SESSION_EXPIRED, userInfo: nil)
                completionHandler(response.result, nsError, nil, nil)
                return
            }
        }
        
        switch response.result {
            // MARK: S'ha d'agafar l'id de la section i pasarho com a parametre
        case .success:
            /*if let dictJSON = succ as? Dictionary<String, AnyObject> {
             if let token = dictJSON[RESP_TOKEN] {
             if token is String, token as! String != "" {
             UserDefaults.standard.set(token, forKey: RESP_TOKEN)
             } else {
             // Ha retornat un token buit -> Sessió caducada
             nsError = NSError.init(domain: "error.sessionExpired".localized(), code: ERROR_CODE_SESSION_EXPIRED, userInfo: nil)
             completionHandler(response.result, nsError, nil, nil)
             return
             }
             }
             }*/
            
            let dictResult = self.process(data: response.data, paramsSent: parameters, strAction: strAction, method: method)
            
            if let strResult = dictResult[RESP_WS_RESULT] as? String {
                let strMsg = dictResult[RESP_WS_STR_MSG] as? String
                let arrayResult = dictResult[RESP_ARRAY_RESULT] as? [Any]
                if strResult == STR_OK {
                    completionHandler(response.result, nil, strMsg, arrayResult)
                } else {
                    nsError = NSError.init(domain: strMsg == nil || strMsg == "" ? "defaultErrorMsg".localized() : strMsg!, code: ERROR_CODE_GENERIC, userInfo: nil)
                    completionHandler(response.result, nsError, strMsg, arrayResult)
                }
            }
        case .failure(let error):
            /*let errorCode = response.response?.statusCode ?? 400
             let code = URLError.Code(rawValue: errorCode)
             
             switch code {
             case .notConnectedToInternet, .timedOut:
             nsError = NSError.init(domain: error.localizedDescription, code: ERROR_CODE_GENERIC, userInfo: nil)
             completionHandler(response.result, nsError, "ERROR_LOCAL_CONTENT".localized(), nil)
             default:
             let dictResult = self.processWS_BaseError(data: response.data, paramsSent: parameters)
             nsError = NSError.init(domain: error.localizedDescription, code: ERROR_CODE_GENERIC, userInfo: nil)
             completionHandler(response.result, nsError, dictResult[RESP_WS_STR_MSG] as? String, nil)
             }*/
            
            let afError = error as AFError
            
            let errorRange = 400...499
            if let errorCode = afError.responseCode, errorRange.contains(errorCode) {
                
                let decoder = JSONDecoder()
                let wsResponse = try? decoder.decode(WSBaseResponse.self, from: response.data ?? Data())
                if let message = wsResponse?.msg {
                    nsError = NSError.init(domain: message, code: errorCode, userInfo: nil)
                    completionHandler(response.result, nsError, message, nil)
                } else {
#if DEBUG
                    let dictResult = self.processWS_BaseError(data: response.data, paramsSent: parameters)
                    nsError = NSError.init(domain: error.localizedDescription, code: ERROR_CODE_GENERIC, userInfo: nil)
                    completionHandler(response.result, nsError, dictResult[RESP_WS_STR_MSG] as? String, nil)
#else
                    completionHandler(response.result, nil, "defaultErrorMsg".localized(), nil)
#endif
                }
            } else {
#if DEBUG
                let dictResult = self.processWS_BaseError(data: response.data, paramsSent: parameters)
                nsError = NSError.init(domain: error.localizedDescription, code: ERROR_CODE_GENERIC, userInfo: nil)
                completionHandler(response.result, nsError, dictResult[RESP_WS_STR_MSG] as? String, nil)
#else
                completionHandler(response.result, nil, "defaultErrorMsg".localized(), nil)
#endif
            }
        }
    }
    
    func cancelTask(strAction: String) {
        var strUrl = "\(URL_BASE)\(strAction)"
        
        if strAction == WS_12_NOTIFICATION_LIST ||
            strAction == WS_13_NOTIFICATION_CATEGORY_LIST ||
            strAction == WS_13_NOTIFICATION_CATEGORY_LIST {
            strUrl = "\(URL_BASE_PUSH)\(strAction)"
        }
        
        manager.session.getAllTasks { (tasks) in
            tasks.forEach({task in
                if task.currentRequest?.url?.absoluteString == strUrl {
                    task.cancel()
                }
            })
        }
    }
    
    func cancelAllTasks() {
        manager.session.getAllTasks { (tasks) in
            tasks.forEach({task in
                task.cancel()
            })
        }
    }
}
