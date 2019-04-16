//
//  APIServices+Notifications.swift
//  Lense App
//
//  Created by Apple on 14/09/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

enum NotificationApiServices: APIService {
    
    case getNotification(page:Int)
    case updateDistance(dict: JSONDictionary)
    case sendFeedBack(dict: JSONDictionary)
    
    var path : String{
        var path = ""
        switch self {
            
        case .getNotification :
            path = BASE_URL.appending("/api/get-notifications-list")
            
        case .updateDistance :
            path = BASE_URL.appending("/api/update-distance")
            
        case .sendFeedBack:
             path = BASE_URL.appending("/api/submit-feedback")
        }
        return path
    }
    
    
    var resource: Resource {
        var resource: Resource!
        switch self {
            
        case let .getNotification(page):
            var dict = JSONDictionary()
            dict[APIKeys.KPage] = page
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
            
        case let .updateDistance(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
            
        case let .sendFeedBack(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])

        }
        return resource
    }
    
}

extension APIManager {
    class func getNotifications(page: Int ,successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        NotificationApiServices.getNotification(page: page).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func updateDistance(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        NotificationApiServices.updateDistance(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func sendFeedBack(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        NotificationApiServices.sendFeedBack(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}
