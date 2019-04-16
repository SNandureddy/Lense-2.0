//
//  CustomAlert.swift
//  QUTELINKS
//
//  Created by ios on 24/04/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit
import FloatRatingView

typealias ButtonAction = (()->())
typealias RatingAction = ((Double, String?)->())

protocol CustomAlertDelegate {
    func didSetRating(rating: Double)
}

class CustomAlert: UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak var titleBottomSingleView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    //MARK: Variables
    var delegate: CustomAlertDelegate?
    
    //MARK: Setup
    convenience init(title:String?, message: String?, cancelButtonTitle: String? = nil, doneButtonTitle: String = kOkay, isRatingView: Bool = false, titleBottomSingleView: Bool = false) {
        
        self.init(frame: UIScreen.main.bounds)
        self.initialize(title:title, message: message, cancelButtonTitle: cancelButtonTitle, doneButtonTitle: doneButtonTitle, isRatingView: isRatingView, titleBottomSingleView: titleBottomSingleView)
    }
    
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
    
    //MARK: Private Methods
    private func nibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView { //Load View from Nib
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func initialize(title:String?, message: String?, cancelButtonTitle: String? = nil, doneButtonTitle: String = kOkay, isRatingView: Bool = false , titleBottomSingleView: Bool = false) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        self.ratingView.isHidden = !isRatingView
        self.reviewTextView.isHidden = !isRatingView
        self.titleBottomSingleView.isHidden = !titleBottomSingleView
        self.reviewTextView.set(radius: 15.0, borderColor: UIColor.LensColor.darkColor.color(), borderWidth: 1.0)
        self.reviewTextView.text = kReviewPlaceholder
        self.reviewTextView.textColor = UIColor.lightGray
        self.reviewTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.reviewTextView.delegate = self
        self.ratingView.rating = 0.0
        self.titleLabel.isHidden = title == nil
        self.messageLabel.isHidden = message == nil
        self.cancelButton.isHidden = cancelButtonTitle == nil
        self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        self.cancelButton.layer.cornerRadius = 5.0
        self.doneButton.layer.cornerRadius = 5.0
        popUpView.layer.cornerRadius = 5.0
    }
    
    //MARK: Show Alert
    func show() {
        self.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    func remove() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.alpha = 0
        }, completion: {(success) in
            self.removeFromSuperview()
        })
    }

    //MARK: IBActions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.remove()
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.remove()
    }
    
}

extension CustomAlert: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == kReviewPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == kReviewPlaceholder {
            textView.text = kReviewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

//For Handle Action
class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}


//Add Target With Closure
extension UIControl {
    func addTarget (action: @escaping ()->()) {
        let sleeve = ClosureSleeve(action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: UIControl.Event.touchUpInside)
        objc_setAssociatedObject(self, String(ObjectIdentifier(self).hashValue) + String(UIControl.Event.touchUpInside.rawValue), sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
