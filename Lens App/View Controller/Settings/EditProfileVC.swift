//
//  EditProfileVC.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class EditProfileVC: BaseVC {
    
    //MARK: IBOutlets
   
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet var outerViewCollection: [UIView]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
   
    //MARK: Variables
    var email = String()
    
    //MARK: Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        email = emailAddressTextField.text!
        self.hideNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
        self.customizeViews()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.white.withAlphaComponent(0.5), borderWidth: 1.0)
        editImageButton.set(radius: editImageButton.half)
        updateButton.set(radius: 5.0)
    }
    
    private func setupData() {
        if let userDetailDict = DataManager.userDetails {
            let userDetail = UserDetails(userDetails: userDetailDict)
            self.profileImageView.sd_setImage(with: URL(string : userDetail.image ?? ""), placeholderImage: #imageLiteral(resourceName: "User_01"), options: .refreshCached, completed: nil)
            nameTextField.text = userDetail.name
            emailAddressTextField.text = userDetail.email
        }
    }


    //MARK: IBActions
    @IBAction func editImageButtonAction(_ sender: UIButton) {
        CustomImagePickerView.sharedInstace.delegate = self
        self.showImagePicker()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.backButtonAction()
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
            return
        }
        if email != emailAddressTextField.text! {
            self.showAlert(title: kSuccess, message: kValidateEmail, {
                self.logout()
            })
        }
        else {
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kFullName] = self.nameTextField.text
            parameterDict[APIKeys.kEmail] = self.emailAddressTextField.text
            
            var imageDict = [String: Data]()
            imageDict[APIKeys.kImage] = profileImageView.image!.jpegData(compressionQuality: 0.5)
            self.updateUserProfile(parameterDict: parameterDict, image: imageDict)
            
        }
    }
}

//MARK: Validations
extension EditProfileVC {
    
    func validateData() -> String? {
        if !nameTextField.isValidName {
            return kNameValidation
        }
        if !emailAddressTextField.isValidEmail {
            return kEmailValidation
        }
        return nil
    }
}

//MARK: Image Picker Delegate
extension EditProfileVC: CustomImagePickerDelegate {
    
    func didImagePickerFinishPicking(_ image: UIImage) {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        profileImageView.image = image
    }
}

//MARK: TextField Delegates
extension EditProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.rangeOfCharacter(from: CharacterSet.symbols) != nil) {
            return false
        }
        let characterLength = textField.text!.utf16.count + (string.utf16).count - range.length
        if textField == nameTextField { //Name
            return (characterLength < 21)
        }
        return true
    }
}

//MARK: - API calls
extension EditProfileVC {
    
    func updateUserProfile(parameterDict: JSONDictionary, image: [String: Data]){
        SettingVM.shared.updateUserProfile(dict: parameterDict, imageDict: image) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
               // BaseVC.userDetails.image =
                self.showAlert(title:kSuccess, message: kProfileUpdateSuccess, {
                    self.backButtonAction()
                }, titleBottomsingleView: true)
            }
        }
    }
}

// MARK: - Customization
extension EditProfileVC{
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
