//
//  BookingDetailCell.swift
//  Lens App
//
//  Created by Apple on 24/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class BookingDetailCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
