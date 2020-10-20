//
//  UITextfieldExt.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/20/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import Foundation
import  UIKit

extension UITextField {
    
    func setPadding(width:CGFloat){
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
           self.leftView = paddingView
           self.leftViewMode = .always
    }
}
