//
//  CurrentBookingDetailsVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import MapKit
import FloatRatingView

class CurrentBookingDetailsVC: BaseVC {
    
    //MARK:- Variables
    var index = 0
   
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var notesLabel: UITextView!
    @IBOutlet weak var manageImageButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var notesContainerView: UIView!
    @IBOutlet weak var notesDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionouterView: UIView!
    @IBOutlet weak var navigateLabelText: UILabel!
    @IBOutlet weak var navigateButtonOuterView: UIView!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
        self.loadData()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        navigateButtonOuterView.set(radius: 5.0, borderColor: UIColor.LensColor.pinkcolor.color(), borderWidth: 1.0)
        navigateButton.set(radius: 5.0, borderColor: UIColor.LensColor.pinkcolor.color(), borderWidth: 1.0)
        descriptionouterView.set(radius: 5.0, borderColor: UIColor.LensColor.lightGray.color(), borderWidth: 1.0)
        manageImageButton.set(radius: 5.0, borderColor: UIColor.LensColor.pinkcolor.color(), borderWidth: 1.0)

    }
    
    private func loadData(){
        self.profileImageView.sd_setImage(with: BookingVM.shared.currentBookingRequestes[self.index].image, placeholderImage: #imageLiteral(resourceName: "User_02"), completed: nil)
        self.nameLabel.text = BookingVM.shared.currentBookingRequestes[self.index].name ?? ""
        self.locationLabel.text = BookingVM.shared.currentBookingRequestes[self.index].location ?? ""
        self.dateLabel.text = BookingVM.shared.currentBookingRequestes[self.index].date ?? ""
        self.timeLabel.text = BookingVM.shared.currentBookingRequestes[self.index].time ?? ""
        self.ratingView.rating = BookingVM.shared.currentBookingRequestes[self.index].userRating ?? 0
        self.phoneNumberLabel.text = BookingVM.shared.currentBookingRequestes[self.index].phoneNumber ?? ""
        self.notesDescriptionLabel.text = BookingVM.shared.currentBookingRequestes[self.index].notes ?? "some default notes"
        if BookingVM.shared.currentBookingRequestes[self.index].bookingImages.count != 0 {
            self.manageImageButton.setTitle("IMAGES UPLOADED", for: .normal)
            self.manageImageButton.backgroundColor = UIColor.LensColor.pinkcolor.color()
            self.manageImageButton.setTitleColor(UIColor.LensColor.white.color(), for: .normal)
            self.navigateButtonOuterView.backgroundColor = UIColor.clear
//            self.navigateButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: .normal)
            self.navigateLabelText.textColor = UIColor.LensColor.pinkcolor.color()
            self.manageImageButton.isUserInteractionEnabled = false
            self.manageImageButton.isEnabled = false
        }else {
            self.manageImageButton.setTitle("MANAGE IMAGES", for: .normal)
            self.manageImageButton.isUserInteractionEnabled = true
            self.manageImageButton.isEnabled = true
            self.manageImageButton.backgroundColor = UIColor.clear
            self.manageImageButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: .normal)
            self.navigateButtonOuterView.backgroundColor = UIColor.LensColor.pinkcolor.color()
            self.navigateLabelText.textColor = UIColor.LensColor.white.color()
//            self.navigateButton.backgroundColor = UIColor.LensColor.pinkcolor.color()
//            self.navigateButton.setTitleColor(UIColor.LensColor.white.color(), for: .normal)
            
        }
    }

    //MARK: IBActions
    @IBAction func manageImagesButtonAction(_ sender: UIButton) {
        let managaevc = self.storyboard?.instantiateViewController(withIdentifier: kUploadImagesVC) as! UploadImagesVC
        managaevc.index = self.index
        self.navigationController?.show(managaevc, sender: self)
    }
    
    @IBAction func navigateButtonAction(_ sender: UIButton) {
        let managaevc = self.storyboard?.instantiateViewController(withIdentifier: kDirectionsVC) as! DirectionsVC
        let userLocation = CLLocationCoordinate2D(latitude: BookingVM.shared.currentBookingRequestes[self.index].latitude, longitude: BookingVM.shared.currentBookingRequestes[self.index].longitude)
        managaevc.destinationLocation = userLocation
        self.navigationController?.show(managaevc, sender: self)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    
}
