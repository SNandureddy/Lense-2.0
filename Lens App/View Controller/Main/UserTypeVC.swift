//
//  UserTypeVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.

import UIKit

class UserTypeVC: BaseVC {
    
    //MARK: IBOutlet
    @IBOutlet var buttonCollection: [UIView]!
    
    //MARK: Variables
    var socialDict = JSONDictionary()
    
    //MARK: Class Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
   
    //MARK: IBActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.backButtonAction()
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let uservc = segue.destination as? SignupVC  {
            uservc.socialDict = self.socialDict
            switch segue.identifier{
            case kUserSignupSegue:
                uservc.userType =  kUser
            case kBusinessUserSignupSegue:
                uservc.userType = kBusinessUser
            default:
                uservc.userType = kPhotographer
            }
        }
    }
}
