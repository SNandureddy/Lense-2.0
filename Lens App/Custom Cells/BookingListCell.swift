//
//  HistoryCell.swift
//  Lens App
//
//  Created by Apple on 31/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import FloatRatingView

class BookingListCell: UITableViewCell {
    
    //MARK: IBOutlets
   
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    
    //MARK: Class life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.set(radius: 25.0)
//        backView.set(radius: 4.0, borderColor: UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
