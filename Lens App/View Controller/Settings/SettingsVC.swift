//
//  SettingsVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import SwiftLuhn

class SettingsVC: BaseVC {
    
    //MARK IBOutlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: Variables
    var screenType = kUser
    var userSettingsArray = ["Edit Profile", "Change Password", "Manage Credit Card"]
    var photographerSettingsArray = ["Edit Profile", "Change Password", "Update Working Distance", "Update Bank Details"] //"Availability"]
   
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    
    //MARK: IBAction
    @IBAction func menuBarButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
}

//MARK: Tableview Datasource
extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (screenType == kUser || screenType == kBusinessUser)  ? userSettingsArray.count: photographerSettingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSettingsCell) as! SettingsCell
        
        cell.titleLabel.text = (screenType == kUser || screenType == kBusinessUser)  ? userSettingsArray[indexPath.row]: photographerSettingsArray[indexPath.row]
       
//        if screenType == kPhotographer && indexPath.row == photographerSettingsArray.count-1 {
//            let cell1 = tableView.dequeueReusableCell(withIdentifier: kAvailabilityCell)!
//
//            cell1.viewWithTag(1)!.set(radius: cell1.viewWithTag(1)!.half, borderColor: UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1.0)
//             cell1.viewWithTag(2)?.isHidden = true
//            (cell1.viewWithTag(2) as! UIButton).addTarget {
//                let availability = (cell1.viewWithTag(2) as! UIButton).isSelected ? 2: 1
//
//                self.callAPItoSetAvailability(availability: availability)
//            }
//            (cell1.viewWithTag(2) as! UIButton).isSelected = DataManager.availability
//            return cell1
//        }
        return cell
    }
}

//MARK: Tableview Delegate
extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (screenType == kUser || screenType == kBusinessUser)  ? self.userAction(index: indexPath.row): photographerAction(index: indexPath.row)
    }
    
    func userAction(index: Int) {
        switch index {
        case 0: //View Profile
            let viewvc = self.storyboard?.instantiateViewController(withIdentifier: kViewProfileVC) as! ViewProfileVC
            self.navigationController?.show(viewvc, sender: self)
            return
        case 1: //Change Password
            let changevc = self.storyboard?.instantiateViewController(withIdentifier: kChangePasswordVC) as! ChangePasswordVC
            self.navigationController?.show(changevc, sender: self)
            return
        case 2: //Manage Card
            let cardvc = self.storyboard?.instantiateViewController(withIdentifier: kCardDetailsVC) as! CardDetailsVC
            cardvc.screenType = kUpdate
            self.navigationController?.show(cardvc, sender: self)
            return
        default:
            return
        }
    }
    
    func photographerAction(index: Int) {
        switch index {
        case 0: //View Profile
            let viewvc = self.storyboard?.instantiateViewController(withIdentifier: kPhotographerViewProfileVC) as! PhotographerViewProfileVC
            self.navigationController?.show(viewvc, sender: self)
            return
        case 1: //Change Password
            let changevc = self.storyboard?.instantiateViewController(withIdentifier: kChangePasswordVC) as! ChangePasswordVC
            self.navigationController?.show(changevc, sender: self)
            return
        case 2: //Update Working Address
            let distancevc = self.storyboard?.instantiateViewController(withIdentifier: kDistanceVC) as! DistanceVC
            distancevc.screenType = kUpdate
            self.navigationController?.show(distancevc, sender: self)
            return
        case 3: //Update Bank Details
            let bankvc = self.storyboard?.instantiateViewController(withIdentifier: kBankDetailsVC) as! BankDetailsVC
            bankvc.screenType = kUpdate
            self.navigationController?.show(bankvc, sender: self)
            return
        default:
            return
        }
    }
}

extension SettingsVC {
    
    func callAPItoSetAvailability(availability: Int) {
        UserVM.shared.setAvailability(availability: availability) { (message, error) in
            if error == nil {
                let indexPath = IndexPath(row: self.photographerSettingsArray.count-1, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath)
                (cell!.viewWithTag(2) as! UIButton).isSelected = !(cell!.viewWithTag(2) as! UIButton).isSelected
                DataManager.availability = (cell!.viewWithTag(2) as! UIButton).isSelected
            }
            else {
                self.showErrorMessage(error: error)
            }
        }
    }
}


