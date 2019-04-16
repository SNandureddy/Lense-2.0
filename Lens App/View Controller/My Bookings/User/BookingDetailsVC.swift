//
//  BookingDetailsVC.swift
//  Lens App
//
//  Created by Apple on 31/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import FloatRatingView

class BookingDetailsVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var lastDescriptionLabel: UILabel!
    @IBOutlet weak var lastTitleLabel: UILabel!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notextTextView: UITextView!
    @IBOutlet weak var addNotesButton: UIButton!
    @IBOutlet weak var noteViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    var screenType = kCurrent
    var pastDetails: UserPastBookingDetails!
    var currentDetails: UserCurrentBookingDetails!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func setupView() {
        if screenType == kCurrent {
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kBookingType] = 1
            self.loadCurrentData()
        } else {
            //self.set(title: kBookingDetails)
            noteViewHeightConstraint.constant = 0.0
            lastTitleLabel.text = "Amount Paid"
            self.profileImageView.sd_setImage(with:  pastDetails.photographerImageUrl
                ?? URL(string: ""), placeholderImage: #imageLiteral(resourceName: "User_01"), completed: nil)
            self.nameLabel.text = pastDetails.photographerName ?? ""
            self.ratingView.rating = pastDetails.photohgrapherRating  ?? 3
            self.dateLabel.text = pastDetails.date
            self.timeLabel.text = pastDetails.time
            self.imageCountLabel.text = String(pastDetails.bookingImages.count)
            self.lastDescriptionLabel.text = pastDetails.amountPaid
            hideTextView()
        }
    }
    
    private func customiseUI() {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        addNotesButton.set(radius: 5.0)
    }
    
     func loadCurrentData(){
        if  currentDetails == nil {
            super.showEmptyScreen()
            return
        }
        super.hideEmptyScreen()
        lastTitleLabel.text = "Phone Number"
        notextTextView.textColor = UIColor.LensColor.lightBlack.color()
        addNotesButton.isHidden = false
        self.profileImageView.sd_setImage(with: currentDetails.photographerImageUrl, placeholderImage: #imageLiteral(resourceName: "User_01"), completed: nil)
        
        self.lastDescriptionLabel.text = currentDetails.photohgrapherPhoneNumber ?? ""
        self.nameLabel.text = currentDetails.photographerName
        self.ratingView.rating = currentDetails.photohgrapherRating ?? 0
        self.dateLabel.text = currentDetails.date
        self.timeLabel.text = currentDetails.time
        self.imageCountLabel.text = "\(currentDetails.imageCount ?? 0)"
        if currentDetails.notes != "" {
            self.hideTextView()
        } else {
            notextTextView.set(radius: 12.0, borderColor: UIColor.lightGray.withAlphaComponent(0.7), borderWidth: 1.0)
            self.notextTextView.textColor = UIColor.lightGray
            self.notextTextView.text = kNotesPlaceholder
            self.notextTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func hideTextView(){
      
            self.notextTextView.set(radius: 0.0)
            self.notextTextView.isUserInteractionEnabled = false
            self.addNotesButton.isHidden = true
            self.notextTextView.text = currentDetails?.notes
            self.notextTextView.textColor = UIColor.lightGray
            self.notextTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)

    }
    
    //MARK: IBActions
    @IBAction func addNotesButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let message = self.validateData() {
            self.showAlert(message: message)
        }
        else {
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kBookingId] = currentDetails.id
            parameterDict[APIKeys.kNote] = self.notextTextView.text
            self.addBookingNote(parameterDict: parameterDict)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
}

//MARK: Validations
extension BookingDetailsVC {
     
    func validateData() -> String? {
        if notextTextView.text.count < 4 || notextTextView.text == kNotesPlaceholder {
            return kNotesValidation
        }
        return nil
    }
}

//MARK: TextView Delegates
extension BookingDetailsVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == kNotesPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == kNotesPlaceholder {
            textView.text = kNotesPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

//MARK : - API calls
extension BookingDetailsVC {
    
    func loadCurrentBookingData(parameterDict: JSONDictionary ){
        BookingVM.shared.myBookings(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.loadCurrentData()
            }
        }
    }
    
    func addBookingNote(parameterDict: JSONDictionary ){
        BookingVM.shared.addBookingNote(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess,message: kNotesSuccess, {
                    self.currentDetails.notes = self.notextTextView.text
                    self.hideTextView()
                })
            }
        }
    }
}

