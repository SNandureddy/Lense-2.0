//
//  BookPhotographerVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import CoreLocation

class BookPhotographerVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var sendRequest: UIButton!
    @IBOutlet weak var leftBookingsLabel: UILabel!
    @IBOutlet var planPopUpObject: subscriptionPlanPopUp!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet var couponView: UIView!
    @IBOutlet weak var couponCodeContainerVIew: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var applyCoupanCodeButton: UIButton!
    @IBOutlet weak var forLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateContainerView: UIView!
    
    //Variable
    var dateMilliseconds = Int()
    var dateSelected = Date()
    var formatDate = String()
    static var iscardAdd = true
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pickerDelegate = self
        self.getCurrentLocation(success: {_ in }
        )
        self.callAPIToGetBookingsDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        dateContainerView.set(radius: 5.0)
        sendRequest.set(radius: 5.0)
    }
    
    //MARK: IBActions
    @IBAction func menuButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
    
    @IBAction func sendRequestButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if dateTextField.text == kEmptyString{
            self.showAlert(message: kSelectDateMessage)
            
        }else{
            if !DataManager.isCardAdded {
                if DataManager.userType ==  kBusinessUser{
                    self.planPopUpObject.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    self.planPopUpObject.initiatePopUp(pack1Amount: BookingVM.shared.leftBookingObject.packages[0].amount!, pack2Amount: BookingVM.shared.leftBookingObject.packages[1].amount!)
                    UIApplication.shared.keyWindow?.addSubview(self.planPopUpObject)
                    self.planPopUpObject.popUpContainer.showWithBottomUpAnimation(yOrigin: 100) { (status) in
                        self.planPopUpObject.plan1OkButton.addTarget(self, action: #selector(self.hidePopUp), for: .touchUpInside)
                        self.planPopUpObject.plan2OkButton.addTarget(self, action: #selector(self.hidePopUp), for: .touchUpInside)
                    }
                }
                else{
                    self.showAddCardScreen()
                }
            }
            else {
                callAPIToBookPhotographer()
            }
        }
    }
    
    @IBAction func coupanApplyButtonAction(_ sender: Any) {
        
        if couponTextField.text == kEmptyString {
            self.showAlert(message: kApplyCouponCode)
            return
        }
       
        self.callAPIToBookPhotographer()
         hideCouponView()
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        hideCouponView()
        if !DataManager.isCardAdded {
            
            if DataManager.userType ==  kBusinessUser{
                self.planPopUpObject.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.planPopUpObject.initiatePopUp(pack1Amount: BookingVM.shared.leftBookingObject.amount!)
                self.planPopUpObject.initiatePopUp(pack1Amount: BookingVM.shared.leftBookingObject.packages[0].amount!, pack2Amount: BookingVM.shared.leftBookingObject.packages[1].amount!)
                UIApplication.shared.keyWindow?.addSubview(self.planPopUpObject)
                self.planPopUpObject.popUpContainer.showWithBottomUpAnimation(yOrigin: 100) { (status) in
                    self.planPopUpObject.plan1OkButton.addTarget(self, action: #selector(self.hidePopUp), for: .touchUpInside)
                    self.planPopUpObject.plan2OkButton.addTarget(self, action: #selector(self.hidePopUp), for: .touchUpInside)
                }
            }
            else{
                self.showAddCardScreen()
            }
        }
        else {
            callAPIToBookPhotographer()
        }
    }
    
    @objc func hidePopUp()  {
        self.planPopUpObject.popUpContainer.hideWithUpDownAnimation(yOrigin: 100) { (status) in
            self.showAddCardScreen()
            self.planPopUpObject.plan1OkButton.removeTarget(self, action: #selector(self.hidePopUp), for: .touchUpInside)
            self.planPopUpObject.plan2OkButton.removeTarget(self, action: #selector(self.hidePopUp), for: .touchUpInside)
            self.planPopUpObject.removeFromSuperview()
        }
    }
    
    func showAddCardScreen() {
        let storyboard = UIStoryboard(storyboard: .Settings)
        let cardvc = storyboard.instantiateViewController(withIdentifier: kCardDetailsVC) as! CardDetailsVC
        self.navigationController?.show(cardvc, sender: self)
    }
    
    func showCouponView(){
        couponView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(couponView)
    }
    
    func hideCouponView(){
        couponTextField.text = kEmptyString
        couponView.removeFromSuperview()
    }
}


//MARK: Validate Data
extension BookPhotographerVC {
    func addData() -> JSONDictionary? {
        var dict = JSONDictionary()
        if currentLocation == nil {
            self.showAlert(message: kLocationMessage, {
                self.openSettings()
            })
            return nil
        }
        dict[APIKeys.kLatitude] = currentLocation.latitude
        dict[APIKeys.kLongitude] = currentLocation.longitude
        dict[APIKeys.kLocation] = self.address
        dict[APIKeys.kCouponCode] =  "" //couponTextField.text!
        let locale = Locale.current
        let currencyCode = locale.currencyCode ?? "USD"
        dict[APIKeys.kStripeCurrency] = currencyCode
        dict[APIKeys.kBookingDate] = dateMilliseconds
        dict[APIKeys.kTimeZone] = TimeZone.ReferenceType.default
        if DataManager.userType == kUser{
            dict[APIKeys.kPackageId] = 1
        }else{
            dict[APIKeys.kPackageId] = DataManager.packageId ?? 0
        }
        return dict
    }
}

//MARK: API Methods
extension BookPhotographerVC {
    
    func callAPIToBookPhotographer() {
        if let dict = self.addData() {
            BookingVM.shared.bookPhotographer(dict: dict) { (message, error) in
                if error != nil {
                    self.showErrorMessage(error: error!)
                }else {
                    self.showAlert(title: kSuccess, message: kBookPhotographerSuccess, {
                        let storyboard = UIStoryboard(storyboard: .MyBookings)
                        SideMenuVC.selectedIndex = 1
                        let bookvc = storyboard.instantiateViewController(withIdentifier: kMyBookingVC) as! MyBookingVC
                        let navigationController  = UINavigationController(rootViewController: bookvc)
                        self.appDelegate.drawerContainer?.setCenterView(navigationController, withCloseAnimation: false, completion: nil)
                    })
                }
            }
        }
    }
    
    func callAPIToGetBookingsDetail() {
        BookingVM.shared.bookings() { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error!)
            }
            else if DataManager.userType == kUser{
                self.leftBookingsLabel.text = "2 Photos"
                self.forLabel.isHidden = false
                if let price = BookingVM.shared.leftBookingObject?.amount {
                    self.priceLabel.text = "$\(price)"
                }
                else {
                    self.leftBookingsLabel.text = ""
                    self.priceLabel.text = ""
                }
                DataManager.packageId = BookingVM.shared.leftBookingObject?.packId
            }else {
                self.leftBookingsLabel.text = "Bookings Left"
                self.forLabel.isHidden = true  
                self.priceLabel.text = BookingVM.shared.leftBookingObject?.message
                DataManager.packageId = BookingVM.shared.leftBookingObject?.packId
            }
        }
    }
}
extension BookPhotographerVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerType = "date"
        self.setDatePickerView(textField: dateTextField, isCurrent: true,pickerMode: .Date)
        self.tempDate = Date()
        dateMilliseconds = Int(Date().millisecondsSince1970)
        dateTextField.text = (NSDate() as Date).stringFromDate(format: .mdytimeDate, type: .local)
       
    }
}

//MARK: BaseViewControllerDelegate
extension BookPhotographerVC: BaseViewControllerDelegate {
    
    func didSelectDatePicker(date: Date) {
        self.pickerType = "date"
        //dateTextField.text = date.stringFromDate(format: .mdytimeDate, type: .local)
        dateMilliseconds = Int(date.millisecondsSince1970)
        
    }
}
