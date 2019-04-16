//
//  ViewImageVC.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class ViewImageVC: BaseVC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Variables
    var image = #imageLiteral(resourceName: "dummyImage1")
    var index = 0
    var listIndex = 0
    static var bookingId = 0
    var showRating: Bool!
    
    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.image
    }
    
    //MARK: - IBActions
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingId] = BookingVM.shared.userBookingImages[self.listIndex].id
        parameterDict[APIKeys.kImageId] = BookingVM.shared.userBookingImages[self.listIndex].bookingImages[self.index].id
        callApiAfterDownload(parameterDict: parameterDict)
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Save Image
extension ViewImageVC {
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.showErrorMessage(error: error)
        } else {
            self.showAlert(title:kSuccess, message: kImageDownloadSuccess, {
                if self.showRating {
                     BookingVM.shared.userBookingImages[self.listIndex].downloadStatus[self.index] = 2
                    self.ratePhotographer()
                }
                else {
                    BookingVM.shared.userBookingImages[self.listIndex].downloadStatus[self.index] = 2
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    //Rate Photographer
    func ratePhotographer() {
        self.showAlert(title: kRatePhotographer, message: nil, cancelTitle: kCancel, cancelAction: {
            self.dismiss(animated: true, completion: nil)
        },okayTitle: kDone, rateAction: { (rating, review) in
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kBookingId] = ViewImageVC.bookingId//BookingVM.shared.userBookingImages[self.listIndex].id
            parameterDict[APIKeys.kRating] = rating
            parameterDict[APIKeys.kReview] = review == kReviewPlaceholder ? "": review
            self.callApiForRatePhotographer(parameterDict: parameterDict)
        }, isRating: true, titleBottomsingleView: true)
    }
}

//MARK: APICalls
extension ViewImageVC {
    func callApiForRatePhotographer(parameterDict: JSONDictionary){
        BookingVM.shared.addBookingReview(dict: parameterDict) { (message, error) in
            if error != nil {
                super.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess, message: kRatingSuccess, {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func callApiAfterDownload(parameterDict: JSONDictionary){
        BookingVM.shared.callApiAfterDownload(dict: parameterDict) { (message, error) in
            if error != nil {
                super.showErrorMessage(error: error)
            }else {
                UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
}
