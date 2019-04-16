//
//  SideMenuCell.swift
//  Lense App
//
//  Created by Deftsoft on 06/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var menuItemlabel: UILabel!
    @IBOutlet weak var menuItemImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
