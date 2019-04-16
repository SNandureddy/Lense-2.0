//
//  NotificationsVC.swift
//  Lens App
//
//  Created by Apple on 30/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    var page = 1
    var isDataLoading = false
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customiseUI()
        self.page = 1
        self.getNotifications(page: page)
        
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        tableView.estimatedRowHeight = 60.0
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        appDelegate.drawerContainer?.toggle(.left, animated: true, completion: nil)
    }
}

//MARK: Tableview Datasource
extension NotificationsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NotificationVM.shared.notifications.count == 0 {
            super.showEmptyScreen(superView: tableView)
        }else {
            super.hideEmptyScreen()
        }
        return NotificationVM.shared.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kNotificationCell) as! NotificationCell
        cell.notificationLabel.text = NotificationVM.shared.notifications[indexPath.row].message
        return cell
    }
}

//MARK: Tableview Delegates
extension NotificationsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height-50)
        {
            if !isDataLoading{
                isDataLoading = true
                DispatchQueue.global().async {
                    self.getNotifications(page: self.page)
                }
            }
        }
    }
}


//MARK: - API calls
extension NotificationsVC {
    
    func getNotifications(page: Int){
        NotificationVM.shared.getNotifications(page: page) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }else {
                self.tableView.reloadData()
                if  NotificationVM.shared.notifications.count >= 20 {
                    self.page += 1
                }
            }
        }
    }
}
