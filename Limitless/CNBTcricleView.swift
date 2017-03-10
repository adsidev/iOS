//
//  CNBTcricleView.swift
//  testCricle
//
//  Created by Jayprakash Kumar on 1/19/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTcricleView: UIView {
    var circleLayer: CAShapeLayer!
    var midelLayer : CAShapeLayer!
    
    override init(frame : CGRect){
        super.init(frame : frame)
        self.backgroundColor = UIColor.clear
       
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.init(red: 238.0/255.0, green: 102.0/255.0, blue: 106.0/255.0, alpha: 0.8).cgColor
        circleLayer.lineWidth = frame.size.width - 30;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        let circlePath1 = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (10), startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        midelLayer = CAShapeLayer()
        midelLayer.path = circlePath1.cgPath
        midelLayer.fillColor = UIColor.red.cgColor
        midelLayer.strokeColor = UIColor.red.cgColor
        midelLayer.lineWidth = 0.0;
        layer.addSublayer(midelLayer)
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    

}
