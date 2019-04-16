//
//  ChangePasswordVC.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet var outerViewCollection: [UIView]!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customizeViews()
    }
    
    //MARK: IBActions
    @IBAction func updateButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
        }
        else {
            //call api
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kOldPassword] = oldPasswordTextField.text
            parameterDict[APIKeys.kNewPassword] = newPasswordTextField.text
            self.chgangePassword(parameterDict: parameterDict)
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.backButtonAction()
    }
}

//MARK: Validations
extension ChangePasswordVC {
    
    func validateData() -> String? {
        if !oldPasswordTextField.isValidPassword {
            return kPasswordValidation
        }
        if !newPasswordTextField.isValidPassword {
            return kNewPasswordValidation
        }
        if newPasswordTextField.text! != confirmPasswordTextField.text! {
            return kConfirmPasswordValidation
        }
        return nil
    }
}

//MARK: - API calls
extension ChangePasswordVC {
    
    func chgangePassword(parameterDict: JSONDictionary){
        
        SettingVM.shared.changePassword(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                  //
                self.showAlert(title: kSuccess, message: kChangePasswordSuccess, {
                    self.logout()
                }, titleBottomsingleView: true)
            }
        }
    }
}

// MARK: - Customization
extension ChangePasswordVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        for outerViews in outerViewCollection{
            outerViews.set(radius: 5.0, borderColor: UIColor.LensColor.lightGray.color().withAlphaComponent(0.5),borderWidth: 1.0)
        }
        updateButton.layer.cornerRadius = 5.0
        
    }
}
