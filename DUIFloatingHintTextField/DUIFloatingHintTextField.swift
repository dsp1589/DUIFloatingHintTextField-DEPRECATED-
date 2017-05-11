//
//  DUIFloatingHintTextField.swift
//  DUIFloatingHintTextField
//
//  Created by Dhanasekarapandian Srinivasan on 5/4/17.
//  Copyright © 2017 systameta. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldState{
    case ok
    case error
    case warning
    case darkerBg
}


class DUIFloatingHintTextField : UITextField{
    var aLayer  = CALayer()
    
    //Set Values from runtime attribute
    var floatingLabelTextColor : UIColor!{
        didSet{
            if let flTc = floatingLabelTextColor{
                self.hintLabel.textColor = flTc
            }
            
        }
    }
    
    var forceHidden : Bool = false
    
    let hintLabel = UILabel(frame: .zero)
    var hintLabelHeight : CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(aLayer)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(aLayer)
        setUp()
    }
    
    func setUp() {
        setUpHintLabel()
        self.contentVerticalAlignment = .bottom
        self.contentHorizontalAlignment = .left
        
        calcHeightForTextEditable()
    }
    
    func setUpHintLabel(){
        hintLabel.isOpaque = false
        hintLabel.textColor = UIColor.blue
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addTarget(self, action: #selector(DUIFloatingHintTextField.textEditing), for: UIControlEvents.editingChanged)
        self.addTarget(self, action: #selector(DUIFloatingHintTextField.textEditing), for: UIControlEvents.editingDidEnd)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeTarget(self, action: #selector(DUIFloatingHintTextField.textEditing), for: UIControlEvents.editingChanged)
        self.removeTarget(self, action: #selector(DUIFloatingHintTextField.textEditing), for: UIControlEvents.editingDidEnd)
    }
    
    override var bounds: CGRect {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        aLayer.frame = CGRect(x: rect.origin.x, y: rect.origin.y + rect.size.height - 1 , width: rect.size.width, height: 0.5)
        
        switch textFieldState{
        case .error:
            aLayer.backgroundColor = UIColor.red.cgColor
            break
        case .warning:
            aLayer.backgroundColor = UIColor.orange.cgColor
            break
        case .ok:
            aLayer.backgroundColor = UIColor.darkGray.cgColor
            break
        case .darkerBg:
            aLayer.backgroundColor = UIColor.white.cgColor
            break
        }
    }
    
    var textFieldState : TextFieldState = .ok{
        didSet{
            if textFieldState == .error || textFieldState == .warning{
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 10, y:self.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 10, y:self.center.y))
                self.layer.add(animation, forKey: "position")
            }
            self.setNeedsDisplay()
        }
    }
    
    override var text: String?{
        get{
            return super.text
        }
        set{
            super.text = newValue
            textEditing()
        }
    }
    
    func textEditing() -> Void {
        if !forceHidden{
            hintLabel.text = placeholder
            let size = hintLabel.sizeThatFits(CGSize(width: bounds.size.width, height: hintLabelHeight))
            
            if let t = text{
                if t.isEmpty{
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.hintLabel.alpha = 0.0
                        self.hintLabel.frame = CGRect(x: 0, y: (self.frame.size.height / 2 - size.height / 2), width: size.width, height: size.height)
                    }, completion: { (completed) in
                        self.hintLabel.removeFromSuperview()
                    })
                }else{
                    if hintLabel.superview == nil{
                        
                        hintLabel.frame = CGRect(x: 0, y: (self.frame.size.height / 2 - size.height / 2), width: size.width, height: size.height)
                        self.addSubview(hintLabel)
                    }
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.hintLabel.alpha = 1.0
                        self.hintLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    }, completion: { (completed) in
                        
                    })
                    UIView.animate(withDuration: 0.25, animations: {
                        
                    })
                    
                }
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.hintLabel.alpha = 0.0
                    self.hintLabel.frame = CGRect(x: 0, y: (self.frame.size.height / 2 - size.height / 2), width: size.width, height: size.height)
                }, completion: { (completed) in
                    self.hintLabel.removeFromSuperview()
                })
            }
        }
        
    }
    
    func calcHeightForTextEditable(){
        let l = UILabel(frame: CGRect(origin: .zero, size: bounds.size))
        l.font = font
        l.text = placeholder
        let s = l.sizeThatFits(CGSize(width: bounds.width, height: bounds.height))
        
        let availableHeightForHint = bounds.height - s.height
        
        hintLabel.text = placeholder
        hintLabel.font = UIFont(name: font!.fontName, size: (availableHeightForHint / s.height) * font!.pointSize)
        if availableHeightForHint > s.height{
            print("Adjust the font size of \(self.classForCoder)")
            forceHidden = true
        }
        hintLabelHeight = availableHeightForHint
    }
    
}
