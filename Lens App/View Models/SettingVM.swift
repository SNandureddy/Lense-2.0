//
//  SettingVM.swift
//  Lense App
//
//  Created by Apple on 13/09/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation


class SettingVM {
    
    private init(){}
    public static let shared = SettingVM()
    
    
    func updateUserProfile(dict: JSONDictionary,imageDict: [String:Data], response: @escaping responseCallBack) {
        APIManager.updateUserProfile(dict: dict, imageDict: imageDict, successCallback: { (responseDict) in
            
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseUserDetails(responseDict: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func fetchUserProfile(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.fetchUserProfile(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseUserDetails(responseDict: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func changePassword(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.changePassword(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func editBankAccount(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.editBankAccount(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
