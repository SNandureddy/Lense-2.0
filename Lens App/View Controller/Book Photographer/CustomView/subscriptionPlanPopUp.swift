//
//  subscriptionPlanPopUp.swift
//  Lense App
//
//  Created by ios on 16/11/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class subscriptionPlanPopUp: UIView {
    @IBOutlet weak var popUpContainer: UIView!
    @IBOutlet weak var plan1DescriptionLabel: UILabel!
    @IBOutlet weak var plan2DescriptionLabel: UILabel!
    @IBOutlet weak var plan1OkButton: UIButton!
    @IBOutlet weak var plan2OkButton: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func initiatePopUp(pack1Amount:String?="200", pack2Amount:String?="500") {
        self.popUpContainer.set(radius: 16)
        self.plan1OkButton.set(radius: self.plan1OkButton.half)
        self.plan1OkButton.setTitle("$\(pack1Amount!)", for: .normal)
        self.plan2OkButton.set(radius: self.plan2OkButton.half)
        self.plan2OkButton.setTitle("$\(pack2Amount!)", for: .normal)
        self.plan1DescriptionLabel.text = "$\(pack1Amount!) \(mySubScriptionPopUpText)"
        self.plan2DescriptionLabel.text = "$\(pack2Amount!) \(mySubScription2PopUpText)"
        
    }
    
    @IBAction func plan1OkAction(_ sender: Any) {
//        self.removeFromSuperview()
        self.callAPIToAddPackage(id: 2)
        
    }
    
    @IBAction func plan2OkAction(_ sender: Any) {
        //        self.removeFromSuperview()
        //DataManager.packageId = 3
        self.callAPIToAddPackage(id: 3)
    }
    
    
    

}



//MARK: API Methods
extension subscriptionPlanPopUp {
    
    
    func callAPIToAddPackage(id: Int) {
        BookingVM.shared.addPackage(id: id){ (message, error) in
            if error != nil {
                baseVc.showErrorMessage(error: error!)
            }else {
                //success
            }
        }
    }
}
