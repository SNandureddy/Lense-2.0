//
//  NotificationCell.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

 //       backView.set(radius: 4.0, borderColor: UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
