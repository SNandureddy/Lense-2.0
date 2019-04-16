//
//  PastBookingVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class PastBookingVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingType] = 2
        callApiToGetBookingDetails(parameterDict: parameterDict)
        
    }
    
    // MARK: - IBAction
    @IBAction func menuButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
}

//MARK: Tableview Datasource
extension PastBookingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  BookingVM.shared.pastBookingRequestes.count == 0 {
            super.showEmptyScreen(superView: tableView)
        }else {
            super.hideEmptyScreen()
        }
        return BookingVM.shared.pastBookingRequestes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPastBookingCell) as! PastBookingCell
        if   BookingVM.shared.pastBookingRequestes[indexPath.row].paymentStatus == 2 {
            cell.statusLabel.text = "Payment Completed"
            cell.statusLabel.textColor = UIColor.LensColor.greenColor.color()
//            cell.statusIcon.image = #imageLiteral(resourceName: "completeIcon")
        }else  if BookingVM.shared.pastBookingRequestes[indexPath.row].paymentStatus == 1  {
            cell.statusLabel.text = "Payment Pending"
            cell.statusLabel.textColor = UIColor.LensColor.redColor.color()
//            cell.statusIcon.image = #imageLiteral(resourceName: "pendingIcon")
        }else {
            cell.statusLabel.text = "Rejected"
            cell.statusLabel.textColor = UIColor.LensColor.redColor.color()
        }
        cell.nameLabel.text =  BookingVM.shared.pastBookingRequestes[indexPath.row].name
        cell.profileImageView.sd_setImage(with: BookingVM.shared.pastBookingRequestes[indexPath.row].image ?? URL(string: ""), placeholderImage: #imageLiteral(resourceName: "editProfileSignUp"),  completed: nil)
        cell.rightLabel.text = BookingVM.shared.pastBookingRequestes[indexPath.row].date
        cell.ratingView.rating = BookingVM.shared.pastBookingRequestes[indexPath.row].rating ?? 0
        return cell
    }
}

//MARK: Tableview Delegate
extension PastBookingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookvc = self.storyboard?.instantiateViewController(withIdentifier: kPastBookingDetailsVC) as! PastBookingDetailsVC
        bookvc.index = indexPath.row
        self.navigationController?.show(bookvc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK:- API Calls
extension PastBookingVC {
    func callApiToGetBookingDetails(parameterDict: JSONDictionary) {
        BookingVM.shared.myBookings(dict: parameterDict){ (message, error) in
            if error == nil {
                self.tableView.reloadData()
            }else {
                self.showErrorMessage(error: error)
            }
        }
    }
}
