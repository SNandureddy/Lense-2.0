//
//  PhotographerViewProfileVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class PhotographerViewProfileVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var descriptionLabelOuterView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchUserProfile(parameterDict: JSONDictionary())
        self.hideNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
  
    //MARK: Private Methods
    private func customiseUI() {
        profileImageView.set(radius: profileImageView.half, borderColor: UIColor.lightGray.withAlphaComponent(0.5), borderWidth: 1.0)
        editProfileButton.set(radius: 5.0)
        descriptionLabelOuterView.set(radius: 5.0, borderColor: UIColor.lightGray.withAlphaComponent(0.5), borderWidth: 1.0)
        shadowView.layer.cornerRadius = 5.0
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
    }
    
    private func setUpdata(){
        if let userDetailDict = DataManager.userDetails {
            let userDetail = UserDetails(userDetails: userDetailDict)
            self.profileImageView.sd_setImage(with: URL(string : userDetail.image ?? ""), placeholderImage: #imageLiteral(resourceName: "User_02"), options: .refreshCached, completed: nil)
            self.nameLabel.text = userDetail.name
            self.emailLabel.text = userDetail.email
            self.phoneNumberLabel.text = userDetail.phoneNumber
            self.descriptionLabel.text = userDetail.description
        }
    }
    
    	//MARK: IBActions
    @IBAction func backBuutonAction(_ sender: Any) {
        self.backButtonAction()
    }
    @IBAction func editButtonAction(_ sender: UIButton) {
        let editvc = self.storyboard?.instantiateViewController(withIdentifier: kPhotographerEditProfileVC) as! PhotographerEditProfileVC
        self.navigationController?.show(editvc, sender: self)
    }
}

//MARK: - API calls
extension PhotographerViewProfileVC {
    
    func fetchUserProfile(parameterDict: JSONDictionary){
        SettingVM.shared.fetchUserProfile(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.setUpdata()
            }
        }
    }
    
}
