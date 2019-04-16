//
//  PhotographerEditProfileVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class PhotographerEditProfileVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var outerViewCollection: [UIView]!
    @IBOutlet weak var descrriptionTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    //MARK: Variables
    var email = String()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpdata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.lightGray.withAlphaComponent(0.5), borderWidth: 1.0)
        updateButton.set(radius: 5.0)
        for outerView in outerViewCollection {
            outerView.set(radius: 5.0, borderColor: UIColor.lightGray.withAlphaComponent(0.5), borderWidth: 1.0)
        }
        descrriptionTextView.set(radius: 5.0, borderColor: UIColor.lightGray.withAlphaComponent(0.5), borderWidth: 1.0)
        descrriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        shadowView.layer.cornerRadius = 5.0
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
    }
    
    private func setUpdata(){
        if let userDetailDict = DataManager.userDetails {
            let userDetail = UserDetails(userDetails: userDetailDict)
            self.profileImageView.sd_setImage(with: URL(string : userDetail.image ?? ""), placeholderImage: #imageLiteral(resourceName: "User_02"), options: .refreshCached, completed: nil)
            self.textFieldCollection[0].text = userDetail.name
            self.textFieldCollection[1].text = userDetail.email
            self.textFieldCollection[2].text = userDetail.phoneNumber
            self.descrriptionTextView.text = userDetail.description
        }
        
    }
    
    //MARK: IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    @IBAction func editImageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        CustomImagePickerView.sharedInstace.delegate = self
        self.showImagePicker()
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
            return
        }

        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kFullName] = self.textFieldCollection[0].text
        parameterDict[APIKeys.kEmail] = self.textFieldCollection[1].text
        parameterDict[APIKeys.kPhoneNumber] = self.textFieldCollection[2].text
        parameterDict[APIKeys.kDescription] = self.descrriptionTextView.text
        var imageDict = [String: Data]()
        imageDict[APIKeys.kImage] = profileImageView.image!.jpegData(compressionQuality: 0.5)
        self.callApiForUpdateProfile(parameterDict: parameterDict, image: imageDict)
    }
}

//MARK: Validations
extension PhotographerEditProfileVC {
    
    func validateData() -> String? {
        if !textFieldCollection[0].isValidName {
            return kNameValidation
        }
        if !textFieldCollection[1].isValidEmail {
            return kEmailValidation
        }
//        if !textFieldCollection[2].isValidPhone {
//            return kPhoneValidation
//        }
        if descrriptionTextView.text.count < 4 || descrriptionTextView.text == kDescriptionPlaceholder {
            return kDescriptionValidation
        }
        return nil
    }
}

//MARK: TextField Delegates
extension PhotographerEditProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string.rangeOfCharacter(from: CharacterSet.symbols) != nil) {
            return false
        }
        let characterLength = textField.text!.utf16.count + (string.utf16).count - range.length
        if textField == textFieldCollection[2] { //Phone number
            if (string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil) {
                return false
            }
            return (characterLength < 16)
        }
        if textField == textFieldCollection[0] { //Name
            return (characterLength < 21)
        }
        return true
    }
}

//MARK: TextView Delegates
extension PhotographerEditProfileVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == kDescriptionPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == kDescriptionPlaceholder {
            textView.text = kDescriptionPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

//MARK: Image Picker Delegate
extension PhotographerEditProfileVC: CustomImagePickerDelegate {
    
    func didImagePickerFinishPicking(_ image: UIImage) {
        profileImageView.image = image
    }
}

//MARK: - API calls
//÷fgdfgdf
extension PhotographerEditProfileVC {
    
    func callApiForUpdateProfile(parameterDict: JSONDictionary, image: [String: Data]){
        SettingVM.shared.updateUserProfile(dict: parameterDict, imageDict: image) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess, message: kProfileUpdateSuccess, {
                    self.backButtonAction()
                })
                BaseVC.userDetails.name = self.textFieldCollection[0].text
                BaseVC.userDetails.email = self.textFieldCollection[1].text
                BaseVC.userDetails.phoneNumber = self.textFieldCollection[2].text
                BaseVC.userDetails.description = self.descrriptionTextView.text
            }
        }
    }
    
}
