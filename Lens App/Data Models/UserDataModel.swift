//
//  UserDataModel.swift
//  Lens App
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

struct UserDetails {
    var name: String!
    var id: Int!
    var image: String?
    var email: String!
    var phoneNumber: String?
    var description: String?
    var availability: Bool?
    var distance: Double?
    var accountName: String?
    var paypalAccount: String?
    var accountNumber: String?
    var bsbNnumber: String?
    var userType: String!
    var password: String?

    var jsonDict: JSONDictionary {
        var dict = JSONDictionary()
        dict[APIKeys.kFullName] = name!
        dict[APIKeys.kEmail] = email!
        dict[APIKeys.kImage] = image
        
        if password != nil {
            dict[APIKeys.kPassword] = password!
        }
        if phoneNumber != nil {
            dict[APIKeys.kPhoneNumber] = phoneNumber!
        }
        if userType == kPhotographer {
            dict[APIKeys.kDescription] = description!
            dict[APIKeys.kAvailability] = availability == false ? 2: 1
            dict[APIKeys.kDistance] = distance!
            dict[APIKeys.kAccountName] = accountName!
            dict[APIKeys.kPaypalEmail] = paypalAccount!
            dict[APIKeys.kAccountNumber] = accountNumber!
            dict[APIKeys.kBsbNumber] = bsbNnumber!
        }
    
        switch userType {
        case kUser:
            dict[APIKeys.kUserType] = 2
        case kPhotographer:
             dict[APIKeys.kUserType] = 3
        default:
            dict[APIKeys.kUserType] = 4
        }
        
        dict[APIKeys.kDeviceType] = "ios"
        dict[APIKeys.kDeviceToken] = AppDelegate.DeviceToken
        return dict
    }
    
    init(userDetails: JSONDictionary) {
        self.name = userDetails[APIKeys.kFullName] as? String ?? ""
        self.id = userDetails[APIKeys.kId] as? Int ?? 0
        let image = userDetails[APIKeys.kImage] as? String ?? ""
        let baseUrl = image.contains(BASE_URL) ? "" : BASE_URL
        self.image =  "\(baseUrl)\(userDetails[APIKeys.kImage] as? String ?? "" )"
        self.email = userDetails[APIKeys.kEmail] as? String ?? ""
        self.phoneNumber = userDetails[APIKeys.kPhoneNumber] as? String
        self.description = userDetails[APIKeys.kDescription] as? String
        self.availability = userDetails[APIKeys.kAvailability] as? Bool ?? false
        self.distance = userDetails[APIKeys.kDistance] as? Double ?? 0.00
        let myUser = userDetails[APIKeys.kRole] as? Int ?? 2
        switch myUser{
        case 2:
            self.userType = kUser
        case 3:
            self.userType = kPhotographer
        default:
            self.userType = kBusinessUser
        }
        self.password = userDetails[APIKeys.kPassword] as? String
        
        if let userBankDetails = userDetails[APIKeys.kUserBankDetails] as? JSONDictionary {
        self.paypalAccount = userBankDetails[APIKeys.kPaypalEmail] as? String ?? ""
        self.accountNumber = userBankDetails[APIKeys.kAccountNumber] as? String ?? ""
        self.accountName = userBankDetails[APIKeys.kAccountName] as? String ?? ""
        self.bsbNnumber = userBankDetails[APIKeys.kBsbNumber] as? String ?? ""
        }else{
            self.accountNumber = ""
            self.accountName =  ""
            self.bsbNnumber = ""
            self.paypalAccount = ""
        }
    }
}

extension UserVM {
    
    func parserUserData(responseDict: JSONDictionary) {
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            BaseVC.userDetails = UserDetails(userDetails: data)
            DataManager.userDetails = BaseVC.userDetails.jsonDict
            DataManager.userId = data[APIKeys.kId] as? Int ?? 0
            DataManager.distance = BaseVC.userDetails.distance
            let availability = data[APIKeys.kAvailability] as? Int ?? 1
            if availability == 1 {
                DataManager.availability = true
            }
            else {
                DataManager.availability = false
            }
            DataManager.userType = BaseVC.userDetails.userType
            DataManager.isCardAdded = (data[APIKeys.kCardCount] as? Int ?? 0) > 0 ? true: false
            DataManager.accessToken =  "Bearer \(data[APIKeys.kAccessToken] as? String ?? "")"
        }
    }
}

extension LoginVC {
    
   /* ["picture": {
    data =     {
    height = 200;
    "is_silhouette" = 0;
    url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2088125031&height=200&width=200&ext=15365024&hash=AeSe70wR21Xw";
    width = 200;
    };
    }, "name": User Name, "email": user@gmail.com, "id": 208814565646211739]*/
    func parseFBData(response: JSONDictionary) -> JSONDictionary {
        var dict = JSONDictionary()
        var url = String()
        if let imageData = response[APIKeys.kPicture] as? JSONDictionary {
            if let data = imageData[APIKeys.kData] as? JSONDictionary {
                url = data[APIKeys.kURL] as? String ?? ""
            }
        }
        dict[APIKeys.kImage] = URL(string: url)
        dict[APIKeys.kFullName] = response[APIKeys.kName] as? String ?? ""
        dict[APIKeys.kEmail] = response[APIKeys.kEmail] as? String ?? ""
        dict[APIKeys.kSocialId] = response[APIKeys.kId] as! String
        return dict
    }
    
}

