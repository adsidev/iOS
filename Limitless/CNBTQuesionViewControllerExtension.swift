//
//  CNBTQuesionViewControllerExtension.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 25/03/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation

extension CNBTQuestionViewController {
    
    func populatePopUpView(labelTexts: [String], labelColors: [UIColor], tag: Int, backgroundColor: UIColor) {
        
        let myView = PopUpAlert(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        myView.label1.text = labelTexts[0]
        myView.label2.text = labelTexts[1]
        myView.label3.text = labelTexts[2]
        myView.label1.textColor = labelColors[0]
        myView.label2.textColor = labelColors[1]
        myView.label3.textColor = labelColors[2]
        myView.center = self.view.center
        self.view.addSubview(myView)
        
        myView.secondView.backgroundColor = backgroundColor
        myView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            myView.transform = CGAffineTransform.identity
            var affineTransForm: CGAffineTransform!
            switch tag {
            case 0:
                affineTransForm = CGAffineTransform(rotationAngle: 0)
            case 1:
                affineTransForm = CGAffineTransform(rotationAngle: -CGFloat(M_PI_4))
            case 2:
                affineTransForm = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            default:
                break
            }
            myView.viewLabels.transform = affineTransForm
            
            
        }, completion: {(finished: Bool) -> Void in
            self.perform(#selector(self.hideView), with: myView, afterDelay: 0.5)
            
        })
    }
    
    func hideView(viewToBeHide: UIView) {
        viewToBeHide.removeFromSuperview()
    }
    
    //------------------------------ Draggble Button Actions ---------------------------------//
    
    func addGestureTobutton() {
        
        for i in 0..<3 {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(buttonDragged))
            switch i {
            case 0:
                answerButton1.addGestureRecognizer(panGesture)
            case 1:
                answerButton2.addGestureRecognizer(panGesture)
            case 2:
                answerButton3.addGestureRecognizer(panGesture)
            default:
                break
            }
        }
    }
    func buttonDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            frameOfRecognizer = gestureRecognizer.view?.frame
        } else if  gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            let viewsOverlap = CGRect(x:textField.frame.origin.x, y:textField.frame.origin.y + 20, width:textField.frame.size.width, height:textField.frame.size.height) .intersects(gestureRecognizer.view!.frame) || CGRect(x:viewTextfieldAndTextview.frame.origin.x, y:viewTextfieldAndTextview.frame.origin.y + 20, width:viewTextfieldAndTextview.frame.size.width, height:viewTextfieldAndTextview.frame.size.height - viewTextfieldAndTextview.frame.size.height / 1.5) .intersects(gestureRecognizer.view!.frame)
                
                //textField.frame .intersects(gestureRecognizer.view!.frame)
            
                //CGRect(x:textField.frame.origin.x, y:textField.frame.origin.y + 20, width:textField.frame.size.width, height:textField.frame.size.height) .intersects(gestureRecognizer.view!.frame)
            if viewsOverlap {
                gestureRecognizer.isEnabled = false
                let gestureView = gestureRecognizer.view as! UIButton
                textField.text = gestureView.titleLabel?.text
                textField.addShadowToTextfield()
                textField.backgroundColor = UIColor.red
                let sender = gestureRecognizer.view as? UIButton
                buttonActionSender(sender: sender!)
                
            }
        } else if  gestureRecognizer.state == .ended {
            
            print("State Ended")
            
        } else if gestureRecognizer.state == .cancelled {
            gestureRecognizer.isEnabled = true
        }
        
    }
    
}

extension UIColor {
    static func colorWithRGB(_ redValue: CGFloat, _ greenValue: CGFloat, _ blueValue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}

