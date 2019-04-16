//
//  ViewProfileVC.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class ViewProfileVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchUserProfile(parameterDict: JSONDictionary())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
        self.customizeViews()
        
    }
    
    //MARK: Private Methods
    private func customiseUI() {
       self.profileImageView.set(radius: profileImageView.half, borderColor: UIColor.white.withAlphaComponent(0.5), borderWidth: 1.0)
        editProfileButton.set(radius: editProfileButton.half)
    }
    
    private func setupData() {
        if let userDetailDict = DataManager.userDetails {
            let userDetail = UserDetails(userDetails: userDetailDict)
            self.profileImageView.sd_setImage(with: URL(string : userDetail.image ?? ""), placeholderImage: #imageLiteral(resourceName: "User_01"), options: .refreshCached, completed: nil)
            nameLabel.text = userDetail.name
            emailLabel.text = userDetail.email
    
        }
    }

    //MARK: IBActions
    @IBAction func editButtonAction(_ sender: UIButton) {
        let viewvc = self.storyboard?.instantiateViewController(withIdentifier: kEditProfileVC) as! EditProfileVC
        self.navigationController?.show(viewvc, sender: self)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.backButtonAction()
    }
}
//MARK: - API calls
extension ViewProfileVC {
    
    func fetchUserProfile(parameterDict: JSONDictionary){
        SettingVM.shared.fetchUserProfile(dict: parameterDict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
               self.setupData()
            }
        }
    }
    
}

// MARK: - Customization
extension ViewProfileVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
        editProfileButton.layer.cornerRadius = 5.0
        
    }
}
