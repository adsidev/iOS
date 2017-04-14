//
//  PopUpAlert.swift
//  JSAlert
//
//  Created by Sunilkumar Gavara on 19/03/17.
//  Copyright © 2017 Sunilkumar Gavara. All rights reserved.
//

import UIKit

class PopUpAlert: UIView {

    @IBOutlet weak var viewLabels: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var secondView: UIView!
    
    var InsideColor: UIColor!
    var OutsideColor: UIColor!

    var gradientLayer = RadialGradientLayer()

    var colors: [UIColor] {
        get {
            return gradientLayer.colors
        }
        set {
            gradientLayer.colors = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTitle(text: String) {
        label1.text = text
    }
    func setScore(text: String) {
        label2.text = text
    }
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
        if gradientLayer.superlayer == nil {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = view.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class RadialGradientLayer: CALayer {
    

    var center: CGPoint {
        return CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    var radius: CGFloat {
        return (bounds.width + bounds.height)/2
    }
    
    var colors: [UIColor] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cgColors: [CGColor] {
        return colors.map({ (color) -> CGColor in
            return color.cgColor
        })
    }
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 0.6]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            return
        }
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
}
