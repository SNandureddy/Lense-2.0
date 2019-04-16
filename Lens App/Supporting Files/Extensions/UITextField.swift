//
//  UITextField.swift
//  Vits Video Calling Interpreter
//
//  Created by Apple on 07/08/17.
//  Copyright © 2017 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    var isEmpty: Bool {
        return self.text?.trimmingCharacters(in: .whitespaces).count == 0 ? true: false
    }
    
    var count: Int {
        return self.text?.count ?? 0
    }
    
    
    
    func setPlaceholder(placholder: String? = nil, color: UIColor, size: CGFloat, style: UIFont.LensFont) {
        
        let myPlaceholder = placholder ?? self.placeholder!
        let attributedString = NSAttributedString(string: myPlaceholder, attributes:[NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: style.fontWithSize(size: size)])
        self.tintColor = color
        self.font = style.fontWithSize(size: size)
        self.attributedPlaceholder = attributedString
    }
    
    
    //MARK: Validations
    var isValidEmail: Bool {
        let emailRegEx = kEmailCheck
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text!.lowercased())
    }

    var isValidPassword: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 6 ? true: false
    }
    
    var isValidName: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 2 ?  true: false
    }
    
    var isValidPhone: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 8 ? true: false
    }
    
    var isValidCardNumber: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 8 ? true: false
    }
    
    var isValidCVV: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 3 ? true: false
    }
    
    var isValidAccountNumber: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 7 ? true: false
    }
    
    var isValidBSBNumber: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 3 ? true: false
    }

}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}




