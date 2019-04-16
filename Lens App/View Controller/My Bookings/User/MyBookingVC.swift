//
//  MyBookingVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class MyBookingVC: BaseVC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var currentBookingButton: UIButton!
    @IBOutlet weak var pastBookinButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currentButtonBottomSingleView: UIView!
    @IBOutlet weak var pastButtonBottomSingleView: UIView!
    
   static var selectedTab = 1
    //MARK: - ViewController Variables
    private lazy var bookingHistoryVC: BookingHistoryVC = {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: kBookingHistoryVC) as! BookingHistoryVC
        return vc
    }()
    
    private lazy var bookingDetailVC: BookingDetailsVC = {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: kBookingDetailsVC) as! BookingDetailsVC
        
        return vc
    }()
    private lazy var currentBookingsVC: CurrentBookingsVC = {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: kCurrentBookingsVC) as! CurrentBookingsVC
        vc.superClass = self
        
        return vc
    }()
    
    var transition: CATransition {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.2
        return transition
    }

    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        self.customiseUI()
        
    }
    
    //MARK: - Private Methods
    private func customiseUI() {
        if DataManager.userType == kUser || DataManager.userType == kBusinessUser {
            self.currentBookingButton.setTitle("Current Booking", for: .normal)
            self.pastBookinButton.setTitle("Past Booking", for: .normal)
        }else if DataManager.userType == kPhotographer{
            self.currentBookingButton.setTitle("New Booking", for: .normal)
            self.pastBookinButton.setTitle("Current Booking", for: .normal)
        }
    }
    
    //MARK: - IBActions
    @IBAction func menuBarAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
    
    @IBAction func headerButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if DataManager.userType == kUser || DataManager.userType == kBusinessUser { //in case of user and business
            if sender  ==  currentBookingButton { //current booking action
                currentBookingButton.isSelected = true
                pastBookinButton.isSelected = false
            currentBookingButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: UIControl.State.normal)
                currentButtonBottomSingleView.backgroundColor = UIColor.LensColor.pinkcolor.color()
                pastButtonBottomSingleView.backgroundColor = UIColor.LensColor.lightGray.color()
            pastBookinButton.setTitleColor(UIColor.LensColor.lightGray.color(), for: UIControl.State.normal)
                var parameterDict = JSONDictionary()
                parameterDict[APIKeys.kBookingType] = 1
                self.loadCurrentBookingData(parameterDict: parameterDict)
            }else  { // past booking action
                MyBookingVC.selectedTab = 2
                pastBookinButton.isSelected = true
                currentBookingButton.isSelected = false
                pastBookinButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: UIControl.State.normal)
                pastButtonBottomSingleView.backgroundColor = UIColor.LensColor.pinkcolor.color()
                currentButtonBottomSingleView.backgroundColor = UIColor.LensColor.lightGray.color()
                currentBookingButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
                self.add(childVC: bookingHistoryVC)
                
            }
        }else{ //in case of photographer
            if sender  ==  pastBookinButton { //new booking action
                var parameterDict = JSONDictionary()
                parameterDict[APIKeys.kBookingType] = 1
                self.loadCurrentBookingData(parameterDict: parameterDict)
            }else { // current booking action
                
            }
        }
    }
    
    func setUpInitialview(){
        currentBookingButton.isSelected = false
        pastBookinButton.isSelected = true
        currentBookingButton.setTitleColor(UIColor.LensColor.white.color(), for: UIControl.State.normal)
        currentButtonBottomSingleView.backgroundColor = UIColor.LensColor.white.color()
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingType] = 1
        self.loadCurrentBookingData(parameterDict: parameterDict)
        headerButtonAction(self.currentBookingButton)
    }
}

//Handle Custom Views
extension MyBookingVC {
    //Add Child View Controller
    func add(childVC: UIViewController) {
        self.removeAll()
        self.addChild(childVC)
        self.containerView.addSubview(childVC.view)
        self.containerView.layer.add(transition, forKey: kCATransition)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParent: self)
    }
    
    //Remove Child View Controller
    func remove(childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
    
    //Remove All Child View Controller
    func removeAll() {
        self.remove(childVC: bookingHistoryVC)
        self.remove(childVC: bookingDetailVC)
    }
}

//MARK : - API calls
extension MyBookingVC {
    
    func loadCurrentBookingData(parameterDict: JSONDictionary ){
        BookingVM.shared.myBookings(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                if BookingVM.shared.userCurrentBookingArray.count > 0{
                    self.add(childVC: self.currentBookingsVC)
                    self.currentBookingsVC.loadCurrentData()
                }else{
                    self.add(childVC: self.bookingDetailVC)
                    self.bookingDetailVC.loadCurrentData()
                }
            }
        }
    }
}


extension MyBookingVC:superClassDelegate{
    func CallSuperClassMethod() {
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingType] = 1
        self.loadCurrentBookingData(parameterDict: parameterDict)
    }
    
}
