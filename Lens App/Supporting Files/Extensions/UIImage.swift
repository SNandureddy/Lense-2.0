//
//  UIImage.swift
//  Lens App
//
//  Created by Apple on 14/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation


extension UIImage {
    
    var imageData: Data {
        return self.jpegData(compressionQuality: 0.5)!
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            newSize =  CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width:  newSize.width, height: newSize.height)
        
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
