//
//  UploadImagesVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class UploadImagesVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadButton: UIButton!
    
    //MARK: Variables
    var index = 0
    var imageDict = [Int: UIImage]()
   // var myImageArray =  [UIImage]()
    var myPickerTag : Int!
    var imageCount = 0

    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if BookingVM.shared.currentBookingRequestes[self.index].packId == 3{
            imageCount = 7
        }else if BookingVM.shared.currentBookingRequestes[self.index].packId == 2{
            imageCount = 5
        }else{
            imageCount = 2
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        uploadButton.set(radius: 5.0)
    }
    
    //MARK: IBActions
    @IBAction func addImageButtonAction(_ sender: UIButton) {
//        imageNumber = sender.tag
        CustomImagePickerView.sharedInstace.delegate = self
        self.openGallery()
    }
   
    @IBAction func uploadImageButtonAction(_ sender: Any) {
        if let message = self.validateData() {
            self.showAlert(message: message)
        }
   
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingId] = BookingVM.shared.currentBookingRequestes[self.index].id
        self.uploadImages(jsonData:parameterDict , imageData: self.createImageDict())
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    
    func createImageDict()->[String:Data]{
        var imageDict = [String:Data]()
        let values = Array(self.imageDict.values)
        for i in 0..<values.count{
            imageDict["image_\(i+1)"] = values[i].jpegData(compressionQuality: 1.0)
        }
        return imageDict
    }
    
    
    func rateUser() {
        self.showAlert(title: kRateUser, message: nil, cancelTitle: kCancel, cancelAction: {
            self.dismiss(animated: true, completion: nil)
            self.navigationController!.popViewController(animated: true)
            
        }, okayTitle: kDone, nil, rateAction: { (rating, review) in
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kBookingId] = BookingVM.shared.currentBookingRequestes[self.index].id
            parameterDict[APIKeys.kRating] = rating
            parameterDict[APIKeys.kReview] = review == kReviewPlaceholder ? "": review
            self.callApiForRateUser(parameterDict: parameterDict)
        }, isRating: true)
    }
}

//MARK:- Validations
extension UploadImagesVC {
    
    func validateData() -> String? {
        if self.imageDict.count < imageCount {
            return kAddImageValidation
        }
        return nil
    }
}

//MARK:- Image Picker Delegate
extension UploadImagesVC: CustomImagePickerDelegate {
    func didImagePickerFinishPicking(_ image: UIImage) {
        imageDict[self.myPickerTag] = image
        self.tableView.reloadData()
    }
}

//MARK:- API Calls
extension UploadImagesVC {
    
    func uploadImages(jsonData: JSONDictionary, imageData: [String: Data]) {
        BookingVM.shared.uploadImages(dict: jsonData, imageData: imageData) { (message, error) in
            if error != nil {
                super.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess,message: kImageUploadSuccess, {
                    self.rateUser()
                })
            }
        }
    }
    
    func callApiForRateUser(parameterDict: JSONDictionary){
        BookingVM.shared.addBookingReview(dict: parameterDict) { (message, error) in
            if error != nil {
                super.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess, message: kRatingSuccess, {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PhotographerBookingsVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            return
                        }
                    }
                })
            }
        }
    }
}

extension UploadImagesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: kuploadImageCell) as! uploadImageCell
        if let image = imageDict[indexPath.row] {
            myCell.imageViewObject.contentMode = .scaleAspectFill
            myCell.imageViewObject.image = image
        }
        else {
            myCell.imageViewObject.contentMode = .center
            myCell.imageViewObject.image = nil
        }
        myCell.uploadButtonObject.tag = indexPath.row
        myCell.imageContainer.set(radius: 5.0, borderColor: UIColor.LensColor.pinkcolor.color(), borderWidth: 1.0)
        myCell.uploadButtonObject.addTarget(self, action: #selector(uplaodImage), for: .touchUpInside)
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
   @objc func uplaodImage(sender:UIButton) {
        CustomImagePickerView.sharedInstace.delegate = self
        self.myPickerTag = sender.tag
        self.openGallery()
    }
}
