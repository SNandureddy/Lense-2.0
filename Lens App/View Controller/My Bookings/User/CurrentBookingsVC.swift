//
//  CurrentBookingsVC.swift
//  Lense App
//
//  Created by ios on 23/10/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

protocol superClassDelegate {
    func CallSuperClassMethod()
}

class CurrentBookingsVC: BaseVC {
 
    // MARK: - IBOutlet
    @IBOutlet weak var currentBookingTableView: UITableView!
   
    // MARK: - Variables
    var superClass:superClassDelegate!
    private lazy var bookingDetailVC: BookingDetailsVC = {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: kBookingDetailsVC) as! BookingDetailsVC
        
        return vc
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    func loadCurrentData(){
        self.currentBookingTableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CurrentBookingsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingVM.shared.userCurrentBookingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "CurrentBookingCell") as! CurrentBookingCell
        let dict = BookingVM.shared.userCurrentBookingArray[indexPath.row]
        myCell.bookingDateLabel.text = dict.date   //BookingVM.shared.userCurrentBooking.date
        myCell.amountLabel.text = ("$\(dict.packageAmount ?? "0").00")
//        "$\(dict.packageAmount?.rounded(toPlaces: 2) ?? "0.0")"
        if dict.status == "1"{
            myCell.cancelButton.tag = indexPath.row
            myCell.cancelButton.addTarget(self, action: #selector(cancelBookingAction), for: .touchUpInside)
            myCell.cancelButton.set(radius: 5.0)
        }else{
            myCell.cancelButtonHeightConstraint.constant = 0
        }
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = BookingVM.shared.userCurrentBookingArray[indexPath.row]
        if dict.status != "1"{
            let storyboard = UIStoryboard.init(storyboard: .MyBookings)
            let vc = storyboard.instantiateViewController(withIdentifier: kBookingDetailsVC)as! BookingDetailsVC
            vc.currentDetails = BookingVM.shared.userCurrentBookingArray[indexPath.row]
            vc.screenType = kCurrent
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
    @objc func cancelBookingAction(sender:UIButton)  {
        self.showAlert(title: kAlert, message: kCancelBookingSure, cancelTitle: kNo, cancelAction: nil, okayTitle: kYes, {
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kBookingId] = BookingVM.shared.userCurrentBookingArray[sender.tag].id
            self.cancelBooking(parameterDict: parameterDict)
        }, rateAction: nil, isRating: false)
    }
}

//MARK : - API calls
extension CurrentBookingsVC {
    
    func cancelBooking(parameterDict: JSONDictionary ){
        BookingVM.shared.cancelBooking(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                    self.superClass.CallSuperClassMethod()
            }
        }
    }
}

