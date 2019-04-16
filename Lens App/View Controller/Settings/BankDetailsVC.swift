//
//  BankDetailsVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import CoreLocation

class BankDetailsVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var paypalAccountTextField: UITextField!
    
    //MARK: Variables
    var screenType = kNew
    var imageDict = [String: Data]()
    var socialDict = JSONDictionary()
    
    //MARK: Class Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        headerTitleLabel.text = screenType == kUpdate ? kUpdateBankDetails: kAddBankDetails
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        self.getCurrentLocation(success: {_ in })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        
        paypalAccountTextField.set(radius: 5.0, borderColor: UIColor.lightGray, borderWidth: 1.0)
        shadowView.layer.cornerRadius = 5.0
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        signupButton.set(radius: 5.0)
        if screenType == kUpdate {
            signupButton.setTitle(kUPDATE, for: .normal)
        }
    }
    
    private func setupData() {
        //TODO: To be removed
        if screenType == kUpdate {
            paypalAccountTextField.text = BaseVC.userDetails.paypalAccount//"John Doe"
        }
    }
    
    //MARK: IBActions
    @IBAction func signupButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
            return
        }
        if screenType == kUpdate {
            var parameterDict = JSONDictionary()
            
            parameterDict[APIKeys.kPaypalEmail] = paypalAccountTextField.text!
            self.editBankDetails(dict: parameterDict)
        }
        else {
            self.callAPIToSignupByEmail()
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
}

//MARK: Validations
extension BankDetailsVC {
    
    func validateData() -> String? {
        if !paypalAccountTextField.isValidName { //paypal account Name
            return kPayPalAccountValidation
        }
        return nil
    }
    
    func addData() -> Bool {
          BaseVC.userDetails.paypalAccount = paypalAccountTextField.text!
        if currentLocation ==  nil {
            self.showAlert(message: kLocationMessage, {
                self.openSettings()
            })
            return false
        }
        return true
    }
}

//MARK: TextField Delegates
extension BankDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.rangeOfCharacter(from: CharacterSet.symbols) != nil) {
            return false
        }
        let characterLength = textField.text!.utf16.count + (string.utf16).count - range.length
        if textField == paypalAccountTextField { //Account Name
            return (characterLength < 51)
        }
        if textField == paypalAccountTextField { //Account Number
            if (string.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil) {
                return false
            }
            return (characterLength < 18)
        }
        if textField == paypalAccountTextField { //BSB Number
            if (string.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil) {
                return false
            }
            return (characterLength < 5)
        }
        return true
    }
}

//MARK: API Methods
extension BankDetailsVC {
    
    func callAPIToSignupByEmail() {
        if addData() {
            var dict = BaseVC.userDetails.jsonDict
            dict[APIKeys.kLatitude] = self.currentLocation.latitude
            dict[APIKeys.kLongitude] = self.currentLocation.longitude
            dict[APIKeys.kLocation] = self.address
            dict[APIKeys.kLoginType] = self.socialDict.count > 0 ? 2: 1
            if socialDict.count > 0 {
                dict[APIKeys.kSocialId] = socialDict[APIKeys.kSocialId] as? String ?? ""
                if imageDict.count == 0 {
                    dict[APIKeys.kImage] = (socialDict[APIKeys.kImage] as? URL)?.absoluteString ?? ""
                }
            }

            UserVM.shared.signup(dict: dict, imageDict: imageDict) { (_, error) in
                if error != nil {
                    self.showErrorMessage(error: error!)
                }
                else {
                    self.showAlert(title: kSuccess, message:  kSocialSignupSuccess, {
                         self.loadSideMenu()
                    })
                }
            }
        }
    }
    
    func editBankDetails(dict: JSONDictionary) {
        SettingVM.shared.editBankAccount(dict: dict) { (message, error) in
            if error != nil {
               super.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess, message: kBankDetailsSuccess, {
                    BaseVC.userDetails.paypalAccount = self.paypalAccountTextField.text!
                    self.backButtonAction()
                })
            }
        }
    }
}
