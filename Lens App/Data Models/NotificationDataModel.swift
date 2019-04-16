//
//  NotificationDataModel.swift
//  Lense App
//
//  Created by Apple on 14/09/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

struct notificationDetails {
    
    var id: Int!
    var message: String!
    
    init(details: JSONDictionary) {
        self.id = details[APIKeys.kId] as? Int
        self.message = details[APIKeys.kMessage] as? String ?? ""
    }
}

extension NotificationVM {

    func parseNotifications(page: Int, responseDict: JSONDictionary) {
        print(responseDict)
        if page == 1 {
             self.notifications.removeAll()
        }
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let notifications = data[APIKeys.kData] as? JSONArray {
                for notification in notifications {
                   let notificationDetail =  notificationDetails(details: notification)
                    self.notifications.append(notificationDetail)
                }
            }
        }
    }
        
}
