//
//  LoginVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Crashlytics

class LoginVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet var outerViewCollection: [UIView]!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookImageOuterView: UIView!
    @IBOutlet weak var loginFbOuterView: UIView!
    @IBOutlet weak var facebookButtonOuterView: UIView!
    
    //MARK: Variables
    var socialID = String()
    
    //MARK: Class Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeViews()
        self.hideNavigationBar()
        self.getCurrentLocation(success: {_ in })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: IBActions

    @IBAction func loginButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if let message = validateData() {
            self.showAlert(message: message)
        }
        else {
            self.login()
        }
    }
   
    @IBAction func forgotButtonAction(_ sender: Any) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(nav, animated: true
        )
    }
    @IBAction func fbButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        Indicator.sharedInstance.showIndicator()
        self.facebookLogin()
    }

}
//MARK: Validations
extension LoginVC {

    func validateData() -> String? {
        if !emailTextField.isValidEmail {
            return kEmailValidation
        }
        if !passwordTextField.isValidPassword {
            return kPasswordValidation
        }
        return nil
    }

    func addEmailData(response: @escaping (JSONDictionary?)->()) { //Handle Email Data Request
        var dict = JSONDictionary()
        dict[APIKeys.kEmail] = emailTextField.text!
        dict[APIKeys.kPassword] = passwordTextField.text!
        dict[APIKeys.kDeviceType] = "ios"
        dict[APIKeys.kDeviceToken] = AppDelegate.DeviceToken
        dict[APIKeys.kLoginType] = 1
        if currentLocation == nil {
            if LocationManager.shared.isLoocationAccessEnabled() {
                self.getCurrentLocation { (success) in
                    if success {
                        dict[APIKeys.kLatitude] = self.currentLocation.latitude
                        dict[APIKeys.kLongitude] = self.currentLocation.longitude
                        dict[APIKeys.kLocation] =  self.address
                        response(dict)
                    }
                    else {
                        response(nil)
                    }
                }
            }
            else {
                self.showAlert(message: kLocationMessage, {
                    self.openSettings()
                })
                response(nil)
            }
        }
        else {
            dict[APIKeys.kLatitude] = currentLocation.latitude
            dict[APIKeys.kLongitude] = currentLocation.longitude
            dict[APIKeys.kLocation] =  self.address
            response(dict)
        }
    }

    func addFBData(fbData: JSONDictionary,response: @escaping (JSONDictionary?)->()){ //Handle FB Data Request
        var dict = JSONDictionary()
        dict[APIKeys.kSocialId] = socialID
        dict[APIKeys.kEmail] = fbData[APIKeys.kEmail] as? String ?? ""
        dict[APIKeys.kDeviceType] = "ios"
        dict[APIKeys.kLoginType] = 2
        dict[APIKeys.kDeviceToken] = AppDelegate.DeviceToken
        if currentLocation == nil {
            if LocationManager.shared.isLoocationAccessEnabled() {
                self.getCurrentLocation { (success) in
                    if success {
                        dict[APIKeys.kLatitude] = self.currentLocation.latitude
                        dict[APIKeys.kLongitude] = self.currentLocation.longitude
                        dict[APIKeys.kLocation] =  self.address
                        response(dict)
                    }
                    else {
                        response(nil)
                    }
                }
            }
            else {
                self.showAlert(message: kLocationMessage, {
                    self.openSettings()
                })
                response(nil)
            }
        }
        else {
            dict[APIKeys.kLatitude] = currentLocation.latitude
            dict[APIKeys.kLongitude] = currentLocation.longitude
            dict[APIKeys.kLocation] =  self.address
            response(dict)
        }
    }
}

//MARK: TextField Delegates
extension LoginVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.rangeOfCharacter(from: CharacterSet.symbols) != nil) {
            return false
        }
        return true
    }
}

//MARK: API Methods
extension LoginVC {

    func facebookLogin() {
        let fbSuite = FacebookLoginSuite()
        fbSuite.logout()
        fbSuite.signInWithController(controller: self, success: { (success, response) in
            print("*** FB RESPONSE ***:\n \(response ?? "No Response")")
            let dict = self.parseFBData(response: response as! JSONDictionary)
            self.socialID = dict[APIKeys.kSocialId] as! String
            Indicator.sharedInstance.hideIndicator()
            self.login(fbData: dict)
        }) { (errorReason, error) in
            Indicator.sharedInstance.hideIndicator()
        }
    }

    func login(fbData: JSONDictionary? = nil) {
        if fbData != nil {
            self.addFBData(fbData: fbData!) { (jsonDict) in
                if jsonDict != nil {
                    self.callAPIToLogin(dict: jsonDict!, fbData: fbData)
                }
            }
        }
        else {
            self.addEmailData { (jsonDict) in
                if jsonDict != nil {
                    self.callAPIToLogin(dict: jsonDict!, fbData: fbData)
                }
            }
        }
    }

    func callAPIToLogin(dict: JSONDictionary, fbData: JSONDictionary?) {
        UserVM.shared.login(dict: dict) { (message, error) in
            if error != nil {
                if (error! as NSError).code == 400 && fbData != nil {
                    debugPrint((error as NSError?)?.userInfo[APIKeys.kMessage] ?? "Unknown Error Occured")
                    let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: kUserTypeVC) as! UserTypeVC
                    nxtObj.socialDict = fbData!
                    self.navigationController?.show(nxtObj, sender: self)
                }
                else {
                    self.showErrorMessage(error: error)
                }
            }
            else {
                self.appDelegate.registerForLocalNotification()
                self.loadSideMenu()

            }
        }
    }
}

//MARK: - Customization
extension LoginVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        outerViewCollection[0].layer.borderWidth = 1.0
        outerViewCollection[0].layer.borderColor = UIColor.lightGray.cgColor
        outerViewCollection[0].layer.cornerRadius = 5.0
        outerViewCollection[1].layer.borderWidth = 1.0
        outerViewCollection[1].layer.borderColor = UIColor.lightGray.cgColor
        outerViewCollection[1].layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
        facebookButtonOuterView.layer.cornerRadius = 5.0
        facebookImageOuterView.layer.cornerRadius = 5.0
    }
}

