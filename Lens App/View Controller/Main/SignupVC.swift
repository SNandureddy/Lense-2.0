//
//  SignupVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage


class SignupVC: BaseVC {

    //MARK: IBOUtlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var descriptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var termsView: UIStackView!
    @IBOutlet var outerView: [UIView]!
    
    //MARK: Variables
    var imageDict = [String: Data]()
    var socialDict = JSONDictionary()
    var userType = kUser
    
    //MARK: Class Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeViews()
        self.hideNavigationBar()
        self.setupData()
        self.getCurrentLocation(success: {_ in })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func customiseUI() {

        for textField in textFieldCollection {
            textField.delegate = self
        }
        profileImageView.set(radius: profileImageView.half,borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        addImageButton.set(radius: addImageButton.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)

        if userType == kUser || userType == kBusinessUser{
            descriptionView.isHidden = true
            descriptionViewHeightConstraint.constant = 0
        }
        else {
            descriptionTextView.delegate = self
            descriptionTextView.set(radius: 5.0)
            descriptionTextView.layer.borderWidth = 1.0
            descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
            signupButton.setTitle(kNext, for: .normal)
        }
    }

    private func setupUI() {
        descriptionTextView.text = kDescriptionPlaceholder
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private func setupData() {
        if socialDict.count > 0 {
            textFieldCollection[0].text = socialDict[APIKeys.kFullName] as? String
            textFieldCollection[1].text = socialDict[APIKeys.kEmail] as? String
            textFieldCollection[1].isUserInteractionEnabled = socialDict[APIKeys.kEmail] as? String == nil
            profileImageView.sd_setImage(with: socialDict[APIKeys.kImage] as? URL, placeholderImage: #imageLiteral(resourceName: "editProfileSignUp"), options: .refreshCached, completed: nil)
            passwordView.isHidden = true
            confirmPasswordView.isHidden = true
        }
    }
    
    //MARK: IBActions
    @IBAction func addImageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        CustomImagePickerView.sharedInstace.delegate = self
        self.showImagePicker()
    }
    
    @IBAction func checkTermButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
        

    @IBAction func signUpButtonAction(_ sender: Any) {
        self.view.endEditing(true)
    if let message = self.validateData() {
            self.showAlert(message: message)
        }
        else {
            switch userType{
            case kUser,kBusinessUser:
                self.callAPIToSignup()
            default:
                self.callAPIToValidateEmail()
            }
        }
    }
    
    @IBAction func termConditionButtonAction(_ sender: UIButton) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
        self.navigationController?.pushViewController(nav, animated: true
        )
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.backButtonAction()
    }
}

// MARK: Validations
extension SignupVC {

    func validateData() -> String? {
        if !textFieldCollection[0].isValidName {
            return kNameValidation
        }
        if !textFieldCollection[1].isValidEmail {
            return kEmailValidation
        }
        if !textFieldCollection[2].isValidPhone {
            if textFieldCollection[2].count > 0 {
                return kPhoneValidation
            }
        }
        if !textFieldCollection[3].isValidPassword && socialDict.count == 0 {
            return kPasswordValidation
        }
        if textFieldCollection[4].text! != textFieldCollection[3].text! && socialDict.count == 0 {
            return kConfirmPasswordValidation
        }
        if (descriptionTextView.text.count < 4 || descriptionTextView.text == kDescriptionPlaceholder) && userType == kPhotographer {
            return kDescriptionValidation
        }
        if !checkButton.isSelected {
            return kTermsValidation
        }
        return nil
    }

    func addData() -> JSONDictionary? {
        BaseVC.userDetails.name = textFieldCollection[0].text!
        BaseVC.userDetails.email = textFieldCollection[1].text!
        if textFieldCollection[2].count > 0 {
            BaseVC.userDetails.phoneNumber = textFieldCollection[2].text!
        }
        if socialDict.count == 0 {
            BaseVC.userDetails.password = textFieldCollection[3].text!
        }
        if descriptionTextView.text != kDescriptionPlaceholder {
            BaseVC.userDetails.description = descriptionTextView.text
        }
        BaseVC.userDetails.userType = userType
        if currentLocation == nil {
            self.showAlert(message: kLocationMessage, {
                self.openSettings()
            })
            return nil
        }
        var dict = BaseVC.userDetails.jsonDict
        dict[APIKeys.kLatitude] = self.currentLocation.latitude
        dict[APIKeys.kLongitude] = self.currentLocation.longitude
        dict[APIKeys.kLocation] =  self.address
        dict[APIKeys.kLoginType] = self.socialDict.count > 0 ? 2: 1
        if socialDict.count > 0 {
            dict[APIKeys.kSocialId] = socialDict[APIKeys.kSocialId] as? String ?? ""
            if imageDict.count == 0 {
                dict[APIKeys.kImage] = (socialDict[APIKeys.kImage] as? URL)?.absoluteString ?? ""
            }
        }
        return dict
    }
}

//MARK: Image Picker Delegate
extension SignupVC: CustomImagePickerDelegate {
    func didImagePickerFinishPicking(_ image: UIImage) {
        profileImageView.image = image
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        imageDict[APIKeys.kImage] = image.imageData
    }
}

//MARK: TextField Delegates
extension SignupVC: UITextFieldDelegate {

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
            if (string.rangeOfCharacter(from: kAlphaNumericSet.inverted) != nil) {
                return false
            }
            return (characterLength < 21)
        }
        return true
    }
}

//MARK: TextView Delegates
extension SignupVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == kDescriptionPlaceholder {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == kDescriptionPlaceholder {
            descriptionTextView.text = kDescriptionPlaceholder
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
}

//MARK: API Methods
extension SignupVC {

    func callAPIToSignup() {
        if let dict = self.addData() {
            UserVM.shared.signup(dict: dict, imageDict: imageDict) { (_, error) in
                if error != nil {
                    self.showErrorMessage(error: error!)
                }
                else {
                    self.showAlert(title: kSuccess, message: kSocialSignupSuccess, {
                        self.loadSideMenu()
                    },titleBottomsingleView: true)
                }
            }
        }
    }

    func callAPIToValidateEmail() {
        var dict = JSONDictionary()
        dict[APIKeys.kEmail] = textFieldCollection[1].text!
        if textFieldCollection[2].count > 0 {
            dict[APIKeys.kPhoneNumber] = textFieldCollection[2].text!
        }

        UserVM.shared.validateEmail(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                _ = self.addData()
                let settings = UIStoryboard(storyboard: .Settings)
                let distancevc = settings.instantiateViewController(withIdentifier: kDistanceVC) as! DistanceVC
                distancevc.screenType = kNew
                distancevc.imageDict = self.imageDict
                distancevc.socialDict = self.socialDict
                self.navigationController?.show(distancevc, sender: self)
            }
        }
    }
}

// MARK: - Customization
extension SignupVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        for outerViews in outerView{
           outerViews.set(radius: 5.0, borderColor: UIColor.LensColor.lightGray.color().withAlphaComponent(0.5),borderWidth: 1.0)
        }
        signupButton.layer.cornerRadius = 5.0
        checkButton.layer.borderWidth = 1.0
        checkButton.layer.borderColor = UIColor.lightGray.cgColor
    }
}
