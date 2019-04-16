//
//  BookingHistoryVC.swift
//  Lens App
//
//  Created by Apple on 31/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit


class BookingHistoryVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callApiToloadPastBookings()
    }
}

//MARK: Tableview Datasource
extension BookingHistoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BookingVM.shared.userPastBookings.count == 0 ? showEmptyScreen() : hideEmptyScreen()
        return BookingVM.shared.userPastBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kBookingListCell) as!  BookingListCell

        cell.profileImageView.sd_setImage(with: BookingVM.shared.userPastBookings[indexPath.row].photographerImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder2"), completed: nil)
        cell.nameLabel.text = BookingVM.shared.userPastBookings[indexPath.row].photographerName
        cell.rightLabel.text = BookingVM.shared.userPastBookings[indexPath.row].date //Format: "July 26, 2018"
        cell.ratingView.rating = BookingVM.shared.userPastBookings[indexPath.row].photohgrapherRating ?? 0
        return cell
    }
    
}

//MARK: Tableview Delegates
extension BookingHistoryVC: UITableViewDelegate {   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookingDetailvc = self.storyboard?.instantiateViewController(withIdentifier: kBookingDetailsVC) as! BookingDetailsVC
        bookingDetailvc.screenType = kPast
        bookingDetailvc.pastDetails = BookingVM.shared.userPastBookings[indexPath.row]
         self.navigationController?.show(bookingDetailvc, sender: self)
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
 }

        //MARK:- API Calls
extension BookingHistoryVC {
    
    func callApiToloadPastBookings() {
        let dict = [APIKeys.kBookingType: 2]
        BookingVM.shared.myBookings(dict: dict) { (message, error) in
            if error != nil{
                super.showErrorMessage(error: error)
            }else {
                self.tableView.reloadData()
            }
        }
    }
}
