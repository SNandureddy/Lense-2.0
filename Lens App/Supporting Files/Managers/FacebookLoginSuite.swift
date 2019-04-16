//
//  FacebookLoginSuite.swift
//
//  Copyright © 2018 LensApp. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

typealias FacebookSuiteSuccessClosure = (Bool, Any?) -> ()
typealias FacebookSuiteFailureClosure = (String, Error?) -> ()

let kFBName = "name"
let kFBID = "id"
let kFBEmail = "email"
let kFBImageUrl = "picture.type(large)"


// Available read permissions
enum ReadPermission : String  {
    case  public_profile, email, user_birthday, user_location
    
    static let allValues = [public_profile, email, user_location]
    
    static func defaultPermissions() -> [String] {
        var permissions = [String]()
        
        for perm in ReadPermission.allValues {
            permissions.append(perm.rawValue)
        }
        
        return permissions
    }
}


class FacebookLoginSuite {
    
    var permissions : [String]
    
    var accessToken : FBSDKAccessToken {
        return FBSDKAccessToken.current()
    }
    
    private(set) var grantedPermissions : Set<NSObject>?
    private(set) var declinedPermissions : Set<NSObject>?
    
    private var fbLoginManager = FBSDKLoginManager()
    private var graphConnection: FBSDKGraphRequestConnection?
    
    // MARK: Intializers
    init(permissions: [String]) {
        self.permissions = permissions
    }
    
    convenience init(){
        self.init(permissions:ReadPermission.defaultPermissions())
    }
    
    
    class func activateApp(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        FBSDKAppEvents.activateApp()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Account
    
    func hasLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func logout() {
        if(hasLoggedIn()) {
            fbLoginManager.logOut()
        }
    }
    
    func signInWithController(controller : UIViewController!, success: @escaping FacebookSuiteSuccessClosure, error: @escaping FacebookSuiteFailureClosure) {
        
        let setPermissions = {
            self.grantedPermissions = FBSDKAccessToken.current().permissions as Set<NSObject>?
            self.declinedPermissions = FBSDKAccessToken.current().declinedPermissions as Set<NSObject>?
        }
        
        if hasLoggedIn() {
            
            setPermissions()
            success(true,nil)
            return
        }
        
        // request login
        Indicator.sharedInstance.hideIndicator()
        fbLoginManager.loginBehavior = .web
        fbLoginManager.logIn(withReadPermissions: permissions, from: controller) { [weak self] result, err in
            
            if err != nil {
                error(err!.localizedDescription,err)
                return
            }
            
            guard result?.isCancelled != true else {
                error("Operation Cancelled",err)
                return
            }
            
            let isSuccess = self?.hasLoggedIn()
            
            if let isSuccess = isSuccess {
                self?.userProfile(success: { (status, data) in
                    success(status,data)

                }, error1: { (message, error) in
//                    error(message,error)
                })
                
                if (isSuccess == true) {
                    setPermissions()
                }
            }
        }
    }
    
    
    // MARK: Graph Requests
    
    func userProfile(success: @escaping FacebookSuiteSuccessClosure, error1: @escaping FacebookSuiteFailureClosure) {
        
        guard hasLoggedIn() else {
            error1("Sign In Required", nil)
            return
        }
//        Indicator.sharedInstance.showIndicator()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"\(kFBName),\(kFBID),\(kFBEmail),\(kFBImageUrl)"])

        graphConnection = graphRequest?.start(completionHandler: { (connection, result, err) -> Void in
//            Indicator.sharedInstance.hideIndicator()
            if err != nil {
                error1((err?.localizedDescription)!, err)
                return
            }
            let userData = result as? Dictionary<String,AnyObject>
            success(true, userData)
        })
    }
    
    
    /**
     Makes a GET request to specified path.
     */
    func requestWithPath(path : String, success: @escaping FacebookSuiteSuccessClosure, error: @escaping FacebookSuiteFailureClosure) {
        
        guard hasLoggedIn() else {
            error("Sign In Required",nil)
            return
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: path, parameters:nil)
        
        graphConnection = graphRequest?.start(completionHandler: { (connection, result, err) -> Void in
            if err != nil {
                error((err?.localizedDescription)!,err)
                return
            
            }
            
            success(true,result)
        })
    }
    
    func cancelRequest() {
        graphConnection?.cancel()
        graphConnection = nil
    }
    
    func resetFacebookAccessToken() {
        FBSDKAccessToken.setCurrent(nil)
    }
}
