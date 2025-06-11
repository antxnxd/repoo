/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
    case opticID
}

class BiometricIDAuth {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    var loginReason = "Logging in with Touch ID"
    
    //-----------------------
    // MARK: CONSTANTS
    // MARK: ============
    //-----------------------
    
    let context = LAContext()
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            case .opticID:
                return .opticID
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    /// User authenticated successfully, take appropriate action
                    completion(nil)
                }
            } else {
                let message: String
                
                if #available(iOS 11.0, *) {
                    switch evaluateError {
                    case LAError.authenticationFailed?:
                        message = "biometric.defaultsEvaluateError".localized()
                    case LAError.userCancel?:
                        message = "biometric.defaultsUserCancel".localized()
                    case LAError.userFallback?:
                        message = "biometric.defaultsUserFallback".localized()
                    case LAError.biometryNotAvailable?:
                        message = "biometric.defaultsBiometryNotAvaible".localized()
                    case LAError.biometryNotEnrolled?:
                        message = "biometric.defaultsBiometryNotEnrolled".localized()
                    case LAError.biometryLockout?:
                        message = "biometric.defaultsBiometryLockout".localized()
                    default:
                        message = "biometric.defaultsError".localized()
                    }
                } else {
                    /// Fallback on earlier versions
                    switch evaluateError {
                    case LAError.authenticationFailed?:
                        message = "biometric.defaultsEvaluateError".localized()
                    case LAError.userCancel?:
                        message = "biometric.defaultsUserCancel".localized()
                    case LAError.userFallback?:
                        message = "biometric.defaultsUserFallback".localized()
                    default:
                        message = "biometric.defaultsError".localized()
                    }
                }
                
                completion(message)
            }
        }
    }
}
