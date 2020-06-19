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
    
    func animateScaleToSize(scaleFrom: CGFloat, scaleTo: CGFloat, duration: TimeInterval){
        self.isHidden = true
        self.transform = CGAffineTransform(scaleX: scaleFrom, y: scaleFrom)
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: scaleTo, y: scaleTo)
                        self.isHidden = false
                        self.layoutIfNeeded()
        },  completion: nil)
    }
    
    func animateInFromLeft(duration: TimeInterval, delay: TimeInterval){
        self.isHidden = true
        let oldCenterX = self.center.x
        self.center.x -= 2 * oldCenterX
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn],
                       animations: {
                        self.center.x += 2 * oldCenterX
                        self.isHidden = false
                        self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateOutToTop(duration: TimeInterval, delay: TimeInterval){
        let oldCenterY = self.center.y
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= 2 * oldCenterY
                        self.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
            self.center.y += 2 * oldCenterY
        })
    }
}
