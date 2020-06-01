//
//  AnimationsUIViewExtensions.swift
//  QuizApp
//
//  Created by five on 31/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit
import Foundation

public extension UIView{
    
    func animateInFromBottom(){
        self.center.y += self.bounds.height
        self.alpha = 0.5
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.alpha = 1
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    
    func animateOutToBottom(){
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.alpha = 0
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
            self.center.y -= self.bounds.height
        })
    }
    
    func animateScaleFromZero(){
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.layoutIfNeeded()
        },  completion: nil)
    }
}
