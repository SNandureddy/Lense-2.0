//
//  BookinDetailVC.swift
//  Lens App
//
//  Created by Apple on 24/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

enum BookingDetailType {
    case newPhotographer
    case currentUser
    case currentPhotographer
    case pastUser
    case pastPhotographer
}


import UIKit

class BookingDetailVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var manageImageButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var acceptView: UIStackView!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    //MARK: IBOutlets
    var screenType: BookingDetailType = .currentUser
    var array = [String]()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let header = headerView {
            let rect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height/5.38)
            if !rect.equalTo(header.frame) {
                header.frame = rect
                headerView = header
            }
        }
    }
    
    //MARK: Private Methods
    private func setupScreenType() {
        switch screenType {
        case .currentPhotographer:
            array = kCurrentPhotographerArray
            
            break
        case .currentUser:
            array = kCurrentUserArray
            acceptView.isHidden = true
            footerView = UIView()
            
            break
        case .pastUser:
            array = kPastUserArray
            break
        case .pastPhotographer:
            array = kPastPhotographerArray
            break
        case .newPhotographer:
            array = kNewPhotographerArray
            break
        }
        tableView.reloadData()
    }
    
    //MARK: IBActions
    @IBAction func manageImageAction(_ sender: UIButton) {
    }
    
    @IBAction func navigateButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
    }
}

extension BookingDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UITableViewCell()
    }
}
