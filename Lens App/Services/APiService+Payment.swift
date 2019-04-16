//
//  APiService+Payment.swift
//  Lens App
//
//  Created by Apple on 17/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
enum PaymentAPIServices: APIService {
    
    case saveCard(dict: JSONDictionary)
    
    var path: String {
        var path = ""
        switch self {
        case .saveCard:
            path = BASE_URL.appending("/api/add-card")
        }
        return path
    }
    
    var resource: Resource {
        var resource: Resource!
        switch self {
        case let .saveCard(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        }
        return resource
    }
    
}

// MARK: - API Calls
extension APIManager {
    
    class func saveCard(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        PaymentAPIServices.saveCard(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}

