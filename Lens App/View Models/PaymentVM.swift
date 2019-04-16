//
//  PaymentVM.swift
//  Lens App
//
//  Created by Apple on 17/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

class PaymentVM {
    public static let shared = PaymentVM()
    private init() {}
    
    func addCard(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.saveCard(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
}
