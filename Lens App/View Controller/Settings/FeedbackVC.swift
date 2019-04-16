//
//  FeedbackVC.swift
//  Lense App
//
//  Created by Apple on 30/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class FeedbackVC: BaseVC {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var feedBackTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customiseUI()
        self.customizeViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupUI()
    }

    //MARK: Private Methods
    private func customiseUI() {
        feedBackTextView.text = kFeedbackPlaceholder
        feedBackTextView.textColor = UIColor.lightGray
        feedBackTextView.delegate = self
    }
    
    private func setupUI() {
        feedBackTextView.set(radius: 12.0, borderColor: UIColor.lightGray.withAlphaComponent(0.7), borderWidth: 1.0)
        feedBackTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = validateData() {
            self.showAlert(message: message)
            return
        }
        
        var jsondict = JSONDictionary()
        jsondict[APIKeys.kUserId] = DataManager.userId
        jsondict[APIKeys.kMessage] = self.feedBackTextView.text!
        self.callApiForSendFeedback(parameterDict: jsondict)
    }
    
    @IBAction func menuBarButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
}

//MARK: Validations
extension FeedbackVC {
    
    func validateData() -> String? {
        if feedBackTextView.text.count < 4 || feedBackTextView.text == kFeedbackPlaceholder {
            return kFeedbackValidation
        }
        return nil
    }
}


extension FeedbackVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == kFeedbackPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == kFeedbackPlaceholder {
            textView.text = kFeedbackPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

//MARK: - API calls
extension FeedbackVC {
    
    func callApiForSendFeedback(parameterDict: JSONDictionary){
        NotificationVM.shared.sendFeedBack(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.showAlert(message: kFeedbackSuccess, {
                    self.feedBackTextView.text = kFeedbackPlaceholder
                    self.feedBackTextView.textColor = UIColor.lightGray
                    self.feedBackTextView.resignFirstResponder()
                })
            }
        }
    }
    
}

// MARK: - Customization
extension FeedbackVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        sendButton.layer.cornerRadius = 5.0
        
    }
}
