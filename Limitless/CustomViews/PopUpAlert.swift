//
//  PopUpAlert.swift
//  JSAlert
//
//  Created by Sunilkumar Gavara on 19/03/17.
//  Copyright © 2017 Sunilkumar Gavara. All rights reserved.
//

import UIKit

class PopUpAlert: UIView {

    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var viewLabels: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var secondView: UIView!

    override func awakeFromNib() {
        let view = Bundle.main.loadNibNamed("PopUpAlert", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("PopUpAlert", owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        self.viewGradient.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4));
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
