//
//  PastBookingDetailsVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import FloatRatingView

class PastBookingDetailsVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK:- Varibles
    var index = 0
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        self.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    
    //MARK: Private Methods
    private func customiseUI(){
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
    }
    
    
    private func loadData(){
        self.profileImageView.sd_setImage(with:  BookingVM.shared.pastBookingRequestes[self.index].image ?? URL(string: ""), placeholderImage: #imageLiteral(resourceName: "User_02"), completed: nil)
         profileImageView.set(radius: profileImageView.half, borderColor: UIColor.LensColor.white.color(), borderWidth: 4.0)
        self.amountLabel.text = String(format: "$%.2f", BookingVM.shared.pastBookingRequestes[self.index].amount!)
        self.nameLabel.text = BookingVM.shared.pastBookingRequestes[self.index].name
        self.locationLabel.text = BookingVM.shared.pastBookingRequestes[self.index].location
        self.dateLabel.text = BookingVM.shared.pastBookingRequestes[self.index].date
        self.timeLabel.text = BookingVM.shared.pastBookingRequestes[self.index].time
        self.ratingView.rating = BookingVM.shared.pastBookingRequestes[self.index].rating ?? 0
        
        if   BookingVM.shared.pastBookingRequestes[self.index].paymentStatus == 2 {
             self.statusLabel.text  = "Payment Completed"
          
        }else  if BookingVM.shared.pastBookingRequestes[self.index].paymentStatus == 1  {
           self.statusLabel.text  = "Payment Pending"
          
        }else {
            self.statusLabel.text  = "Rejected"
           
        }
    }
}
