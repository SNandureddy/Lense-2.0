//
//  SettingsCell.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    //MARK: IBOutlets
   
    @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet var availiabiltyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        backView.set(radius: backView.half, borderColor: UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
