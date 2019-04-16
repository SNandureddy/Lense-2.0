//
//  AppDelegate.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    static var DeviceToken = String()
    var dateTimeArray = [Double]()
    var transition: CATransition {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.2
        return transition
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Crashlytics.sharedInstance().debugMode = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        UIApplication.shared.statusBarStyle = .lightContent
        StripeManager.shared.setupStripe()
        self.registerForLocalNotification()
        self.registerForRemoteNotification()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if DataManager.userType != nil {
            if DataManager.userType == kPhotographer{
                DispatchQueue.global(qos: .background).async {
                    self.loadCurrentBookingData()
                    
                }
            }
            BaseVC.userDetails = UserDetails(userDetails: DataManager.userDetails!)
            DataManager.userDetails = BaseVC.userDetails.jsonDict
            self.loadLeftSideMenu(centerVC: nil)
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}


//MARK: Load Views
extension AppDelegate {
    
    func loadLeftSideMenu(centerVC : UIViewController?, selecetedIndex: Int = 0) {
        var centerViewController = UIViewController()
        
        let main = UIStoryboard(storyboard: .Main)
        let bookPhotographer = UIStoryboard(storyboard: .BookPhotographer)
        let mybooking = UIStoryboard(storyboard: .MyBookings)
        let bookvc = bookPhotographer.instantiateViewController(withIdentifier: kBookPhotographerVC) as! BookPhotographerVC
        let myBookingvc = mybooking.instantiateViewController(withIdentifier: kPhotographerBookingsVC) as! PhotographerBookingsVC
        let sidevc = main.instantiateViewController(withIdentifier: kSideMenuVC) as! SideMenuVC
        
        if centerVC == nil {
            SideMenuVC.selectedIndex = selecetedIndex
            centerViewController = UINavigationController(rootViewController: bookvc)
            if DataManager.userType == kPhotographer {
                centerViewController = UINavigationController(rootViewController: myBookingvc)
                    DispatchQueue.global(qos: .background).async {
                    self.loadCurrentBookingData()
                 }
            }
        }else {
            SideMenuVC.selectedIndex = selecetedIndex
            centerViewController = UINavigationController(rootViewController: centerVC!)
        }
        
        drawerContainer = MMDrawerController(center: centerViewController, leftDrawerViewController: sidevc)
        drawerContainer?.closeDrawerGestureModeMask = .tapCenterView
        drawerContainer!.showsShadow = false
        drawerContainer!.maximumLeftDrawerWidth = 230.0
        if UIApplication.shared.keyWindow == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.layer.add(transition, forKey: kCATransition)
            self.window?.rootViewController = self.drawerContainer
            self.window?.makeKeyAndVisible()
        }else {
            UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController = self.drawerContainer
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
    
//    func showAddCardScreen() {
//        let storyboard = UIStoryboard(storyboard: .Settings)
//        let cardvc = storyboard.instantiateViewController(withIdentifier: kCardDetailsVC) as! CardDetailsVC
//        let navvc = UINavigationController(rootViewController: cardvc)
//        if UIApplication.shared.keyWindow == nil {
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.layer.add(transition, forKey: kCATransition)
//            self.window?.rootViewController = navvc
//            self.window?.makeKeyAndVisible()
//        }else {
//            UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
//            UIApplication.shared.keyWindow?.rootViewController = navvc
//            UIApplication.shared.keyWindow?.makeKeyAndVisible()
//        }
//    }
}

//MARK: UNUserNotificationCenterDelegate
extension AppDelegate {
    
    //MARK: Notification Settings
    func registerForRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound,.badge,.alert], completionHandler: { (granted, error) in
            if error == nil{
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        })
    }
    
    //MARK: Local Notifications
    func registerForLocalNotification(){
         /*UNUserNotificationCenter.current().delegate = self
         UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.badge,.alert], completionHandler: { (granted, error) in
            if error != nil{
                print(error as Any)
            }else{
                print("Authorization Successfull")
            }
        })*/
    }
    
    //Register For remote Notifcation
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        AppDelegate.DeviceToken = deviceTokenString
        print("*** DEVICE TOKEN ***:\n \(deviceTokenString)")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("*** DEVICE TOKEN FAILED ERROR ***:\n \(error)")
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle it for Foreground State
        //        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        if let responseDict = userInfo[APIKeys.kAps] as? JSONDictionary {
            print(responseDict)
            if let details = responseDict[APIKeys.kDetails] as? JSONDictionary  {
                let notifyKey = details[APIKeys.kNotifyKey] as? String ?? ""
                if notifyKey == kNewRequest {
                    self.loadLeftSideMenu(centerVC: nil)
                }else if notifyKey == kActionRequestReject {//decline request
                    //user will create a new request if previous one is declined by photogrpaher
                    let storyboard = UIStoryboard(name: Storyboard.BookPhotographer.rawValue, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: kBookPhotographerVC)
                    self.loadLeftSideMenu(centerVC:vc)
                }else if notifyKey == kActionRequestAccept  {//Accepted Request action_request
                    let storyboard = UIStoryboard(name: Storyboard.MyBookings.rawValue, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: kMyBookingVC)
                    self.loadLeftSideMenu(centerVC:vc, selecetedIndex: 1 )
                }else if notifyKey == kUplodImage {//photo Uploaded upload_image
                    let storyboard = UIStoryboard(name: Storyboard.MyImages.rawValue, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: kMyImagesVC)
                    self.loadLeftSideMenu(centerVC:vc, selecetedIndex: 2 )
                }else if notifyKey == kAdminNotification{
                
                    let storyboard = UIStoryboard(name: Storyboard.Notifications.rawValue, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: kNotificationVC)
                    self.loadLeftSideMenu(centerVC:vc, selecetedIndex: 3 )
                }
            }
        }
    }
}

//MARK: UIApplication Extension
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
extension AppDelegate{
   
    func loadCurrentBookingData(){
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingType] = 1
        BookingVM.shared.myBookings(dict: parameterDict) { (message, error) in
            if error != nil {
                baseVc.showErrorMessage(error: error)
                
            }else {
                self.localNotification()
            }
           
        }
    }
    
    //MARK: Local Notification UI
    func localNotification(){
       
       // content.threadIdentifier = "local-notifications temp"
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for index in 0..<BookingVM.shared.currentBookingRequestes.count {
            if index>=32 {
                break
            }
           
            let dict = BookingVM.shared.currentBookingRequestes[index]
            let content = UNMutableNotificationContent()
            content.title = "Lense App"
            content.body = "Your booking is schedule at \(dict.date!), \(dict.time!)"
            content.sound = UNNotificationSound.default
            let dateTime = dict.dateTimeMilli ?? 0.0
            let diffTwoHrs = (dateTime - (7200 * 1000))
            let twoHrsDate = Date(milliseconds: diffTwoHrs)
            let diff24Hrs = (dateTime - (86400 * 1000))
            let date24Hrs = Date(milliseconds: diff24Hrs)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: twoHrsDate as Date)
            print(components)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            UNUserNotificationCenter.current().delegate = self
            let request = UNNotificationRequest(identifier: "content2\(dict.id!)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil{
                    print(error as Any)
                }
            }
            
            let components1 = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: date24Hrs as Date)
            let trigger1 = UNCalendarNotificationTrigger(dateMatching: components1, repeats: false)
            UNUserNotificationCenter.current().delegate = self
            let request1 = UNNotificationRequest(identifier: "content24\(dict.id!)", content: content, trigger: trigger1)
            UNUserNotificationCenter.current().add(request1) { (error) in
                if error != nil{
                    print(error as Any)
                }
            }
        }
    }
}
