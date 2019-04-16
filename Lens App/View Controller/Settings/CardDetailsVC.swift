//
//  CardDetailsVC.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import SwiftLuhn

class CardDetailsVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var outerView: [UIView]!
    
    //MARK: Variables
    var screenType = kNew
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerTitle.text = screenType == kNew ? kAddCard: kUpdateCard
        saveButton.setTitle(screenType == kNew ? kSAVE: kUPDATE, for: .normal)
        self.setExpirationDate()
        self.hideNavigationBar()
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customizeViews()
    }
    
    private func setExpirationDate() {
        let datePicker = MonthYearPickerView()
        expirationTextField.inputView = datePicker
        datePicker.onDateSelected = {(month: Int, year: Int) in
            let string = String(format: "%02d/ %d", month, year)
            self.expirationTextField.text = string
        }
    }
    

    //MARK: IBActions
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
        }
        else {
            self.getCardToken()
        }
    }
    
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        
        self.logout()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.backButtonAction()
    }
}

//MARK: Validations
extension CardDetailsVC {
    
    func validateData() -> String? {
        if !cardNumberTextField.isValidCardNumber || !cardNumberTextField.text!.isValidCardNumber() {
           return kCardValidation
        }
        if !cvvTextField.isValidCVV {
            return kCVVValidation
        }
        if expirationTextField.isEmpty {
            return kCardDateValidation
        }
        return nil
    }
}

//MARK: TextField Delegates
extension CardDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterLength = textField.text!.utf16.count + (string.utf16).count - range.length
        if textField == cardNumberTextField {
            if (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                return false
            }
            return (characterLength < 20)
        }
        if textField == cvvTextField {
            if (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                return false
            }
            return (characterLength < 5)
        }
         return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == expirationTextField {
            let year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
            let string = String(format: "%02d/ %d", currentMonth, year)
            self.expirationTextField.text = string
        }
    }
}

//MARK: API Methods
extension CardDetailsVC {
    
    func getCardToken() {
        let expirationArray = self.expirationTextField.text!.split(separator: "/")
        var month = Int()
        var year = Int()
        if expirationArray.count >= 2 {
            month = Int(expirationArray.first!.trimmingCharacters(in: .whitespacesAndNewlines))!
            year = Int(expirationArray.last!.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
        StripeManager.shared.saveCard(cardNumber: self.cardNumberTextField.text!, expMonth: month, expYear: year, cvv: self.cvvTextField.text!) { (response, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.callAPIToSaveCard(dict: response!)
            }
        }
    }
    
    func callAPIToSaveCard(dict: JSONDictionary) {
        PaymentVM.shared.addCard(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                DataManager.isCardAdded = true
                self.showAlert(title: kSuccess, message: self.screenType == kNew ? kCardAddedAuccess: kCardUpdateSuccess, {
                    if self.screenType == kNew {
                        self.loadSideMenu()
                    }
                    else {
                        self.backButtonAction()
                    }
                },titleBottomsingleView: true)
            }
        }
    }
}

// MARK: - Customization
extension CardDetailsVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        for outerViews in outerView{
            outerViews.set(radius: 5.0, borderColor: UIColor.LensColor.lightGray.color().withAlphaComponent(0.5),borderWidth: 1.0)
        }
        outerView[2].layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
    }
}
