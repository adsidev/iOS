//
//  LMCustomLabel.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 26/02/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit
@IBDesignable
class LMCustomLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var boarderColor: UIColor = UIColor.clear {
        
        didSet {
            self.layer.borderColor = boarderColor.cgColor
        }
    }

}
