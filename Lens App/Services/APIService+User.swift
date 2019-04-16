//
//  APIService+User.swift
//  Lens App
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

enum UserAPIServices: APIService {
    
    case validateEmail(dict: JSONDictionary)
    case signup(dict: JSONDictionary)
    case login(dict: JSONDictionary)
    case forgotPassword(email: String)
    case setAvailability(availability: Int)
    case logout(userId: Int)
    
    var path: String {
        var path = ""
        switch self {
        case .signup:
            path = BASE_URL.appending("/api/register")
            
        case .validateEmail:
            path = BASE_URL.appending("/api/check-valid-email-or-phoneNumber")
            
        case .login:
            path = BASE_URL.appending("/api/login")
            
        case .forgotPassword:
            path = BASE_URL.appending("/api/forgot-password")
            
        case .setAvailability:
            path = BASE_URL.appending("/api/check-availability")
            
        case .logout:
            path = BASE_URL.appending("/api/logout")
        }
        return path
    }
    
    var resource: Resource {
        var resource: Resource!
        switch self {
        case let .signup(dict):
            resource = Resource(method: .post, parameters: dict, headers: nil)
            
        case let .validateEmail(dict):
            resource = Resource(method: .post, parameters: dict, headers: nil)
            
        case let .login(dict):
            resource = Resource(method: .post, parameters: dict, headers: nil)
            
        case let .forgotPassword(email):
            resource = Resource(method: .post, parameters: [APIKeys.kEmail:email], headers: nil)
            
        case let .setAvailability(availability):
            resource = Resource(method: .post, parameters: [APIKeys.kAvailability:availability], headers: [APIKeys.kAuthorization: DataManager.accessToken!])

        case let .logout(userId):
            resource = Resource(method: .post, parameters: [APIKeys.kUserId: userId], headers: nil)
        }
        return resource
    }
    
}

// MARK: Method for webservice
extension APIManager {
    
    class func signup(dict: JSONDictionary, imageDict: [String: Data]?, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.signup(dict: dict).request(imageDict: imageDict, success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func validateEmail(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.validateEmail(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func login(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.login(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func forgotPassword(email: String, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.forgotPassword(email: email).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func setAvailability(availability: Int, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.setAvailability(availability: availability).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func logout(userId: Int, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.logout(userId: userId).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}
