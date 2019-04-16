//
//  NotificationVM.swift
//  Lense App
//
//  Created by Apple on 14/09/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

class NotificationVM {
    
    private init(){}
    public static let shared = NotificationVM()
    
    var notifications = [notificationDetails]()
    
    func getNotifications(page: Int , response: @escaping responseCallBack) {
        APIManager.getNotifications(page: page, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseNotifications(page: page ,responseDict: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func updateDistance(dict: JSONDictionary, response: @escaping responseCallBack){
        APIManager.updateDistance(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func sendFeedBack(dict: JSONDictionary, response: @escaping responseCallBack){
        APIManager.sendFeedBack(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
}
