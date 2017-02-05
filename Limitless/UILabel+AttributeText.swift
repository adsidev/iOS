//
//  UILabel+AttributeText.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/19/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let firstText = "LIMILESS"
        let lastText = "gameprep"
        let font = UIFont(name: "PierSans-Bold", size: 18.0)
        let subfont =  UIFont(name: "PierSans-Medium", size: 18.0)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: font , range: NSMakeRange(0, firstText.characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: subfont , range: NSMakeRange(firstText.characters.count, lastText.characters.count))
        
        self.attributedText = attributedString
    }
    func addCharactersSpacingWithDiffrentColoe(spacing:CGFloat, text:String) {
        let firstText = "LIMILESS"
        let secText = "game"
        let lastText = "prep"
        let color1 = UIColor.init(red: 1.0/255.0, green: 158.0/255.0, blue: 134.0/255.0, alpha: 1.0)
        let color2 = UIColor.init(red: 1.0/255.0, green: 205.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        let font = UIFont(name: "PierSans-Regular", size: 16.0)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: font , range: NSMakeRange(0, text.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color1, range: NSMakeRange(0,firstText.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color2, range: NSMakeRange(firstText.characters.count,secText.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color1, range: NSMakeRange( firstText.characters.count + secText.characters.count,lastText.characters.count))
        
        
        self.attributedText = attributedString
    }

}
