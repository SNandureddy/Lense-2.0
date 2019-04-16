//
//  ForgotPasswordVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailAddressOuterView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: Class Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customizeViews()
    }
    
    //MARK: IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
        }
        else {
            self.callAPItoForgotPassword()
        }
    }
}

//MARK: Validations
extension ForgotPasswordVC {
    
    func validateData() -> String? {
        if !emailTextField.isValidEmail {
            return kEmailValidation
        }
        return nil
    }
}

//MARK: TextField Delegates
extension ForgotPasswordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.rangeOfCharacter(from: CharacterSet.symbols) != nil) {
            return false
        }
        return true
    }
}

// MARK: - Customization
extension ForgotPasswordVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        emailAddressOuterView.layer.borderWidth = 1.0
        emailAddressOuterView.layer.borderColor = UIColor.lightGray.cgColor
        emailAddressOuterView.layer.cornerRadius = 5.0
        sendButton.layer.cornerRadius = 5.0
    }
}

//MARK: API Methods
extension ForgotPasswordVC {
    
    func callAPItoForgotPassword() {
        UserVM.shared.forgotPassword(email: emailTextField.text!) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.showAlert(title: kSuccess, message: kForgotEmailSent, {
                    self.backButtonAction()
                },titleBottomsingleView: true)
            }
        }
    }
}
