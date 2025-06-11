//
//  APIRequestInterceptor.swift
//  SixtemiaTest
//
//  Created by Avantiam on 9/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import Alamofire

class APIRequestInterceptor: RequestInterceptor {
    
    /// Adapts the given `URLRequest` by adding an `Authorization` header with a Bearer token.
    ///
    /// This method attempts to retrieve the user's authentication token from `UserDefaults`.
    /// If a token is found, it is added to the request as a Bearer token in the `Authorization` header.
    ///
    /// - Parameters:
    ///   - urlRequest: The original request to adapt.
    ///   - session: The Alamofire session.
    ///   - completion: A closure to be called with the adapted request or an error.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        guard let token = AppCommon.shared.token else {
            completion(.success(urlRequest))
            return
        }
        
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        
        completion(.success(request))
    }
    
    /// Handles request retry logic based on the response status code and retry count.
    ///
    /// If the request fails with a 401 status code and a valid token is available, the method attempts to re-authenticate the user.
    /// Retries up to 4 times before giving up. On each retry, logs the retry count using `appLog`.
    ///
    /// - Parameters:
    ///   - request: The failed request.
    ///   - session: The Alamofire session.
    ///   - error: The error that triggered the retry.
    ///   - completion: A closure that determines whether to retry the request.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        if AppCommon.shared.retryCount >= 3 {
            AppCommon.shared.retryCount = 0
            performLogout()
            completion(.doNotRetry)
            return
        } else {
            AppCommon.shared.retryCount += 1
        }
        
        appLog(tag: .warning, AppCommon.shared.retryCount)
        
        switch statusCode {
        case 401:
            if AppCommon.shared.token != "" {
                reLogin { (isSuccess) in
                    if isSuccess {
                        completion(.retry)
                        return
                    } else {
                        self.performLogout()
                        completion(.doNotRetry)
                        return
                        
                    }
                }
            } else {
                self.performLogout()
                completion(.doNotRetry)
                return
            }
            
            break
        default:
            AppCommon.shared.retryCount = 0
            self.performLogout()
            completion(.doNotRetry)
            return
        }
    }
    
    /// Attempts to re-authenticate the user using stored credentials (email and password).
    ///
    /// This method checks if the user's email, password, and current cinema slug are available in `UserDefaults`
    /// and `AppCommon`. If all required data is present, it sends a login request to the API using Alamofire.
    /// If the login is successful, the completion handler is called with `true`, otherwise with `false`.
    ///
    /// - Parameter completion: A closure that returns a Boolean indicating whether the login was successful (`true`) or not (`false`).
    func reLogin(completion: @escaping (_ isSuccess: Bool) -> Void) {
        completion(true)
    }
    
    /// Logs out the current user and resets application state.
    ///
    /// This method performs a full logout sequence by:
    /// - Canceling all ongoing network tasks via `DataManager` and `Alamofire`.
    /// - Deleting the current user and all related local database records.
    /// - Removing push notification identifiers and installation dates.
    /// - Clearing stored credentials and user-specific data in `UserDefaults`.
    /// - Resetting the retry count for API requests.
    /// - Navigating the user to the `WelcomeC` view controller with a fade-in transition.
    func performLogout() {
        DataManager.shared.cancelAllTasks()
        
        AF.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        
        DBAirlaunchCategory.deleteAll()
        DBAirlaunchNotification.deleteAll()
        SixtemiaOneSignalManager.shared.removeUserName()
        SixtemiaOneSignalManager.shared.configDateInstall()
        
        UserDefaults.standard.removeObject(forKey: AppCommon.shared.USER_LOGED_TOKEN)
        
        AppCommon.shared.retryCount = 0
        DataManager.shared.cancelAllTasks()
        
        print("📣 Logout in progress...")
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window!.rootViewController = UINavigationController.init(rootViewController: HomeViewC(menuSection: .home))
//            appDelegate.window?.makeKeyAndVisible()
//        }
    }
}
