//
//  PastBookingCell.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class PastBookingCell: BookingListCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
