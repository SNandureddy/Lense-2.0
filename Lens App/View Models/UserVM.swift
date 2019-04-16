//
//  UserVM.swift
//  Lens App
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//


import Foundation

class UserVM {
    public static let shared = UserVM()
    private init() {}
    
    func validateEmail(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.validateEmail(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
   
    func signup(dict: JSONDictionary, imageDict: [String: Data]?, response: @escaping responseCallBack) {
        APIManager.signup(dict: dict, imageDict: imageDict, successCallback: { (responseDict) in
            self.parserUserData(responseDict: responseDict)
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func login(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.login(dict: dict, successCallback: { (responseDict) in
            self.parserUserData(responseDict: responseDict)
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func forgotPassword(email: String, response: @escaping responseCallBack) {
        APIManager.forgotPassword(email: email, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func setAvailability(availability: Int, response: @escaping responseCallBack) {
        APIManager.setAvailability(availability: availability, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
     }
    
    func logout(userId: Int, response: @escaping responseCallBack) {
        APIManager.logout(userId: userId,  successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
}
