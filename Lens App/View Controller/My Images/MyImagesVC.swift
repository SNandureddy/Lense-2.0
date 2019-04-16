//
//  MyImagesVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class MyImagesVC: BaseVC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -  Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customiseUI()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var parameterDict = JSONDictionary()
        parameterDict[APIKeys.kBookingType] = 2
        self.loadCurrentBookingData(parameterDict:parameterDict)
    }
    
    //MARK: - Private Methods
    private func customiseUI() {
        tableView.tableFooterView = UIView()
    }
    
    //MARK: -  IBAction
    @IBAction func menuBarButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
}

//MARK: - Tableview Datasource
extension MyImagesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if BookingVM.shared.userBookingImages.count == 0 {
            super.showEmptyScreen(superView: tableView)
        }else {
            super.hideEmptyScreen()
        }
        return BookingVM.shared.userBookingImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kBookingListCell) as! BookingListCell
        cell.rightLabel.text = "Images: \(BookingVM.shared.userBookingImages[indexPath.row].bookingImages.count)"
        cell.nameLabel.text = BookingVM.shared.userBookingImages[indexPath.row].photographerName ?? ""
        cell.profileImageView.sd_setImage(with: BookingVM.shared.userBookingImages[indexPath.row].photographerImageUrl ?? URL(string: ""), placeholderImage: #imageLiteral(resourceName: "placeholder2"), completed: nil)
        cell.ratingView.rating = BookingVM.shared.userBookingImages[indexPath.row].photohgrapherRating ?? 1
        return cell
    }
}

//MARK: - Tableview Delegates
extension MyImagesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imagevc = self.storyboard?.instantiateViewController(withIdentifier: kImageListVC) as! ImageListVC
        imagevc.index = indexPath.row
        ViewImageVC.bookingId = BookingVM.shared.userBookingImages[indexPath.row].id
        self.navigationController?.show(imagevc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - API calls
extension MyImagesVC {
    
    func loadCurrentBookingData(parameterDict: JSONDictionary ){
        BookingVM.shared.getAllImages{ (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.tableView.reloadData()
            }
        }
    }
}
