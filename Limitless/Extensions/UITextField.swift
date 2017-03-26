//
//  UITextField.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 26/03/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation

extension UITextField {
    func addShadowToTextfield() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 1.0
    }
}
