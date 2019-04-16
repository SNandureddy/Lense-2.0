//
//  SideMenuVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class SideMenuVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    var screenType: CGFloat {
        switch  UIScreen.main.nativeBounds.height {
        case 960:
            return 0//.iPhones_4_4S
        case 1136:
            return 0//64.iPhones_5_5s_5c_SE
        case 1334:
            return 0//.iPhones_6_6s_7_8
        case 1624.0:
            return 20//.iPhone_XR
        case 1920, 2208:
            return 0//.iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return 20//.iPhones_X_XS
        case 2688:
            return 30//.iPhone_XSMax
        default:
            return 0//.unknown
        }
    }
    
    var userArray = ["Book Photographer", "My Bookings", "My Images", "Notifications", "Settings","Send Feedback", "Logout"]
    var userImagesArray = [#imageLiteral(resourceName: "cart"),#imageLiteral(resourceName: "Booking"),#imageLiteral(resourceName: "My_Images"),#imageLiteral(resourceName: "notifications"),#imageLiteral(resourceName: "Setting"),#imageLiteral(resourceName: "feedback1x"),#imageLiteral(resourceName: "logout")]
    var photographerArray = ["My Bookings", "Past Bookings", "Settings",  "Send Feedback", "Logout"]
    var photographeImagesArray = [#imageLiteral(resourceName: "Booking"),#imageLiteral(resourceName: "Booking"),#imageLiteral(resourceName: "Setting"),#imageLiteral(resourceName: "feedback1x"),#imageLiteral(resourceName: "logout")]
    static var selectedIndex = 0
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
         self.tableViewTopConstraint.constant = screenType
    }
}

//MARK: Tableview Datasource
extension SideMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (DataManager.userType == kUser || DataManager.userType == kBusinessUser) ? 7: 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if DataManager.userType == kUser || DataManager.userType == kBusinessUser {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
            cell.menuItemlabel.text = userArray[indexPath.row]
            cell.menuItemImageView.image = userImagesArray[indexPath.row]
            
            return cell
        }else if DataManager.userType == kPhotographer{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
            cell2.menuItemlabel.text = photographerArray[indexPath.row]
            cell2.menuItemImageView.image = photographeImagesArray[indexPath.row]
         
            return cell2
        }
        return UITableViewCell()
    }
}

//MARK: Tableview Delegate
extension SideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if DataManager.userType == kUser || DataManager.userType == kBusinessUser { //for normal user and Business User
            handleUserScreens(index: indexPath.row)
        }else if DataManager.userType == kPhotographer {
            handlePhotographerScreens(index: indexPath.row)
        }
    }
    
    func handleUserScreens(index: Int) {
        switch index {
        case 0: //Book Photographer
            let storyboard = UIStoryboard(storyboard: .BookPhotographer)
            let bookvc = storyboard.instantiateViewController(withIdentifier: kBookPhotographerVC) as! BookPhotographerVC
            let navigationController  = UINavigationController(rootViewController: bookvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 1: //My Bookings
            let storyboard = UIStoryboard(storyboard: .MyBookings)
            let bookvc = storyboard.instantiateViewController(withIdentifier: kMyBookingVC) as! MyBookingVC
            let navigationController  = UINavigationController(rootViewController: bookvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 2: //My Images
            let storyboard = UIStoryboard(storyboard: .MyImages)
            let myimagevc = storyboard.instantiateViewController(withIdentifier: kMyImagesVC) as! MyImagesVC
            let navigationController  = UINavigationController(rootViewController: myimagevc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 3: //My Notifications
            let storyboard = UIStoryboard(storyboard: .Notifications)
            let notificationvc = storyboard.instantiateViewController(withIdentifier: kNotificationVC) as! NotificationsVC
            let navigationController  = UINavigationController(rootViewController: notificationvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 4: //Settings
            let storyboard = UIStoryboard(storyboard: .Settings)
            let settingsvc = storyboard.instantiateViewController(withIdentifier: kSettingsVC) as! SettingsVC
            settingsvc.screenType = kUser
            let navigationController  = UINavigationController(rootViewController: settingsvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 5: //Feedback
            let storyboard = UIStoryboard(storyboard: .Settings)
            let settingsvc = storyboard.instantiateViewController(withIdentifier: kFeedbackVC) as! FeedbackVC
            let navigationController  = UINavigationController(rootViewController: settingsvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 6: //Logout
            self.showAlert(title: kSuccess, message: kLogoutSure, cancelTitle: kCancel , cancelAction: {
             self.appDelegate.drawerContainer?.closeDrawer(animated: true, completion: nil)
            }, okayTitle: kYes, {
                self.callApiForLogout(userId: DataManager.userId!)
            }, titleBottomsingleView: true)
           
            return
        default:
            return
        }
    }
    
    func handlePhotographerScreens(index: Int) {
        switch index {
        case 0: //My Bookings
            let storyboard = UIStoryboard(storyboard: .MyBookings)
            let bookvc = storyboard.instantiateViewController(withIdentifier: kPhotographerBookingsVC) as! PhotographerBookingsVC
            let navigationController  = UINavigationController(rootViewController: bookvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 1: //Past Bookings
            let storyboard = UIStoryboard(storyboard: .MyBookings)
            let bookvc = storyboard.instantiateViewController(withIdentifier: kPastBookingVC) as! PastBookingVC
            let navigationController  = UINavigationController(rootViewController: bookvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 2: //Settings
            let storyboard = UIStoryboard(storyboard: .Settings)
            let settingsvc = storyboard.instantiateViewController(withIdentifier: kSettingsVC) as! SettingsVC
            settingsvc.screenType = kPhotographer
            let navigationController  = UINavigationController(rootViewController: settingsvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 3: //Feedback
            let storyboard = UIStoryboard(storyboard: .Settings)
            let settingsvc = storyboard.instantiateViewController(withIdentifier: kFeedbackVC) as! FeedbackVC
            let navigationController  = UINavigationController(rootViewController: settingsvc)
            appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: true, completion: nil)
            return
        case 4: //Logout
            self.showAlert(title: kSuccess, message: kLogoutSure, cancelTitle: kCancel, cancelAction: {
                self.appDelegate.drawerContainer?.closeDrawer(animated: true, completion: nil)
            }, okayTitle: kYes, {
                self.callApiForLogout(userId:DataManager.userId!)
            }, titleBottomsingleView: true)
            return
        default:
            return
        }
    }
}

// MARK: - API Calls
extension SideMenuVC {
    func callApiForLogout(userId: Int) {
        UserVM.shared.logout(userId: userId) { (message, error) in
            if error != nil {
                super.showErrorMessage(error: error)
            }else {
           self.logout()
            }
        }
        
    }
    
}
