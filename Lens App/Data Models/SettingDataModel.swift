//
//  SettingDataModel.swift
//  Lense App
//
//  Created by Apple on 17/09/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

extension SettingVM {
    
    func parseUserDetails(responseDict: JSONDictionary) {
        print(responseDict)
         if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            BaseVC.userDetails = UserDetails(userDetails: data)
            DataManager.userDetails = BaseVC.userDetails.jsonDict
            DataManager.userId = data[APIKeys.kId] as? Int ?? 0
            DataManager.distance = BaseVC.userDetails.distance
            DataManager.distance = BaseVC.userDetails.distance
            DataManager.isCardAdded = (data[APIKeys.kCardCount] as? Int ?? 0) > 0 ? true: false
//            DataManager.accessToken =  "Bearer \(data[APIKeys.kAccessToken] as? String ?? "")"
        }
    }
}
