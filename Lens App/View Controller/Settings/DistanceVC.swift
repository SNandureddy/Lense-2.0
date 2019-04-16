//
//  DistanceVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class DistanceVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var availabilityButton: UIButton!
    @IBOutlet weak var availabilityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var avilaibilityContainerView: UIView!
    
    //MARK: Variables
    var screenType = kNew
    var socialDict = JSONDictionary()
    var distance = 0.56
    var imageDict = [String: Data]()
    
    
    //MARK: Class Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.set(title: screenType == kUpdate ? kUpdateDistance: kAddDistance)
        self.headerTitle.text = screenType == kUpdate ? kUpdateDistance: kAddDistance
         self.customiseUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    //MARK: Private Methods
    private func customiseUI() {
       // let image = #imageLiteral(resourceName: "thumbImage").resizeImage(targetSize: CGSize(width: 30, height: 30))
        distanceSlider.setThumbImage(#imageLiteral(resourceName: "thumbImage"), for: .normal)
        distanceSlider.setThumbImage(#imageLiteral(resourceName: "thumbImage"), for: .highlighted)
        if screenType == kNew {
            avilaibilityContainerView.isHidden = true
            availabilityHeightConstraint.constant = 0.0
        }else{
            avilaibilityContainerView.isHidden = true
            availabilityHeightConstraint.constant = 0.0
            nextButton.setTitle(kUPDATE, for: .normal)
        }
        nextButton.set(radius: 5.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        distanceSlider.value = Float(DataManager.distance ?? 0)
        distanceLabel.text = String(format: "%.2f Miles", DataManager.distance ?? 0)
        if (DataManager.distance ?? 0) <= 0.06 {
            distanceLabel.text = "100 Yards"
        }
           self.hideNavigationBar()

    }
    //MARK: IBActions
    @IBAction func availabilityButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func distanceSliderAction(_ sender: UISlider) {
        let value = sender.value
        distance = Double(sender.value).roundValue
       distanceLabel.text = String(format: "%.2f Miles", value)
        if sender.value == 0.056 {
            distanceLabel.text = "100 Yards"
        }
           }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if screenType == kNew {
            self.addData()
            let bankvc = self.storyboard?.instantiateViewController(withIdentifier: kBankDetailsVC) as! BankDetailsVC
            bankvc.imageDict = imageDict
            bankvc.socialDict = self.socialDict
            self.navigationController?.show(bankvc, sender: self)
        }
        else {
            //call api
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kDistance] = self.distance
            self.callApiForUpdateDistance(parameterDict: parameterDict)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
}

//MARK: Validate Data
extension DistanceVC {
    
    func addData() {
        BaseVC.userDetails.distance = distance
        BaseVC.userDetails.availability = availabilityButton.isSelected
    }
}

// MARK: - API Calls
extension DistanceVC {
    
    func callApiForUpdateDistance(parameterDict: JSONDictionary){
        NotificationVM.shared.updateDistance(dict: parameterDict) { (message, error) in
            if error != nil {
                super.showErrorMessage(error: error)
            }else {
                self.showAlert(title: kSuccess, message: kDistanceDetailsSuccess, {
                   DataManager.distance = self.distance
                    self.backButtonAction()
                })
            }
        }
    }
}
