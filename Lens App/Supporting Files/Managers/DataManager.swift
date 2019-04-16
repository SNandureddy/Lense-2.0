//
//  DataManager.swift
//  KidzWatch
//
//  Created by ios28 on 17/04/18.
//  Copyright © 2018 ios28. All rights reserved.
//

import Foundation

class DataManager {
    
    static var userType: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kUserType)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.string(forKey: kUserType)
        }
    }
    
    static var isCardAdded: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kCardAdded)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.bool(forKey: kCardAdded)
        }
    }
    
    static var accessToken: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kAccessToken)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.string(forKey: kAccessToken)
        }
    }
    
    static var userId: Int? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kUserId)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.integer(forKey: kUserId)
        }
    }
    
    static var distance: Double? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kDistance)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.double(forKey: kDistance)
        }
    }
    
    static var availability: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kAvailability)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.bool(forKey: kAvailability)
        }
    }
    
    static var userDetails: JSONDictionary? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kUserDetails)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.dictionary(forKey: kUserDetails)
        }
    }
    static var packageId: Int? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: APIKeys.kPackageId)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.integer(forKey: APIKeys.kPackageId)
        }
    }
}
