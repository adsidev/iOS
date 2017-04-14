//
//  CNBTQuesionViewControllerExtension.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 25/03/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation

extension CNBTQuestionViewController {
    
    func populatePopUpView(score: String, scoreValue: Int) {
        
        let myView = PopUpAlert(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        //(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let scoreAndColor = getColorAndTitle(score: scoreValue)
        let colorInside = UIColor.lightText
        myView.gradientLayer.colors = [colorInside, scoreAndColor.0]
        myView.setTitle(text: scoreAndColor.1)
        myView.setScore(text: score)
        self.view.addSubview(myView)
       // myView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
       /* UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {() -> Void in
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
            
        })*/
        
        
    }
    func getColorAndTitle(score: Int) -> (UIColor, String) {
        switch score {
        case 5:
            return (UIColor.colorWithRGB(1, 138, 118, 0.9), "EXCELLENT")
        case 10:
            return (UIColor.colorWithRGB(28, 118, 215, 0.9), "EXCELLENT")
        case 25:
            return (UIColor.colorWithRGB(255, 134, 1, 0.9), "WOW")
        case 50:
            return (UIColor.colorWithRGB(255, 6, 2, 0.9), "AWSOME")
        case 100:
            return (UIColor.colorWithRGB(1, 36, 78, 0.9), "UNREAL")
        default:
            return (UIColor.colorWithRGB(1, 36, 78, 0.9), "EXCELENT")

        }
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
            let viewsOverlap = CGRect(x:textField!.frame.origin.x, y:textField!.frame.origin.y + 20, width:textField!.frame.size.width, height:textField!.frame.size.height) .intersects(gestureRecognizer.view!.frame) || CGRect(x:textViewDraggable!.frame.origin.x, y:textViewDraggable!.frame.origin.y + 20, width:textViewDraggable!.frame.size.width, height:textViewDraggable!.frame.size.height - textViewDraggable!.frame.size.height / 1.5) .intersects(gestureRecognizer.view!.frame)
             if viewsOverlap {
                gestureRecognizer.isEnabled = false
                let gestureView = gestureRecognizer.view as! UIButton
                textField?.text = gestureView.titleLabel?.text
                let sender = gestureRecognizer.view as? UIButton
                buttonActionSender(sender: sender!)
            }
        } else if  gestureRecognizer.state == .ended {
            
            print("State Ended")
            
        } else if gestureRecognizer.state == .cancelled {
            gestureRecognizer.isEnabled = true
        }
        
    }
    func addTextBoxQuestionContent(text: String, isDraggable: Bool) {
        textViewDraggable?.layer.borderColor = UIColor.lightGray.cgColor
        textViewDraggable?.layer.borderWidth = 1.0
        textViewDraggable?.layer.cornerRadius = 3
        textViewDraggable?.isEditable = false
        textViewDraggable?.contentOffset = CGPoint(x: 0, y: 50)
        let arrayofStrings = text.components(separatedBy: "answer")
        textViewDraggable!.font = UIFont(name: "PiesSans", size: 12)
        var text1 = ""
        var text2 = ""
        for (index,textString) in arrayofStrings.enumerated() {
            if index == 0 {
                text1 = textString
            } else {
                text2 = textString
            }
        }
        if text1.characters.count > 0 {
            text1 = text1.substring(to: text1.index(before: text1.endIndex))
        }
        if text2.characters.count > 0 {
            text2.remove(at: text2.startIndex)
        }
        
        let styleTextView = NSMutableParagraphStyle()
        styleTextView.lineSpacing = 10
        let attributeTextTExtview = NSAttributedString(string: text1, attributes: [NSParagraphStyleAttributeName: styleTextView])
        textViewDraggable!.frame = CGRect(x: 10, y: textViewDraggable!.frame.origin.y + 20, width: self.view.frame.size.width - 20, height: textViewDraggable!.frame.size.height - 20)
        
        textViewDraggable!.attributedText = attributeTextTExtview
        let textPos2 = textViewDraggable!.position(from: textViewDraggable!.endOfDocument, offset: 0)
        let result = textViewDraggable!.caretRect(for: textPos2!)
        
        
        
        let width = textViewDraggable!.frame.size.width - result.origin.x
        let yOfTextfield = width < 100 ?  result.origin.y + 20 : result.origin.y - 5
        let xOfTExtfield = width < 100 ? 5 : result.origin.x + 5
        let widthOfTextField: CGFloat = isDraggable ? 100 : 0
        
        
        textField = UITextField(frame: CGRect(x: xOfTExtfield, y: yOfTextfield, width: widthOfTextField, height: 25))
//        textField!.font = UIFont(name: "PiesSans", size: 2)
        textField!.isEnabled = false
        textField!.textColor = UIColor.white
        textField?.textAlignment = .center
        textField!.layer.borderColor = UIColor.black.cgColor
        textField!.layer.borderWidth = 1
        textField!.layer.cornerRadius = 4
        textViewDraggable!.addSubview(textField!)
        textField!.addShadow()
        let maxXOfView = textField!.frame.origin.x + textField!.frame.size.width
        let yOfLabel = textViewDraggable!.frame.width - maxXOfView < 50 ? textField!.frame.origin.y + 30: textField!.frame.origin.y + 5
        let contentOffSet = textViewDraggable!.frame.width - maxXOfView < 50 ? 0 : maxXOfView
        let label = UILabel(frame: CGRect(x: 5, y: yOfLabel, width: textViewDraggable!.frame.size.width - 10, height: 200))
        label.font = textViewDraggable!.font
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.firstLineHeadIndent = contentOffSet
        let attributeText = NSAttributedString(string:
            text2, attributes: [NSParagraphStyleAttributeName: style])
        label.attributedText = attributeText
        label.numberOfLines = 0
        let neededSize = label.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.size.width, height: neededSize.height)
        label.lineBreakMode = .byWordWrapping
        textViewDraggable!.addSubview(label)
        
        textViewDraggable!.contentSize = CGSize(width: textViewDraggable!.frame.size.width, height: label.frame.origin.y + label.frame.size.height)
        
    }

}

extension UIColor {
    static func colorWithRGB(_ redValue: CGFloat, _ greenValue: CGFloat, _ blueValue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}

