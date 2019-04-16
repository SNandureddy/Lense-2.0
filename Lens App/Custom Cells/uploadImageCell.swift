//
//  uploadImageCell.swift
//  Lense App
//
//  Created by ios on 15/11/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class uploadImageCell: UITableViewCell {
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageViewObject: UIImageView!
    @IBOutlet weak var uploadButtonObject: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageContainer.set(radius: 3.0, borderColor: UIColor.lightGray.withAlphaComponent(0.5), borderWidth: 1.0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
