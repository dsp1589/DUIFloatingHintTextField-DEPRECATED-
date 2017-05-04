//
//  DUIFloatingHintTextField.swift
//  DUIFloatingHintTextField
//
//  Created by Dhanasekarapandian Srinivasan on 5/4/17.
//  Copyright © 2017 systameta. All rights reserved.
//

import Foundation
import UIKit



class DUIFloatingHintTextField : UITextField{
    
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
       setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
//        if let f = self.font{
//            hintLabel.font = UIFont(name: f.fontName, size: f.pointSize / 1.7)
//        }
        
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
