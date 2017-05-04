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
    
    let hintLabel = UILabel(frame: .zero)
    var hintLabelHeight : CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpHintLabel()
        self.contentVerticalAlignment = .bottom
        self.contentHorizontalAlignment = .left
        calcHeightForTextEditable()
    }
    
    func setUpHintLabel(){
        hintLabel.isOpaque = false
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
        
        hintLabel.text = placeholder
        hintLabel.adjustsFontSizeToFitWidth = true
        let size = hintLabel.sizeThatFits(CGSize(width: bounds.size.width, height: hintLabelHeight))
        if let t = text{
            if t.isEmpty{
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
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
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.hintLabel.alpha = 0.0
                self.hintLabel.frame = CGRect(x: 0, y: (self.frame.size.height / 2 - size.height / 2), width: size.width, height: size.height)
            }, completion: { (completed) in
                self.hintLabel.removeFromSuperview()
            })
        }
    }
    
    func calcHeightForTextEditable(){
        let l = UILabel(frame: CGRect(origin: .zero, size: bounds.size))
        l.font = self.font
        l.text = placeholder
        hintLabelHeight =
        bounds.height - l.sizeThatFits(CGSize(width: bounds.width, height: bounds.height)).height - 2
        
    }

}
