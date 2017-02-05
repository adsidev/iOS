//
//  CNBTQuestionView.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTQuestionView: UIView {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var andtextField: UITextField!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func loadQuestion(Questiontext : String)  {
        
        questionTextView.text = Questiontext
    }

}
