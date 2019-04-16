//
//  BookingNotesCell.swift
//  Lens App
//
//  Created by Apple on 27/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class BookingNotesCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addNotesButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
