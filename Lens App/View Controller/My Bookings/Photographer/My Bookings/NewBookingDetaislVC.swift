//
//  NewBookingDetaislVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import UserNotifications

class NewBookingDetaislVC: BaseVC {
    
    //MARK: IBOutlets
 
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    //MARK:- variables
    var index = 0
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        declineButton.set(radius: 5.0, borderColor: UIColor.LensColor.pinkcolor.color(), borderWidth: 2.0)
        acceptButton.set(radius: 5.0, borderColor: UIColor.LensColor.pinkcolor.color(), borderWidth: 2.0)
    }
    
    private func loadData(){
        self.profileImageView.sd_setImage(with: BookingVM.shared.bookingRequestes[self.index].image, placeholderImage: #imageLiteral(resourceName: "placeholder2"), completed: nil)
        self.dateLabel.text =  BookingVM.shared.bookingRequestes[self.index].date
        self.timeLabel.text = BookingVM.shared.bookingRequestes[self.index].time
        self.nameLabel.text = BookingVM.shared.bookingRequestes[self.index].name
        self.locationLabel.text = BookingVM.shared.bookingRequestes[self.index].location
    }
    
    //MARK: IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    
    @IBAction func jobButtonAction(_ sender: UIButton) {
    if sender.tag == 1 { //Decline
            self.showAlert(title: nil, message: kDeclineRequestAsk, cancelTitle: kNo, cancelAction: nil, okayTitle: kYes, {
                self.declineButton.isSelected = true
                self.declineButton.backgroundColor = UIColor.LensColor.pinkcolor.color()
                self.acceptButton.setTitleColor(.white, for: .normal)
                self.acceptButton.isSelected = false
                self.acceptButton.backgroundColor = UIColor.LensColor.white.color()
                self.acceptButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: .normal)
                var parameterDict = JSONDictionary()
                parameterDict[APIKeys.kBookingId] = BookingVM.shared.bookingRequestes[self.index].id
                parameterDict[APIKeys.kValue] = 3 // 3- decline
                self.callApiForAcceptOrRejectRequest(parameterDict: parameterDict, tag: 1)
            })
        }else { //Accept
            acceptButton.isSelected = true
            acceptButton.backgroundColor = UIColor.LensColor.pinkcolor.color()
            acceptButton.setTitleColor(UIColor.LensColor.white.color(), for: .normal)
            declineButton.isSelected = false
            declineButton.backgroundColor = UIColor.LensColor.white.color()
            declineButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: .normal)
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kBookingId] = BookingVM.shared.bookingRequestes[self.index].id
            parameterDict[APIKeys.kValue] = 2 // 2 - accept
            self.callApiForAcceptOrRejectRequest(parameterDict: parameterDict, tag: 0)
        }
    }

}

//MARK:- API Calls
extension NewBookingDetaislVC: UNUserNotificationCenterDelegate {
   
    func callApiForAcceptOrRejectRequest(parameterDict: JSONDictionary, tag: Int) {
        BookingVM.shared.actionOnBookingRequest(dict: parameterDict){ (message, error) in
            if error != nil {
               self.showErrorMessage(error: error)
            }else {
                if tag == 1 {//Decline successfull
                    self.showAlert(title: kSuccess, message: kDeclineRequestSuccess, {
                        self.backButtonAction()
                    })
                }else {
                    //Accept Successfull
                    self.appDelegate.registerForLocalNotification()
                    self.localNotification()
                    self.showAlert(title: kSuccess, message: kAcceptRequestSuccess, {
                        self.backButtonAction()
                    })
                }
            }
        }
    }
    //MARK: Local Notification UI
    func localNotification(){
        
        // content.threadIdentifier = "local-notifications temp"
        let dict = BookingVM.shared.bookingRequestes[self.index]
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
}
