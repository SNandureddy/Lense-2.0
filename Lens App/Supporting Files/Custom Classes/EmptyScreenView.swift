//
//  EmptyScreenView.swift
//  BygApp
//
//  Created by Prince Agrawal on 02/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

@IBDesignable class EmptyScreenView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    convenience init(image: UIImage, title: String, description: String) {
        self.init()
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    //MARK: Private Methods
    private func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EmptyScreenView", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
