
//
//  APIServices+Setting.swift
//  Lense App
//
//  Created by Apple on 13/09/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

enum SettingApiSevices: APIService {
    
    
    case updateUserProfile(dict: JSONDictionary)
    case changePassword(dict: JSONDictionary)
    case editBankAccount(dict: JSONDictionary)
    case fetchUserProfile(dict: JSONDictionary)
    var path : String{
        var path = ""
        switch self {
        case .updateUserProfile:
            path = BASE_URL.appending("/api/update-profile")
            
        case .changePassword:
            path = BASE_URL.appending("/api/change-password")
            
        case .editBankAccount :
            path = BASE_URL.appendingFormat("/api/update-paypal-email")
            
        case .fetchUserProfile :
            path = BASE_URL.appendingFormat("/api/get-profile")
            
        }
        return path
    }
    
    var resource: Resource {
        var resource: Resource!
        switch self {
        case let .updateUserProfile(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
      
        case let .changePassword(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
            
        case let .editBankAccount(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
            
        case let .fetchUserProfile(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        }
        return resource
    }
    
}
extension APIManager {
    
    class func updateUserProfile(dict: JSONDictionary, imageDict: [String: Data]?, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        SettingApiSevices.updateUserProfile(dict: dict).request(imageDict: imageDict, success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    class func fetchUserProfile(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        SettingApiSevices.fetchUserProfile(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    class func changePassword(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        SettingApiSevices.changePassword(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
   
    
    class func editBankAccount(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        SettingApiSevices.editBankAccount(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
}


