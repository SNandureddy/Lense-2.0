//
//  PhotographerBookingsVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class PhotographerBookingsVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentBookingsButton: UIButton!
    @IBOutlet weak var newBookingsButton: UIButton!
    @IBOutlet weak var currentBookingSingleView: UIView!
    @IBOutlet weak var newBookingSingleView: UIView!
    
    //MARK: Variables
    var screenType = kNew
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        self.customiseUI()
        if screenType == kNew {
            self.callApitogetBookings(type: 3)
        }
        else {
            self.callApitogetBookings(type: 1)
        }
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        if DataManager.userType == kUser || DataManager.userType == kBusinessUser {
            self.currentBookingsButton.setTitle("Past Booking", for: .normal)
            self.newBookingsButton.setTitle("Current Booking", for: .normal)
        }else if DataManager.userType == kPhotographer{
            self.currentBookingsButton.setTitle("Current Booking", for: .normal)
            self.newBookingsButton.setTitle("New Booking", for: .normal)
        }
  
    }
    
    private func callApitogetBookings(type: Int){
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingType] = type
        self.loadBookingData(parameterDict: parameterDict)
    }
    
    private func showHideEmptyScreen(){
        if screenType ==  kNew {
            if BookingVM.shared.bookingRequestes.count == 0 {
                super.showEmptyScreen(superView: self.tableView)
            }else {
                super.hideEmptyScreen()
            }
        }else {
            if BookingVM.shared.currentBookingRequestes.count == 0 {
                super.showEmptyScreen(superView: self.tableView)
            }else {
                super.hideEmptyScreen()
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func headerButtonAction(_ sender: UIButton) {
//        screenType = sender == newBookingsButton ? kNew: kCurrent
//        sender == currentBookingsButton ? callApitogetBookings(type: 3): callApitogetBookings(type: 1)
        self.view.endEditing(true)
        if sender == newBookingsButton {
                screenType = kNew
                newBookingsButton.isSelected = true
                currentBookingsButton.isSelected = false
                newBookingsButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: UIControl.State.normal)
                newBookingSingleView.backgroundColor = UIColor.LensColor.pinkcolor.color()
                currentBookingSingleView.backgroundColor = UIColor.LensColor.lightGray.color()
                currentBookingsButton.setTitleColor(UIColor.LensColor.lightGray.color(), for: UIControl.State.normal)
                callApitogetBookings(type: 3)
              }else if sender == currentBookingsButton{
                screenType = kCurrent
                currentBookingsButton.isSelected = true
                newBookingsButton.isSelected = false
                currentBookingsButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: UIControl.State.normal)
                currentBookingSingleView.backgroundColor = UIColor.LensColor.pinkcolor.color()
                newBookingSingleView.backgroundColor = UIColor.LensColor.lightGray.color()
                newBookingsButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
                callApitogetBookings(type: 1)
            }
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
}
    
    func setUpInitialview(){
        newBookingsButton.isSelected = true
        currentBookingsButton.isSelected = false
        newBookingsButton.setTitleColor(UIColor.LensColor.pinkcolor.color(), for: UIControl.State.normal)
        newBookingSingleView.backgroundColor = UIColor.LensColor.pinkcolor.color()
        currentBookingSingleView.backgroundColor = UIColor.LensColor.lightGray.color()
        currentBookingsButton.setTitleColor(UIColor.LensColor.lightGray.color(), for: UIControl.State.normal)
        callApitogetBookings(type: 3)
    }
}

//MARK: Tableview Datasource
extension PhotographerBookingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.showHideEmptyScreen()
        return screenType == kNew ? BookingVM.shared.bookingRequestes.count: BookingVM.shared.currentBookingRequestes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kBookingListCell) as! BookingListCell
        
        if screenType == kNew {
            cell.ratingView.isHidden = true
            cell.nameLabel.text = BookingVM.shared.bookingRequestes[indexPath.row].name
            cell.rightLabel.text = BookingVM.shared.bookingRequestes[indexPath.row].date
            cell.profileImageView.sd_setImage(with: BookingVM.shared.bookingRequestes[indexPath.row].image, placeholderImage: #imageLiteral(resourceName: "placeholder2"), completed: nil)
        }else {
            cell.ratingView.isHidden = false
            cell.ratingView.rating = BookingVM.shared.currentBookingRequestes[indexPath.row].userRating ?? 0
            cell.nameLabel.text = BookingVM.shared.currentBookingRequestes[indexPath.row].name ?? ""
            cell.rightLabel.text = BookingVM.shared.currentBookingRequestes[indexPath.row].date ?? ""
            cell.profileImageView.sd_setImage(with: BookingVM.shared.currentBookingRequestes[indexPath.row].image ?? URL(string:""), placeholderImage: #imageLiteral(resourceName: "placeholder2"), completed: nil)
        }
        return cell
    }
}

//MARK:- Tableview Delegate
extension PhotographerBookingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenType == kNew {
            let newvc = self.storyboard?.instantiateViewController(withIdentifier: kNewBookingDetaislVC) as! NewBookingDetaislVC
            newvc.index = indexPath.row
            self.navigationController?.show(newvc, sender: self)
        }
        else {
            let newvc = self.storyboard?.instantiateViewController(withIdentifier: kCurrentBookingDetailsVC) as! CurrentBookingDetailsVC
            newvc.index = indexPath.row
            self.navigationController?.show(newvc, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - API Calls
extension PhotographerBookingsVC {
    
    func loadBookingData(parameterDict: JSONDictionary ){
        BookingVM.shared.myBookings(dict: parameterDict){ (message, error) in
            if error == nil {
                self.tableView.reloadData()
            }else {
                self.tableView.reloadData()
                self.showErrorMessage(error: error)
            }
        }
    }
}
