//
//  StripeManager.swift
//  Lens App
//
//  Created by Apple on 09/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
import Stripe

typealias stripeCallBack = ((JSONDictionary?, Error?) -> ())

class StripeManager: NSObject {
    
    private var STRIPE_KEY = "pk_test_RECy3pBIguZrzHUuDTIdVjBM" //Sandbox Key
   // private var STRIPE_KEY = "pk_live_YmDa9oL2eCmW8MSMQeOQxPar" //Live Key

    static let shared = StripeManager()
    
    func setupStripe() {
        STPPaymentConfiguration.shared().publishableKey = STRIPE_KEY
    }
    
    func saveCard(cardNumber: String, expMonth: Int, expYear: Int, cvv: String, success: @escaping stripeCallBack) {
        
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(expMonth)
        cardParams.expYear = UInt(expYear)
        cardParams.cvc = cvv
        
        Indicator.sharedInstance.showIndicator()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            Indicator.sharedInstance.hideIndicator()
            if error != nil {
                success(nil, error)
            }
            else {
                
                let locale = Locale.current
                let currencyCode = locale.currencyCode!
                let dict = [APIKeys.kCardNumber: "XXXXXXXXXXXX\(token!.card!.last4)", APIKeys.kStripeCardId: token!.tokenId,APIKeys.kStripeCurrency:currencyCode]
                success(dict, nil)
            }
        }
    }
}
