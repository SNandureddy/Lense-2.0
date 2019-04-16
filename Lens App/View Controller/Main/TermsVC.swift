//
//  TermsVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class TermsVC: BaseVC {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var termsWebView: UIWebView!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customiseUI()
        self.hideNavigationBar()
        self.customizeViews()
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        termsWebView.scrollView.contentInset = UIEdgeInsets(top: -8, left: -10, bottom: 0, right: -10)
        loadWebView()
    }
    
    func loadWebView(){
        if let docPath = Bundle.main.path(forResource: "LenseTermsOfService", ofType: "docx"){
            let url = URL(fileURLWithPath: docPath)
            let request = URLRequest(url: url)
            termsWebView.loadRequest(request)
        }
    }
}

// MARK: - Customization
extension TermsVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
    }
}
